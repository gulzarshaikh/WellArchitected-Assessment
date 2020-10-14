# Service Security

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "security" }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Security" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}