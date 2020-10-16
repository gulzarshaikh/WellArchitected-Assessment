# Application Security

{{- $pillars := slice "security" }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Security" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}
