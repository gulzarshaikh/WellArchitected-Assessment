# All content of the 'data' directory is parsed and merged into a single json file
# that contains all the input. We're saving this one-up from the checked-out structure
# to avoid name collisions with files in the repo.

$dataDir = "../../data"
$templateDir = "../../templates"
$generatorDir = "generator"
$outputDir = "assesments"

# Cleanup
# -------
if (Test-Path $generatorDir) {
    Remove-Item $generatorDir -Recurse
}

New-Item -ItemType Directory $generatorDir
New-Item -ItemType Directory $generatorDir/data
New-Item -ItemType Directory $generatorDir/output


# Validate JSON
# -------------
Get-ChildItem -Path $dataDir | % {
    $file = $_.FullName
    $content = Get-Content -Path $file
    try {
        $json = $content | ConvertFrom-Json
    }
    catch {
        Write-Error "Invalid JSON in file $file"
    }
}


# Merge data files
# ----------------
$AllItems = @()
Get-ChildItem -Path $dataDir | where { $_.Name -match ".data.json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | %{
        if($_) 
        {
            $AllItems += $_
        }
    }
}

$AllItems | ConvertTo-Json -Depth 10 | Out-File $generatorDir/data/input.json

Copy-Item $templateDir/config.toml -Destination $generatorDir/ -Force

# Copy the rest of data files which don't contain questions, e.g. categories
Get-ChildItem -Path $dataDir | where { $_.Name -notmatch ".data.json$" } | % {
    Copy-Item -Path $_.FullName -Destination $generatorDir/data
}


      
# Prepare content files for Hugo.          
Get-ChildItem -Recurse -File $templateDir -Filter "*.md" | % {
    # Get output names in the form of "pillar-lens" (e.g. "opex-servicelens").
    # Currently this approach is limited to one level of nesting and will not work for deeper sub-directories.
    $project =  (Split-Path $_ -Parent | Split-Path -Leaf) + "-" + (Split-Path $_ -LeafBase)
    
    Write-Output "Adding project $project to Hugo."

    New-Item -ItemType Directory -Path "$generatorDir/templates/$project"
    Copy-Item -Path $_.FullName -Destination "$generatorDir/templates/$project/$project.md"
}

# Build Hugo content
# ------------------
hugo -s $generatorDir

# Copy files out of Hugo
# ----------------------
 Get-ChildItem $templateDir -Recurse -File -Filter "*.md" | % {
    $pillar = (Split-Path $_ -Parent | Split-Path -Leaf)
    $lens = (Split-Path $_ -LeafBase)

    # Create necessary directory structure, don't worry about folder existing and just force it.
    New-Item -ItemType Directory "$outputDir/$pillar" -Force
    Write-Host "Copy to $outputdir/$pillar/$lens.md"
    Copy-Item $generatorDir/output/$pillar-$lens.md -Destination $outputDir/$pillar/$lens.md    
}