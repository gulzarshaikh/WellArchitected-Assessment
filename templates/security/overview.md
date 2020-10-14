[![Security Assessment](/templates/media/security-icon.png "Security Assessment")](#)

This security assessment has been produced to help the global CE&S community to identify key risks to the security of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "security" -}}
{{- $baseUrl := "./"}}
{{- $baseUrlApplication := print $baseUrl "application.md"}}
{{- $baseUrlService := print $baseUrl "service.md"}}

## Navigation Menu

- [Application Operational Excellence]({{ $baseUrlApplication }}) 
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "application" "categories" $.Site.Data.categories  "type" "Questions" "baseUrl" $baseUrlApplication "printChecklistHeader" true) }}
- [Service Operational Excellence]({{ $baseUrlService }})
{{ partial "navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "lens" "service" "categories" $.Site.Data.categories  "type" "Questions" "baseUrl" $baseUrlService) }}