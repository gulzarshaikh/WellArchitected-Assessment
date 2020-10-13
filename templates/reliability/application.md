# Application Reliability

{{- $pillars := slice "reliability" -}}
{{- $lens := "application" -}}

{{- $filtered := where (where (where $.Site.Data.input "pillars" "intersect" $pillars) "lens" $lens) "type" "Questions" }}
{{ $designPrinciples := where (where $.Site.Data.input "pillars" "intersect" $pillars) "type" "Design Principles" }}

# Navigation Menu
{{ if $designPrinciples }}
- [Design Principles](#design-principles)
{{- end -}}
{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
- [{{ $category.title}}](#{{ replace (replaceRE "[^\\s\\d\\w]" "" $category.title) " " "-" }})
        {{- range $subCategory := $category.subCategories }}
            {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $questionsInSubCategory }}
  - [{{ $subCategory.title}}](#{{ replace (replaceRE "[^\\s\\d\\w]" "" $subCategory.title) " " "-" }})
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end }}

{{ partial "application-designprinciples.partial" $designPrinciples }}

# Application Assessment Checklist

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
## {{ $category.title}}
    {{ range $subCategory := $category.subCategories -}}
        {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
        {{- if $questionsInSubCategory }}
### {{ $subCategory.title }}
            {{ range $question := $questionsInSubCategory }}
{{ partial "application-question.partial" $question }}
            {{ end }}
        {{ end }}
    {{- end -}}
    {{- end -}}
{{- end -}}
