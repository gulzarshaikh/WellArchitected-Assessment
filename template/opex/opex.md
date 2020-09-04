{{- $pillars := slice "opex" -}}

# Operational Excellence Assessment

This is a checklist for an OpEx assessment.

{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}


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
