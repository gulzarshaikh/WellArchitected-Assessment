# Reliability & OpEx Assessment

This is a combined assessment for reliability and Operational Excellence

{{- $pillars := slice "reliability" "opex" -}}

{{- $filtered := (and (where $.Site.Data.input "pillars" "intersect" $pillars) (where $.Site.Data.input "lens" "application")) -}}

{{- $categoriesDict := dict -}}

{{- range $item := where $filtered "pillars" "intersect" $pillars -}}
    {{- $existingCategoryValues := index $categoriesDict .category}}
    {{- with $existingCategoryValues -}}
        {{- if not (in $existingCategoryValues $item.subCategory) -}}
            {{- $subCats := $existingCategoryValues | append $item.subCategory -}}
            {{- $subDict := dict $item.category $subCats -}}
            {{- $categoriesDict = merge $categoriesDict $subDict -}}
        {{- end -}}
    {{- else -}}
            {{- $subDict := dict $item.category (slice $item.subCategory) -}}
            {{- $categoriesDict = merge $categoriesDict $subDict -}}
    {{- end -}} 
{{- end -}}


{{range $category, $subCategories := $categoriesDict}}
# {{ $category }}
    {{ range $subCategory := $subCategories}}
## {{ $subCategory }}
        {{ range (and (where $filtered "category" $category) (where $filtered "subCategory" $subCategory)) }}
* {{ .title }}
  > {{ .context }}
            {{ range .children }}
  - {{ .title }}
    > {{ .context }}
            {{ end }}
        {{ end }}
    {{ end }}
{{ end }}
