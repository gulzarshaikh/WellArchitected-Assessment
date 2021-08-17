[![Operational Excellence Assessment](./templates/media/operationalexcellence-icon.png "Operational Excellence Assessment")](#)

This operational excellence assessment has been produced to help the global CE&S community to identify optimisations to the operability of applications built on Azure, providing key recommendations to better serve our customers. 

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "operationalexcellence" -}}

{{ partial "overview-navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories "pillarDisplayName" "Operational Excellence") }}