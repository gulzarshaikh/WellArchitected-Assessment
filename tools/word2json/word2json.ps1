# This assumes an input file as such:
# - Remove all comments
# - Accept/Reject all changes and stop tracking
# - Save as filtered html
cls

$infile = "C:\users\nielsb\OneDrive - Microsoft\Desktop\AppGateway-Well Architected Guidance-Draft.htm"
$outfile = "C:\users\nielsb\OneDrive - Microsoft\Desktop\AppGateway-Well Architected Guidance-Draft.json"

$html = New-Object -Com "HTMLFile"
$filecontent = Get-Content -Path $infile

$src = [System.Text.Encoding]::Unicode.GetBytes($filecontent)
$html.write($src)

$ItemType = "Design Considerations"
$ItemLens = "service"
$ItemCategory = "Networking"
$ItemSubCategory = "Azure Application Gateway"

$items = New-Object System.Collections.Generic.List[System.Object]

$currentCategory = ""
$currentRecommendation = ""
$currentContext = ""

function flush() {
    $newItem = [ordered]@{
        type = $ItemType;
        pillars = @("reliability", "operationalexcellence") #@(($currentCategory -replace "^\d*.\s*",""));
        lens = $ItemLens;
        category = $ItemCategory;
        subCategory = $ItemSubCategory;
        
        title = $currentRecommendation;
        recommendation = "";

        # naive ID generation from category and random numbers - can produce duplicates
        id = "$($ItemCategory.ToLower().Replace("&", """").Replace(" ", "_"))_$(Get-Random -Maximum 9999)";
        context = $currentContext;
    }

    if($currentRecommendation -ne "")
    {
        $items.Add($newItem)
    }

}

$html.all | % {
    
    $tag = $_.tagName
    $tagContent = $_.InnerText
    if($tag -eq "") {
        continue
    }

    #Write-Host "tag: $tag - text: $tagContent"

    if($tag -eq "H2") {
        flush
        $currentRecommendation = ""
        $currentContext = ""
        $currentCategory = $tagContent
    }

    if($tag -eq "H3") {
        flush
        $currentRecommendation = ""
        $currentContext = ""
        $currentRecommendation = $tagContent
    }

    if($tag -eq "P") {
        $currentContext += "$tagContent"
    }

}

$items | ConvertTo-Json | Out-File $outfile