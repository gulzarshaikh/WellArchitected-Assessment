# Service Operational Excellence

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "operationalexcellence" }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Operational Excellence" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}