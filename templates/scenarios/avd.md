# Scenario Azure Virtual Deskop

{{- $pillars := slice "scenario/avd" -}}

{{ partial "scenariolens.partial" (dict "pillarDisplayName" "AVD" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}