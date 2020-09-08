$AllItems = @()
Get-ChildItem -Path data | where { $_.Name -match ".data.json$" } | % {
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
    if($item.category -notin $categoriesWithSubs.title){
        $category = New-Object -TypeName psobject
        $category | add-member -MemberType NoteProperty -Name title -Value $item.category
        $subCategories = @()
        $subcategory = New-Object -TypeName psobject
        $subcategory | add-member -MemberType NoteProperty -Name title -Value $item.subCategory
        $subCategories += $subcategory
        $category | add-member -MemberType NoteProperty -Name subCategories -Value $subCategories

        $categoriesWithSubs += $category
    }
    else 
    {
        $existingItem = $categoriesWithSubs | Where-Object title -match $item.category
        $subcategory = New-Object -TypeName psobject
        $subcategory | add-member -MemberType NoteProperty -Name title -Value $item.subCategory
        $existingItem.subCategories += $subcategory
    }
}

$categoriesWithSubs | ConvertTo-Json -Depth 5 | Out-File conversion/categories.json