# Application Performance Efficiency

{{- $pillars := slice "performanceefficiency" }}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Performance Efficiency" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}