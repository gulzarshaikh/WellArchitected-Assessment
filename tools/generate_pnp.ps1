$dataDir = "../data"
$outputDir = "../assessments"

# Merge data files
# ----------------
$allItems = @()
Get-ChildItem -Path $dataDir | where { $_.Name -match ".data.json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | % {
        if ($_) {
            $allItems += $_
        }
    }
}

$pnpMapping = Get-Content -Path "$dataDir/assessment-platform.questions-mapping.json" | ConvertFrom-Json

foreach ($question in $pnpMapping) {
    foreach ($choice in $question.choices) {
        $content = $null
        if ($choice.waf_github_content_id) { # not every answer might have a reference to a question, we ignore those
            $content = $allItems | Where-Object { $_.id -eq $choice.waf_github_content_id }
            if (-not $content) {
                # If the ID was not matched on a parent question, we look now inside the children
                $content = $allItems | Where-Object { $_.children.id -eq $choice.waf_github_content_id } | Select-Object -ExpandProperty "children" | Where-Object { $_.id -eq $choice.waf_github_content_id }
            }
            if ($content -and $content.statement) {
                Write-Host "Found statement for question $($choice.waf_github_content_id): " $content.statement
                $choice | Add-Member -MemberType NoteProperty -Name "title" -Value $content.statement
                $choice | Add-Member -MemberType NoteProperty -Name "context" -Value $content.context
                
                # Using string to define JSON for simplicity - it's a completely new object with nested properties.
                # Links is intentionally empty - it gets assigned afterwards.
                $recommendations = "
                  [
                    {
                      ""title"": ""$($content.recommendation.title)"",
                      ""context"": ""$($content.recommendation.context)"",
                      ""links"": [],
                      ""nextSteps"": ""1"",
                      ""metadata"": {
                        ""priority"": ""$($content.recommendation.priority)"",
                        ""category"": ""$($content.category)"",
                        ""sub-category"": ""$($content.subCategory)"",
                        ""description-long"": ""$($content.recommendation.context)""
                      }
                    }
                  ]
                " | ConvertFrom-Json -NoEnumerate

                # Currently, GitHub content always has just one recommendation, so we can safely assume that links should go to $recommendations[0].
                $recommendations[0].links = $content.recommendation.links
                
                $choice | Add-Member -MemberType NoteProperty -Name "recommendations" -Value $recommendations
            }
            else {
                Write-Warning "Either mapped question $($choice.waf_github_content_id) was not found or it does not have a 'statement' field"
            }
        }
    }
}

$pnpMapping | ConvertTo-Json -Depth 10 | Out-File $outputDir/pnp_questions.json