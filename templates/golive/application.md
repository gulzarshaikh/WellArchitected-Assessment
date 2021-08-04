# Go-Live Assessment - Application View

{{- $pillars := (slice "reliability" "operationalexcellence" "costoptimization" "security" "performanceefficiency") }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Go-Live" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}
