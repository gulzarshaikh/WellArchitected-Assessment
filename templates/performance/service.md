# Service Performance Efficiency

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := slice "performanceefficiency" }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Performance Efficiency" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}