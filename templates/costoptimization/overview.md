[![Cost Optimization Assessment](/templates/media/costoptimization-icon.png "Cost Optimization Assessment")](#)

This assessment has been produced to help the global CE&S community to optimize the cost of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "costoptimization" -}}
{{- $filtered := where $.Site.Data.input "pillars" "intersect" $pillars -}}
{{- $baseUrl := "./"}}
{{- $baseUrlApplication := print $baseUrl "application.md"}}
{{- $baseUrlService := print $baseUrl "service.md"}}


## Navigation Menu

- [Application Operational Excellence]({{ $baseUrlApplication }}) 
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "application" "categories" $.Site.Data.categories  "type" "Questions" "baseUrl" $baseUrlApplication) }}
- [Service Operational Excellence]({{ $baseUrlService }})
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "service" "categories" $.Site.Data.categories  "type" "Questions" "baseUrl" $baseUrlService) }}