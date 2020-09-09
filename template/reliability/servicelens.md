# Service-specific reliability guidance

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "reliability" -}}
{{- $lens := "service" -}}

{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}
{{- $filtered = where $filtered "lens" $lens -}}

{{- $types := slice "Design Considerations" "Configuration Recommendations" "Supporting Source Artifacts" -}}

{{- range $category := $.Site.Data.categories -}}
    {{- $contentInCategory := where $filtered "category" $category.title -}}
    {{- if $contentInCategory }}
# {{ $category.title}}
        {{ range $subCategory := $category.subCategories -}}
            {{- $contentInSubCategory := (and (where $filtered "category" $category.title) (where $filtered "subCategory" $subCategory.title)) -}}
            {{- if $contentInSubCategory }}
## {{ $subCategory.title }}
                {{- range $type := $types }}
                    {{- $itemsInType := where $contentInSubCategory "type" $type }}
                    {{- if $itemsInType }}
### {{ $type }}
                        {{- range $itemsInType }}
* {{ .title }}
                            {{- with .code}}
  {{ (print "```\n" . "```\n") | markdownify }} 
                            {{ end }}    
                            {{- with .context}}
  > {{ . }}
                            {{ end }}
                            {{- range .children }}
  - {{ .title }}
                                {{- with .code}}
    {{ (print "```\n" . "```\n") | markdownify }} 
                                {{ end }}   
                                {{- with .context}}
    > {{ . }}
                                {{ end }}
                            {{ end }}
                        {{- end }}
                    {{- end }}
                {{- end }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end }}