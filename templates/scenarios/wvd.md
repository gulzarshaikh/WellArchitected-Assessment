# Scenario Windows Virtual Deskop

{{- $pillars := slice "scenario/wvd" -}}

{{ partial "scenariolens.partial" (dict "pillarDisplayName" "WVD" "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories) }}