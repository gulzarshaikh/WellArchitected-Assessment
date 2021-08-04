# Go-Live Assessment - Service View

This list contains design considerations and recommended configuration options, specific to individual Azure services.

{{- $pillars := (slice "reliability" "operationalexcellence" "costoptimization" "security" "performanceefficiency") }}

{{ partial "servicelens.partial" (dict "pillarDisplayName" "Reliability" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}