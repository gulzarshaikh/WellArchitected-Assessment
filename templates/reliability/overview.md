[![Reliability Assessment](/templates/media/reliability-icon.png "Reliability Assessment")](#)

This reliability assessment has been produced to help the global CE&S community to identify key risks to the health and availability of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "reliability" -}}
{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}

## Navigation Menu

- [Application Reliability](./assessments/reliability/application.md) 
{{- $lens := "application" -}}
{{- $filtered = where $filtered "lens" $lens -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
  - [{{ $category.title}}](./assessments/reliability/application.md#{{ replace (replaceRE "[^\\s\\d\\w]" "" $category.title) " " "-" }})
        {{- range $subCategory := $category.subCategories }}
            {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $questionsInSubCategory }}
    - [{{ $subCategory.title}}](./assessments/reliability/application.md#{{ replace (replaceRE "[^\\s\\d\\w]" "" $subCategory.title) " " "-" }})
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

- [Service Reliability](./assessments/reliability/service.md)
{{- $lensService = "service" -}}
{{- $filtered = where $filtered "lens" $lensService -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
  - [{{ $category.title}}](./assessments/reliability/service.md#{{ replace (replaceRE "[^\\s\\d\\w]" "" $category.title) " " "-" }})
        {{- range $subCategory := $category.subCategories }}
            {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $questionsInSubCategory }}
    - [{{ $subCategory.title}}](./assessments/reliability/service.md#{{ replace (replaceRE "[^\\s\\d\\w]" "" $subCategory.title) " " "-" }})
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}