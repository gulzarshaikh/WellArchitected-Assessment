# Supported input 'types'

## Single question
[Example Source](https://github.com/Azure/WellArchitected-ReliabilityAssessment/blob/main/docs/Application-Resiliency.md#design)

```json
{
    "type": "titleWithContext",

    "tags": ["reliability"],
    "category": "applicationdesign",
    "subCategory": "design",

    "title": "Can the application operate with reduced functionality or degraded performance in the presence of an outage?",
    "context": "Avoiding failure is impossible in the public cloud, and as a result applications require resilience to respond to outages and deliver reliability. The application should therefore be designed to operate even when impacted by regional, zonal, service or component failures across critical application scenarios and functionality.",
}
```

## Question with subquestions
[Example Source](https://github.com/Azure/WellArchitected-ReliabilityAssessment/blob/main/docs/Application-Resiliency.md#availability-targets)

```json
{
    "type": "titleWithContext",

    "tags": ["opex"],
    "category": "applicationdesign",
    "subCategory": "targets",

    "title": "Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?",
    "context": "Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational actionality required by the application is going to be far greater than if an SLO of 99.9% was the aspiration",

    "children": [
        {
            "type":"titleWithContext",
            "title": "Are SLAs/SLOs/SLIs for all leveraged dependencies understood?",
            "context": "Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets"
        },
        {
            "type":"titleWithContext",
            "title": "Are availability targets considered while the system is running in disaster recovery mode?",
            "context": "If targets must also apply in a failure state then an n+1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability"
        }
    ]
}
```

## Title with bullet list
[Example Source](https://github.com/Azure/WellArchitected-ReliabilityAssessment/blob/main/docs/Service-Resiliency.md#app-service-environments)
```json
{
    "type": "titleWithBulletList",
    
    "tags": ["reliability"],
    "category": "app-service-plan",
    "subCategory": "configuration-recommendations",

    "title": "In addition to the general recomendations for App Service Plans, App Service Environments (ASE) has additional configuration recomendations since it provides control over underlying compute resources to achieve greater isolation.",
    "children": [
        {
            "type": "titleWithContext",
            "title": "Ensure ASE is deployed within in highly available configuration across Availability Zones",
            "context": "Configuring ASE to use Availability Zones by deploying ASE across specific zones ensures applications can continue to operate even in the event of a data center level failure. This provides excellent redundancy without requiring multiple deployments in different Azure regions."
        },
        {
            "type": "titleWithContext",
            "title": "Ensure the ASE Network is configured correctly.",
            "context": "One common ASE pitfall occurs when ASE is deployed into a subnet with an IP Address space that is too small to support future expansion. In such cases, ASE can be left unable to scale without redeploying the entire environment into a larger subnet. It is highly recomended that adequate IP addresses be used to support either the maximum number of workers or the largest number considered workloads will need. A single ASE cluster can scale to 201 instance, which would require a /24 subnet."
        },        
    ]
}
```

## Title with code block
[Example Source](https://github.com/Azure/WellArchitected-ReliabilityAssessment/blob/main/docs/Service-Resiliency.md#supporting-source-artefacts-1)

```json
{
    "type": "titleWithCodeBlock",
    
    "tags": ["reliability"],
    "category": "cosmosdb",
    "subCategory": "supporting-artefacts",

    "title": "In order to check if multi location is not selected you can use the following query:",
    "code": " ```kql
            Resources
            |where  type =~ 'Microsoft.DocumentDb/databaseAccounts'
            |where array_length( properties.locations) <=1
            ``` "      
    ]
}
```