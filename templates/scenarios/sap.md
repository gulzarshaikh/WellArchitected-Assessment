# Scenario SAP

{{- $pillars := slice "scenario/sap" -}}

{{ partial "scenariolens.partial" (dict "pillarDisplayName" "SAP" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}