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
New-Item -ItemType Directory $generatorDir/templates/partials

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

# Check categories
# ----------------

# This will check whether only (sub)categories from the categories.json are used    
$foundIssues = $false
$validCategories = Get-Content -Path $generatorDir/data/categories.json | ConvertFrom-Json 

$AllItems = Get-Content -Path $generatorDir/data/input.json | ConvertFrom-Json

# Get all used categories from the input.json and filter to unique
$allCategories = $allitems | Select-Object -Property category,subcategory | Sort-Object -Property category,subcategory | Get-Unique -AsString

foreach($item in $allCategories) 
{
    if($item.category -notin $validCategories.title)
    {
        Write-Warning "Category '$($item.category)' does not exist in categories.json"
        $foundIssues = $true
    }
    else
    {
        $category = $validCategories | Where-Object title -match $item.category
        if($item.subCategory -notin $category.subCategories.title)
        {
            Write-Warning "Sub Category '$($item.subCategory)' for category '$($category.title)' does not exist in categories.json"
            $foundIssues = $true
        }
    }
}

if($foundIssues) 
{
    Write-Error "Please fix the mismatching (sub)categories or add new categories to the categories.json"
}
else
{
    Write-Host "All good! All used categories exist in the categories.json"
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

# Prepare partial content files for Hugo.          
Get-ChildItem -Recurse -File $templateDir -Filter "*.partial" | % {
    $partial = Split-Path $_ -Leaf
    Write-Output "Adding partial file $partial to Hugo."
    Copy-Item -Path $_.FullName -Destination "$generatorDir/templates/partials/$partial"
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