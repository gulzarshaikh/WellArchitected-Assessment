[![Security Assessment](/templates/media/security-icon.png "Security Assessment")](#)

This security assessment has been produced to help the global CE&S community to identify key risks to the security of applications built on Azure, providing key recommendations to better serve our customers.

> Please note it is assumed users of this guidance have familiarity with the application architecture in question, as well as key scenarios and non-functional requirements.

{{- $pillars := slice "security" -}}

{{ partial "overview-navigation.partial" (dict "input" $.Site.Data.input "pillars" $pillars "categories" $.Site.Data.categories "pillarDisplayName" "Security") }}