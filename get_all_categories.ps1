$AllItems = @()
Get-ChildItem -Path data | where { $_.Name -match ".json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | %{
        if($_) 
        {
            $AllItems += $_
        }
    }
}

$allCategories = $allitems | select -Property Category,subcategory

$allCategories = $allCategories | Sort-Object -Property category,subcategory | Get-Unique -AsString

$categoriesWithSubs = @()

ForEach ($item in $allCategories){
    if((Get-Member -InputObject $categoriesWithSubs | select -Property category) -match $item.category){

    }
    else 
    {
        $categoriesWithSubs += $item
    }
}
