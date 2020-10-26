# Application Performance Efficiency

{{- $pillars := slice "performance" }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Performance Efficiency" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}