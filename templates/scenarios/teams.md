# Scenario Microsoft Teams

{{- $pillars := slice "scenario/teams" -}}

{{ partial "scenariolens.partial" (dict "pillarDisplayName" "Teams" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}