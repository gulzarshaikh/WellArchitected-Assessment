# Service Cost Optimization

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "costoptimization" -}}
{{- $lens := "service" -}}

{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}
{{- $filtered = where $filtered "lens" $lens -}}

{{- $types := slice "Design Considerations" "Configuration Recommendations" "Supporting Source Artifacts" }}

# Navigation Menu
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" $lens "categories" $.Site.Data.categories) }}

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
{{ safeHTML (htmlUnescape (print "```\n" . "```\n")) }} 
                            {{ end }}    
                            {{- with .context}}
  > {{ safeHTML . }}
                            {{ end }}
                            {{- range .children }}
  - {{ .title }}
                                {{- with .code}}
{{ safeHTML (htmlUnescape (print "```\n" . "```\n")) }} 
                                {{ end }}   
                                {{- with .context}}
    > {{ safeHTML . }}
                                {{ end }}
                            {{ end }}
                        {{- end }}
                    {{- end }}
                {{- end }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end }}