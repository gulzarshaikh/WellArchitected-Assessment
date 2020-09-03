# Operational Excellence Assessment

{{ range $.Site.Data.applicationopex }}
* {{ .title }}
> {{ .context }}
{{ end }}

