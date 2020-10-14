# Service Cost Optimization

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "costoptimization" }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Cost Optimization" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}