[![Go-Live Assessment](/templates/media/golive-icon.png "Go-Live Assessment")](#)

This go-live assessment has been produced to help the global CE&S community to identify key best practice optimizations for applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := (slice "reliability" "operationalexcellence" "costoptimization" "security" "performanceefficiency") }}

{{ partial "overview-navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories "pillarDisplayName" "Go-Live") }}