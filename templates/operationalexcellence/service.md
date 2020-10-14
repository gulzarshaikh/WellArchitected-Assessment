# Service Operational Excellence

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "operationalexcellence" }}

# Navigation Menu
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "service" "categories" $.Site.Data.categories) }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Operational Excellence" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}