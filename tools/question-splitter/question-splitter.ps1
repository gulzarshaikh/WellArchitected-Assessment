# Where are the data files.
$dataDir = "../data"
# Regex representation of the JSON file name to modify - usually just one file, but can be multiple.
$dataJsonFileName = "applicationlens.data.json$"

$modifiedItems = @()

# Script adapted from the GitHub Action.
# Depending on the regex filename, only one file is usually taken.
Get-ChildItem -Path $dataDir | where { $_.Name -match $dataJsonFileName } | % {
    Write-Host $_.Name

    Get-Content -Path $_.FullName | ConvertFrom-Json | %{
        if (($_ | Get-Member -Name "context")) {
            # Add recommendation only when there's context.
            $_ | Add-Member -NotePropertyName "recommendation" -NotePropertyValue ""
            Write-Host "\n", $_
        }
        else {
            Write-Host "---\n---No context\n---"
        }
        
        # Always add ID.
        $_ | Add-Member -NotePropertyName "id" -NotePropertyValue ""

        # Do the same for children, if any.
        if (($_ | Get-Member -Name children)) {
            $_.children | % {
                if (($_ | Get-Member -Name "context")) {
                    # Add recommendation only when there's context.
                    $_ | Add-Member -NotePropertyName "recommendation" -NotePropertyValue ""
                    Write-Host "\n", $_
                }

                # Always add ID.
                $_ | Add-Member -NotePropertyName "id" -NotePropertyValue ""
            }
        }

        $modifiedItems += $_
    }

    $modifiedItems | ConvertTo-Json -Depth 10 | Out-File "$dataDir/$($_.Name)"
}