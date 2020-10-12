# Application Reliability

{{- $pillars := slice "reliability" -}}
{{- $lens := "application" -}}

{{- $filtered := where (where (where $.Site.Data.input "pillars" "intersect" $pillars) "lens" $lens) "type" "Questions" }}

# Navigation Menu
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

{{ $designPrinciples := where (where $.Site.Data.input "pillars" "intersect" $pillars) "type" "Design Principles" }}
{{- if $designPrinciples -}}
# Design Principles

The following Design Principles provide context for questions, why a certain aspect is important and how is it applicable to Reliability.

{{ range $designPrinciples -}}
    - {{ .title }}

{{ if .context }}  _{{ safeHTML (trim .context " ") }}_{{ end }}

{{- end }}
{{ end }}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
# {{ $category.title}}
    {{ range $subCategory := $category.subCategories -}}
        {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
        {{- if $questionsInSubCategory }}
## {{ $subCategory.title }}
            {{ range $question := $questionsInSubCategory }}
{{ partial "application-question.partial" $question }}
            {{ end }}
        {{ end }}
    {{- end -}}
    {{- end -}}
{{- end -}}
