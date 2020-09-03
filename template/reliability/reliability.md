{{ $filter := slice "reliability"}}
# Reliability Assessment

{{ range where .Site.Data.input "pillars" "intersect" $filter }}
* {{ .title }}
    >* {{ .context }}*
    {{ range .children }}
    - {{ .title }}
        >* {{ .context }}*
    {{ end }}
{{ end }}