# Scenario SAP

{{- $pillars := slice "reliability" -}}

{{ partial "scenariolens.partial" (dict "pillarDisplayName" "SAP" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}