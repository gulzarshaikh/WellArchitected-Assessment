# Application Security

{{- $pillars := slice "security" -}}
{{- $lens := "application" -}}

{{- $filtered := where (where (where $.Site.Data.input "pillars" "intersect" $pillars) "lens" $lens) "type" "Questions" }}
{{ $designPrinciples := where (where $.Site.Data.input "pillars" "intersect" $pillars) "type" "Design Principles" }}

# Navigation Menu
{{ partial "application-navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" $lens "categories" $.Site.Data.categories) }}

{{ partial "application-designprinciples.partial" $designPrinciples }}

# Application Assessment Checklist

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
## {{ $category.title}}
    {{ range $subCategory := $category.subCategories -}}
        {{- $questionsInSubCategory := where (where $filtered "category" $category.title) "subCategory" $subCategory.title -}}
        {{- if $questionsInSubCategory }}
### {{ $subCategory.title }}
            {{ range $question := $questionsInSubCategory }}
{{ partial "application-question.partial" $question }}
            {{ end }}
        {{ end }}
    {{- end -}}
    {{- end -}}
{{- end -}}
