cls
$md = Get-Content -Path ./conversion/sourcedata/service_reliability.md

$outfilename = "./conversion/output/output_service_reliability.json"

$pillar = "reliability"

#List of items/questions that will form the json structure
$items = @()

$nomatchcount = 0

#Content is dependent on the place relative to current (sub)question so we need to track that
$currentItem = $null
$currentSubItem = $null

$currentCategory = ""
$currentSubCategory = ""
$currentType = ""
$currentCode = $null

# Something to take care of all the weird markdown characters in the content
function strip($text)
{
    $stripped = $text.ToString() -replace "(^\s*([#*>-]|[>\s\*])*\s*)|([*]\s*$)|(^[``]{3})|([``]{3}$)",""
    return $stripped
}

$md | % {
    # To know what to do with it, we have to figure out the content. 
    # Judging by the md used, we're dealing with either:
    #   # Category
    #   ## Subcategory
    #   * Question 
    #   - Subquestion
    #   > Context to a question or subquestion
    #   ([ a link
    #  ``` code
    
    # We have an active code block, so anything coming now is part of that
    if( $currentCode -ne $null)
    {
        if($_.ToString() -match "^\s*[``]{3}")
        {
            #Write-Host "end of code block: $_"
            # it's the end of the code block!

            if($currentSubItem -ne $null)
            {
                $currentSubItem.code += strip -text $currentCode
            }
            elseif($currentItem -ne $null) {
                $currentItem.code += strip -text $currentCode
            }
            else {
                Write-Host "Cannot set code as item is null: $_"
            }
            $currentCode = $null
        }
        else 
        {
            $currentCode += ("{0}`n" -f $_)   
        }
    }

    # Oh cool this is code!
    elseif($_.ToString() -match "^\s*[``]{3}")
    {
        #Write-Host "start of code block: $_"
        # Start a new codeblock
        $currentCode = ""
    }

    # It is a H1
    elseif($_.ToString() -match "^\s*[#]{1}\s")
    {
        Write-Host "$_ is an H1 heading."
    }

    # It is a H2
    elseif($_.ToString() -match "^\s*[#]{2}\s")
    {
        #Write-Host "$_ is a category"

        # Finding a new category means we're done with the current questions
        if($currentSubItem -ne $null)
        {
            $currentItem.children += $currentSubItem
            $currentSubItem = $null
        }

        if($currentItem -ne $null)
        {
            $items += $currentItem
            $currentItem = $null
        }

        $currentCategory = strip -text $_
    }

    # It's a H3
    elseif($_.ToString() -match "^\s*[#]{3}\s")
    {
        #Write-Host "$_ is a subcategory"
        if($currentSubItem -ne $null)
        {
            $currentItem.children += $currentSubItem
            $currentSubItem = $null
        }
        
        if($currentItem -ne $null)
        {
            $items += $currentItem
            $currentItem = $null
        }

        $currentSubCategory = strip -text $_
        $currentType = strip -text $_
    }

    # It's a H4. 
    elseif($_.ToString() -match "^\s*[#]{4}\s")
    {
        Write-Host "$_ is a sub-subcategory, but we're ignoring those."
    }

    # It's a question!
    elseif($_.ToString() -match "^\s*[*]\s*")
    {
        #Write-Host "$_ is a question"

        # Finding a new question means we're done with current questions
        if($currentSubItem -ne $null)
        {
            $currentItem.children += $currentSubItem
            $currentSubItem = $null
        }

        if($currentItem -ne $null)
        {
            $items += $currentItem
            $currentItem = $null
        }

        # Start a new question
        $currentItem = [ordered]@{
            type = $currentType;
            pillars = @($pillar);
            lens = "application";
            category = $currentCategory;
            subCategory = $currentSubCategory;
            title = strip -text $_;
        }
    }

    # It's a subquestion!
    elseif($_.ToString() -match "^\s*[-]\s*")
    {
        #Write-Host "$_ is a subquestion"

        # Finding a subquestion means we're done with current subquestions
        if($currentSubItem -ne $null)
        {
            $currentItem.children += $currentSubItem
            $currentSubItem = $null
        }

        # Start a new subitem
        #if it's the first one, we need to add a children collection to the parent
        if(-not $currentItem.children)
        {
            $currentItem.children = @()
        }

        $currentSubItem = [ordered]@{
            title = strip -text $_;
        }
    }

    # Yay! Context! (from either a question or a subquestion)
    elseif($_.ToString() -match "^\s*[>]\s?\S")
    {
        #Write-Host "$_ is context"

        # If there is an active subquestion, context belongs there.
        if($currentSubItem -ne $null)
        {
            $currentSubItem.context += strip -text $_
        }
        elseif($currentItem -ne $null) {
            $currentItem.context += strip -text $_
        }
        else {
            Write-Host "Cannot set context as item is null: $_" 
        }
    }

    # Looks like we're adding a link
    elseif($_.ToString() -match "^\s*[\(]?[\[]{1}\s*")
    {
        #Write-Host "$_ is a link"

        # Links belong to the preceding context. Which can be from a subitem or an item
        if($currentSubItem -ne $null)
        {
            $currentSubItem.context += strip -text $_
        }
        elseif($currentItem -ne $null) {
            $currentItem.context += strip -text $_
        }
        else {
            Write-Host "Cannot set context as item is null: $_"
        }
    }





    elseif($_.ToString().Trim() -ne "") {
        Write-Host "No match for:"
        Write-Host $_
        $nomatchcount++
    }

}

Write-Output "Found no match for $nomatchcount lines."

$items | ConvertTo-Json -Depth 10 | Out-File $outfilename