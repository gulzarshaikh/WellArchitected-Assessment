{{ $filter := slice "opex"}}
# Operational Excellence Assessment

{{ range where .Site.Data.input "pillars" "intersect" $filter }}
* {{ .title }}
    > {{ .context }}
    {{ range .children }}
    - {{ .title }}
        > {{ .context }}
    {{ end }}
{{ end }}