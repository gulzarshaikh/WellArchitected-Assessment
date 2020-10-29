$dataDir = "data"
$outputDir = "assessments"

# Merge data files
# ----------------
$AllItems = @()
Get-ChildItem -Path $dataDir | where { $_.Name -match ".data.json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | % {
        if ($_) {
            $AllItems += $_
        }
    }
}

$PnpQuestions = Get-Content -Path "$dataDir/pnp-questions.json" | ConvertFrom-Json

foreach ($question in $PnpQuestions) {
    foreach ($answer in $question.answers) {
        $content = $null
        if ($answer.question_id) { # not every answer might have a reference to a question, we ignore those
            $content = $AllItems | Where-Object { $_.id -eq $answer.question_id }       
            if (-not $content) {
                # If the ID was not matched on a parent question, we look now inside the children
                $parentContent = $AllItems | Where-Object { $_.children.id -eq $answer.question_id }
                if ($parentContent) {
                    $content = $parentContent.children | Where-Object { $_.id -eq $answer.question_id }
                }     
            }
            if ($content -and $content.statement) {
                Write-Host "Found statement: " $content.statement
                $answer | Add-Member -MemberType NoteProperty -Name "statement" -Value $content.statement
                $answer | Add-Member -MemberType NoteProperty -Name "context" -Value $content.context
                $answer | Add-Member -MemberType NoteProperty -Name "recommendation" -Value $content.recommendation
                $answer.PSObject.Properties.Remove('question_id')
            }
        }
    }
}
$PnpQuestions | ConvertTo-Json -Depth 10 | Out-File $outputDir/pnp_questions.json