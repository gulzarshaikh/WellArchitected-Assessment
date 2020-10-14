# Application Reliability

{{- $pillars := slice "reliability" }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Reliability" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}
