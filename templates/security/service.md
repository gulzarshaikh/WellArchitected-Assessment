# Service Security

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "security" }}

# Navigation Menu
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "service" "categories" $.Site.Data.categories) }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Security" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}