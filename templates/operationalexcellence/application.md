# Application Operational Excellence

{{- $pillars := slice "operationalexcellence" -}}

{{ partial "applicationlens.partial" (dict "pillarDisplayName" "Operational Excellence" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}