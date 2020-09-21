$validCategories = Get-Content -Path .\data\categories.json | ConvertFrom-Json 

$AllItems = @()
Get-ChildItem -Path data | where { $_.Name -match ".data.json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | %{
        if($_) 
        {
            $AllItems += $_
        }
    }
}

$allCategories = $allitems | Select-Object -Property Category,subcategory

$allCategories = $allCategories | Sort-Object -Property category,subcategory | Get-Unique -AsString

foreach($item in $allCategories){
    if($item.category -notin $validCategories.title)
    {
        Write-Error "Category $($item.category) does not exist in categories.json"
    }
    else
    {
        $category = $validCategories | Where-Object title -match $item.category
        if($item.subCategory -notin $category.subCategories.title){
            Write-Error "Sub Category $($item.subCategory) for category $($category.title) does not exist in categories.json"
        }
    }
}