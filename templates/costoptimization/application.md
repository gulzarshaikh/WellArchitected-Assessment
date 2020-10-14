# Application Cost Optimization

{{- $pillars := slice "costoptimization" }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Cost Optimization" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}