[![Reliability Assessment](/templates/media/reliability-icon.png "Reliability Assessment")](#)

This reliability assessment has been produced to help the global CE&S community to identify key risks to the health and availability of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "reliability" -}}
{{- $baseUrl := "./"}}
{{- $baseUrlApplication := print $baseUrl "application.md"}}
{{- $baseUrlService := print $baseUrl "service.md"}}


## Navigation Menu

[Application Reliability]({{ $baseUrlApplication }}) 
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "application" "categories" $.Site.Data.categories "baseUrl" $baseUrlApplication "printChecklistHeader" true) }}


[Service Reliability]({{ $baseUrlService }})
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "service" "categories" $.Site.Data.categories "baseUrl" $baseUrlService) }}