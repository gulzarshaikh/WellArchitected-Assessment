[![Security Assessment](/templates/media/reliability-icon.png "Security Assessment")](#)

This security assessment has been produced to help the global CE&S community to identify key risks to the security of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "security" -}}
{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}
{{- $baseUrl := "./"}}
{{- $baseUrlApplication := print $baseUrl "application.md"}}
{{- $baseUrlService := print $baseUrl "service.md"}}

## Navigation Menu

- [Application Security]({{ $baseUrlApplication }}) 
{{- $lens := "application" -}}
{{- $filteredApp := where $filtered "lens" $lens -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filteredApp "category" $category.title -}}
    {{- if $questionsInCategory }}
  - [{{ $category.title}}]({{ $baseUrlApplication }}#{{ replace (replaceRE "[^\\s\\d\\w]" "" $category.title) " " "-" }})
        {{- range $subCategory := $category.subCategories }}
            {{- $questionsInSubCategory := (and (where $filteredApp "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $questionsInSubCategory }}
    - [{{ $subCategory.title}}]({{ $baseUrlApplication }}#{{ replace (replaceRE "[^\\s\\d\\w]" "" $subCategory.title) " " "-" }})
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end }}
- [Service Security]({{ $baseUrlService }})
{{- $lens = "service" -}}
{{- $filteredService := where $filtered "lens" $lens -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filteredService "category" $category.title -}}
    {{- if $questionsInCategory }}
  - [{{ $category.title}}]({{ $baseUrlService }}#{{ replace (replaceRE "[^\\s\\d\\w]" "" $category.title) " " "-" }})
        {{- range $subCategory := $category.subCategories }}
            {{- $questionsInSubCategory := (and (where $filteredService "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $questionsInSubCategory }}
    - [{{ $subCategory.title}}]({{ $baseUrlService }}#{{ replace (replaceRE "[^\\s\\d\\w]" "" $subCategory.title) " " "-" }})
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}