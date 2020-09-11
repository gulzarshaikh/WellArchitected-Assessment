# Operational Excellence Assessment

{{- $pillars := slice "opex" -}}
{{- $lens := "application" -}}

{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}
{{- $filtered = where $filtered "lens" $lens -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $questionsInCategory := where $filtered "category" $category.title -}}
    {{- if $questionsInCategory }}
# {{ $category.title}}
    {{ range $subCategory := $category.subCategories -}}
        {{- $questionsInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
        {{- if $questionsInSubCategory }}
## {{ $subCategory.title }}
            {{ range $question := $questionsInSubCategory }}
* {{ .title }}
  > {{ .context }}
            {{ range .children }}
    - {{ .title }}
    > {{ .context }}
                      {{ end }}
                  {{ end }}
              {{ end }}
            {{- end -}}
    {{- end -}}
{{- end -}}
