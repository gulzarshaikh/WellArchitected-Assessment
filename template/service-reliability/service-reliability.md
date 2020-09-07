# Service-specific reliability recommendation

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "reliability" -}}
{{- $lens := "service" -}}

{{- $filtered := (and (where $.Site.Data.input "pillars" "intersect" $pillars) (where $.Site.Data.input "lens" $lens)) -}}

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


{{- $types := slice "Design Considerations" "Configuration Recommendations" -}}

{{- range $category, $subCategories := $categoriesDict }}
# {{ $category }}
    {{- range $subCategory := $subCategories}}
## {{ $subCategory }}
        {{- $allItemsInSubCategory := (and (where $filtered "category" $category) (where $filtered "subCategory" $subCategory)) }}
            {{- range $type := $types }}
                {{- $itemsInType := where $allItemsInSubCategory "type" $type }}
                {{- if $itemsInType }}
### {{ $type }}
                    {{- range $itemsInType }}
* {{ .title }}
            {{- with .context}}
  > {{ . }}
            {{ end }}
            {{- range .children }}
  - {{ .title }}
                {{- with .context}}
    > {{ . }}
                    {{ end }}
                    {{ end }}
                {{- end }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end }}
