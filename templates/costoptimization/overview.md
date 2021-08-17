[![Cost Optimization Assessment](./templates/media/costoptimization-icon.png "Cost Optimization Assessment")](#)

This assessment has been produced to help the global CE&S community to optimize the cost of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "costoptimization" -}}

{{ partial "overview-navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories "pillarDisplayName" "Cost Optimization") }}