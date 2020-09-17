# Application Operational Excellence

# Navigation Menu
- [Application Design](#Application-Design)
  - [Design](#Design)
  - [Targets &amp; Non Functional Requirements](#Targets--Non-Functional-Requirements)
  - [Key Scenarios](#Key-Scenarios)
  - [Dependencies](#Dependencies)
  - [Application Composition](#Application-Composition)
- [Health Modelling](#Health-Modelling)
  - [Application Level Monitoring](#Application-Level-Monitoring)
  - [Resource/Infrastructure Level Monitoring](#ResourceInfrastructure-Level-Monitoring)
  - [Data Interpretation &amp; Health Modelling](#Data-Interpretation--Health-Modelling)
  - [Dashboarding](#Dashboarding)
  - [Alerting](#Alerting)
- [Operational Procedures](#Operational-Procedures)
  - [Recovery &amp; Failover](#Recovery--Failover)
  - [Scalability &amp; Capacity Model](#Scalability--Capacity-Model)
  - [Configuration &amp; Secrets Management](#Configuration--Secrets-Management)
  - [Operational Lifecycles](#Operational-Lifecycles)
  - [Patch &amp; Update Process (PNU)](#Patch--Update-Process-PNU)
- [Deployment &amp; Testing](#Deployment--Testing)
  - [Application Deployments](#Application-Deployments)
  - [Application Infrastructure Deployments &amp; Infrastructure as Code (IaC)](#Application-Infrastructure-Deployments--Infrastructure-as-Code-IaC)
  - [Build Environments](#Build-Environments)
  - [Testing &amp; Validation](#Testing--Validation)
- [Operational Model &amp; DevOps](#Operational-Model--DevOps)
  - [General](#General)
  - [Roles &amp; Responsibilities](#Roles--Responsibilities)
  - [Common Engineering Criteria ](#Common-Engineering-Criteria-)
# Application Design
    
## Design
            
* Is the application deployed across multiple Azure regions and/or utilizing Availability Zones?
  > Understanding the global operational footprint, for failover or performance purposes, is critical to evaluating overall operations. Generally speaking, multiple Azure regions should be used for disaster recovery procedures, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active recovery strategies([Failover strategies](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/backup-and-recovery)).   [Availability Zones](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones) are a high-availability offering that protects your applications and data from datacenter failures. Using zone-redundant or zonal (pinned to a specific AZ) deployments can increase resiliency of an application
            
    - Is the application deployed in either active-active, active-passive, or isolated configurations across leveraged regions?
    > The regional deployment strategy will partly shape operational boundaries, particularly where operational procedures for recovery and scale are concerned
                      
                  
* Are there any regulatory requirements around data sovereignty?
  > Regulatory requirements may mandate that operational data, such as application logs and metrics, remain within a certain geo-political region. This has obvious implications for how the application should be operationalized
            
                  
* Does the application have components on-premises or in another cloud platform?
  > Hybrid and cross-cloud workloads with components on-premises or on different cloud platforms, such as AWS or GCP, introduce additional operational considerations around achieving a 'single pane of glass' for operations
            
                  
* Is the application designed to use managed services?
  > Azure managed services provide native capabilities to support application operations, and where possible platform as a service offerings should be used to leverage these capabilities and reduce the overall management and operational burden([Use managed services](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/managed-services))
            
                  
* Has a the application been designed to scale-out?
  > Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally([Design to scale out](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out))
            
                  
* Is the application implemented with strategies for resiliency and self-healing?
  > Strategies for resiliency and self-healing include retrying transient failures and failing over to a secondary instance or even another region (see [Designing resilient Azure applications](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/app-design))
            
                  
* Is the application deployed across multiple Azure subscriptions?
  > Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when examining the operational landscape and analysing if relevant subscription limits or quotas can be navigated
            
                  
* Was the application built natively for the cloud or was an existing on-premises system migrated? 
  > Understanding if the application is cloud-native or not provides a very useful high level indication about potential technical debt for operability
            
                  
* Are Azure Tags used to enrich Azure resources with operational meta-data? 
  > Azure Tags provide the ability to associate critical meta-data as a name-value pair, such as billing information (e.g. cost center code), environment information (e.g. environment type), with Azure resources, resource groups, and subscriptions([Tagging Strategies](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources))
            
                  
* Does the application have a well-defined naming standard for Azure resources? 
  > A well-defined naming convention is important for overall operations, particularly for large application platforms where there are numerous resources([Naming Conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging))
            
                  
              
## Targets &amp; Non Functional Requirements
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?
  > Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational actionality required by the application is going to far greater than if an SLO of 99.9% was the aspiration
            
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?
    > Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets
                      
    - Are availability targets considered while the system is running in disaster recovery mode?
    > If targets must also apply in a failure state then an n+1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability
                      
    - Are these availability targets monitored and measured?
    > Mean Time Between Failures (MTBF): The average time between failures of a particular component
                      
    - What are the consequences if availability targets are not satisfied?
    > Are there any penalties, such as financial charges, associated with failing to meet SLA commitments
                      
                  
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?
  > Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriate 
Recovery time objective (RTO): The maximum acceptable time the application is unavailable after a disaster incident 
Recovery point objective (RPO): The maximum duration of data loss that is acceptable during a disaster event
            
                  
* Are there well defined performance requirements for the application and/or key scenarios?
  > Non-functional performance requirements, such as those relating to end-user experiences (e.g. average and maximum response times) are vital to assessing the overall health of an application, and is a critical lens required for assessing operations
            
    - Does the application have predictable traffic patterns? or is load highly volatile?
    > Understanding the expected application load and known spikes, such as Black Friday for retail applications, is important when assessing operational effectiveness
                      
    - Are there any targets defined for the time it takes to perform scale operations?
    > The application should be designed to scale to cope with spikes in load in-line with what is an acceptable duration for degraded performance
                      
    - What is the maximum traffic volume the application is expected to serve without performance degradation?
    > Scale requirements the application must be able to effectively satisfy, such as the number of concurrent users or requests per second, is a critical lens for assessing operations
                      
    - Are these performance targets monitored and measured across the application and/or key scenarios?
    > Monitoring and measuring end-to-end application performance is vital to qualifying overall application health and progress towards defined targets
                      
                  
              
## Key Scenarios
            
* Have critical system flows through the application been defined for all key business scenarios?
  > Path-wise analysis should be used to define critical system flows for key business scenarios, such as the checkout process for an eCommerce application. Understanding critical system flows is vital to assessing overall operational effectiveness, and should be used to inform a health model for the application
            
    - Do these critical system flows have distinct availability, performance, or recovery targets? 
    > Critical sub-systems or paths through the application may have higher expectations around availability, recovery, and performance due to the criticality of associated business scenarios and functionality
                      
                  
* Are there any application components which are less critical and have lower availability or performance requirements?
  > Similarly, some less critical components or paths through the application may have lower expectations around availability, recovery, and performance
            
                  
              
## Dependencies
            
* Are all internal and external dependencies identified and categorized as either weak or strong?
  > Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies captures required components outside the scope of the application, such as another application or third-party service. Such dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence([Twelve-Factor App: Dependencies](https://12factor.net/dependencies))
            
    - Do you maintain a complete list of application dependencies?
    > Examples of typical dependencies include platform dependencies outside the remit of the application, such as Azure Active Directory, Express Route, or a central NVA (Network Virtual Appliance), as well as application dependencies such as APIs which may be in-house or externally owned by a third-party
                      
    - Is the impact of an outage with each dependency well understood?
    > Strong dependencies play a critical role in application function and availability meaning their absence will have a significant impact, while the absence of weak dependencies may only impact specific features and not affect overall availability
                      
                  
* Is the lifecycle of the application decoupled from its dependencies?
  > If the application lifecycle is closely coupled with that of its dependencies it can limit the operational agility of the application, particularly where new releases are concerned
            
                  
* Are SLAs and support agreements in place for all critical dependencies?
  > The operational commitments of all external and internal dependencies should be understood to inform the broader application operations and health model
            
                  
              
## Application Composition
            
* What Azure services are used by the application?
  > It is important to understand what Azure services, such as App Services and Event Hub, are used by the application platform to host both application code and data
            
    - What operational features/capabilities are used for leveraged services?
    > Are operational capabilities, such as auto-scale and auto-heal for AppServices, leveraged to reduce management overheads and support operational effectiveness
                      
    - What technologies and frameworks are used by the application?
    > It is important to understand what technologies are used by the application and must be managed, such as .NET Core , Spring, or Node.js
                      
                  
* Are components hosted on shared application or data platforms which are used by other applications?
  > Do application components leverage shared data platforms, such as a central data lake, or application hosting platforms, such as a centrally managed AKS or ASE cluster
            
                  
* Do you monitor and regularly review new features and capabilities?
  > Azure is continuously evolving, with new features and services becoming available which may be beneficial for the application
            
    - Do you subscribe to Azure service announcements for new features and capabilities?
    > Service announcements provide insights into new features and services, as well as features or services which become deprecated
                      
                  
              
# Health Modelling
    
## Application Level Monitoring
            
* Is an Application Performance Management (APM) tool used collect application level logs?
  > An APM technology, such as Application Insights, should be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation
            
                  
* Are application logs collected from different application environments? 
  > Application logs and events should be collected across all major environments to support the end-to-end application lifecycle. However, a sufficient degree of separation should be in-place to ensure non-critical environments to not convolute production log interpretation
            
                  
* Are log messages captured in a structured format?
  > Application events should ideally be captured as a structured data type with machine-readable data points which can easily be indexed and searched, rather than an unstructured string
            
                  
* Are log levels used to capture different types of application events?
  > Different log levels, such as INFO, WARNING, ERROR, and DEBUG should be pre-configured and applied within relevant environments, such as DEBUG for a development environment. The approach to change log levels should be simple configuration change to support operational scenarios where it is necessary to elevate the log level within an environment
            
                  
* Are application events correlated across all application components?
  > Log events coming from different application components or different component tiers of the application should be correlated to build end-to-end transaction flows (see [Distributed tracing](https://docs.microsoft.com/en-us/azure/architecture/microservices/logging-monitoring#distributed-tracing)). For instance, this is often achieved by using consistent correlation IDs transferred between components within a transaction
            
                  
* Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?
  > Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.
            
    - Is the end-to-end performance of critical system flows monitored?
    > It should be possible to correlate application log events across critical system flows, such as user login, to fully assess the health of key scenarios in the context of targets and NFRs
                      
                  
              
## Resource/Infrastructure Level Monitoring
            
* Which log aggregation technology is used to collect logs and metrics from Azure resources?
  > Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as 3rd-party appliances such as firewalls or Anti-Malware solutions used in the application. For instance, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink([Event Hub Diagnostic Logs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-diagnostic-logs))
            
                  
* Are you collecting Azure Activity Logs within the log aggregation tool?
  > Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. Such information is extremely useful for the interpretation and troubleshooting of operational issues, as it provides transparency around configuration changes
            
                  
* Is resource level monitoring enforced throughout the application?
  > All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Azure Policy should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service
            
                  
* Are logs and metrics available for critical internal dependencies? 
  > To be able to build a robust application health model it is vital that visibility into the operational state of critical internal dependencies, such as a shared NVA or Express Route connection, be achieved
            
                  
* Are critical external dependencies monitored? 
  > Critical external dependencies, such as an API service, should be monitored to ensure operational visibility of dependency health. For instance, a probe could be used to measure the availability and latency of an external API
            
                  
              
## Data Interpretation &amp; Health Modelling
            
* Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?
  > To build a robust application health model it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues
            
                  
* Are application level events automatically correlated with resource level metrics to quantify the current application state?
  > The overall health state can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults
            
                  
* Is the transaction flow data used to generate application/service maps?
  > An [Application Map](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.
            
                  
* Is a health model used to qualify what &#39;healthy&#39; and &#39;unhealthy&#39; states represent for the application?
  > A holistic application health model should be used to quantify what 'healthy' and 'unhealthy' states represent across all application components. It is highly recommended that a 'traffic light' model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in <= 500ms with AKS node utilization at x% etc.
            
    - Are critical system flows used to inform the health model?
    > The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow
                      
    - Can the health model distinguish between transient and non-transient faults?
    > The health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state
                      
                  
* Are long-term trends analysed to predict operational issues before they occur?
  > Analytics can and should be performed across long-term operational data to help inform operational strategies and also to predict what operational issues are likely to occur and when. For instance, if the average response times have been slowly increasing over time and getting closer to the maximum target
            
                  
* Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?
  > Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis
            
                  
              
## Dashboarding
            
* What technology in used to visualize the application health model and encompassed logs and metrics?
  > Dashboarding tools, such as Azure Monitor or Grafana, should be used to visualize metrics and events collected at the application and resource levels, to illustrate the health model and the current operational state of the application
            
                  
* Are dashboards tailored to a specific audience? 
  > Dashboards should be customized to represent the precise lens of interest of the end-user. For example, the areas of interest when evaluating the current state will differ greatly between developers, security and networking. Tailored dashboards makes interpretation easier and accelerates time to detection and action
            
                  
* Is Role Based Access Control (RBAC) used to control access to dashboards and underlying data?
  > Access to operational data may be tightly controlled to align with segregation of duties, and careful attention should be made to ensure it doesn't hinder operational effectiveness; i.e. scenarios where developers have to raise an ITSM ticket to access logs should be avoided
            
                  
              
## Alerting
            
* What technology in used for alerting?
  > Alerts from tools such as Splunk or Azure Monitor proactively notify or respond to operational states that deviate from norm
            
                  
* Are specific owners and processes defined for each alert type? 
  > Having well-defined owners and response playbooks per alert is vital to optimizing operational effectiveness
            
                  
* Are operational events prioritized based on business impact? 
  > Tagging events with a specific severity or urgency helps operational teams priorities in cases where multiple events require intervention at the same time. For example, alerts concerning critical system flows might require special attention
            
                  
* Are push notifications enabled to inform responsible parties of alerts in real time?
  > It is important that alert owners get reliably notified of alerts, which could use many communication channels such as text messages, emails or push notifications to a mobile app
            
                  
* Is alerting integrated with an IT Service Management (ITSM) system?
  > ITSM systems, such as ServiceNow, can help to document issues, notify and assign responsible parties, and track issues. For example,  operational alerts from the application could for be integrated to automatically create new tickets to track resolution
            
                  
* Have Azure Service Health alerts been created to respond to Service level events?
  > Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories. Alerts should be configured to operationalize Service Health events, however, Service Health alerts should not be used to detect issues due to associated latencies; there is a 5 minute SLO for automated issues, but many issues require manual interpretation to define an RCA. Instead, they should be used to provide extremely useful information to help interpret issues that have already been detected and surfaced via the health model, to inform how best to operationally respond([Azure Service Health](https://docs.microsoft.com/en-us/azure/service-health/overview))
            
                  
* Have Azure Resource Health alerts been created to respond to Resource level events?
  > Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources. Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered
            
                  
* Are Azure notifications sent to subscriptions owners received and if necessary properly routed to relevant technical stakeholders?
  > Subscription notification emails can contain important service notifications or security alerts([Azure account contact information](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/change-azure-account-profile#service-and-marketing-emails))
            
                  
              
# Operational Procedures
    
## Recovery &amp; Failover
            
* Are recovery steps defined for failover and failback?
  > The steps required to fail over the application to a secondary Azure region in failure situations should be codified, preferably in an automated manner, to ensure capabilities exist to effectively respond to an outage in a way that limits impact. Similar codified steps should also exist to capture the process required to failback the application to the primary region once a failover triggering issue has been addressed
            
    - Has the failover and failback approach been tested/validated at least once?
    > The precise steps required to failover and failback the application must be tested to validate the effectiveness of the defined disaster recovery approach. Testing of the disaster recovery strategy should occur according to a reasonably regular cadence, such as annually, to ensure that operational application changes do not impact the applicability of the selected approach
                      
    - How is a failover decided and initiated?
    > Regional failovers are significant operational activity and may incur some downtime, degraded functionality, or data loss depending on the recovery strategy used. Hence, the decision process as to what constitutes a failover should be clearly understood
                      
    - Is the health model being used to classify failover situations?
    > A platform service outage in a specific region will likely require a failover to another region, whereas the accidental change of an firewall rule can be mitigated by a recovery process. The health model and all underlying data should be used to interpret which operational procedures should be triggered
                      
    - Can individual components of the application failover independently?
    > For example, is it possible to failover the compute cluster to a secondary region while keeping the database running in the primary region
                      
                  
* Are automated recovery procedures in place for common failure event?
  > Automated responses to specific events help to reduce response times and limit errors associated with manual processes
            
    - Are these automated recovery procedures tested and validated on a regular basis?
    > Automated operational responses should be tested frequently as part of the normal application lifecycle to ensure operational effectiveness
                      
                  
* Are critical manual processes defined and documented for manual failure responses?
  > Operational runbooks should be defined to codify the procedures and relevant information needed for operations staff to respond to failures and maintain operational health
            
    - Are these manual operational runbooks tested and validated on a regular basis?
    > Manual operational runbooks should be tested frequently as part of the normal application lifecycle to ensure appropriateness and efficiency
                      
                  
              
## Scalability &amp; Capacity Model
            
* Is there a capacity model for the application?
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements([Performance Efficiency - Capacity](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/capacity))
            
                  
* Is auto-scaling enabled for supporting PaaS and IaaS services?
  > Leveraging built-in Auto-scaling capabilities can help to maintain system reliability in times of increased demand while not needing to overprovision resources up-front, by letting a service automatically scale within a pre-configured range of resources. It greatly simplifies management and operational burdens. However, it must take into account the capacity model, else automated scaling of one component can impact downstream services if those are not also automatically scaled accordingly.
            
                  
* Is the process to provision and deprovision capacity codified?
  > While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or deprovisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood.
            
                  
* Is the impact of changes in application health on capacity fully understood?
  > For example, if an outage in an external API is mitigated by writing messages into a retry queue, this queue will get sudden spikes in load which it will need to be able to handle
            
                  
* Is the required capacity (initial and future growth) within Azure service scale limits and quotas?
  > Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should therefore take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a 'spill and fill' model([Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits))
            
    - Is the required capacity (initial and future growth) available within targeted regions?
    > While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region([Azure Capacity](https://aka.ms/AzureCapacity))
                      
                  
* Is capacity utilization monitored and used to forecast future growth?
  > Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status([Supported metrics with Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported))
            
                  
              
## Configuration &amp; Secrets Management
            
* Where is application configuration information stored and how does the application access it?
  > Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault
            
                  
* Can configuration settings be changed or modified without rebuilding or redeploying the application? 
  > Application code and configuration should not share the same lifecycle to enable operational activities that change and update specific configurations without developer involvement or redeployment
            
                  
* How are passwords and other secrets managed?
  > Tools like Azure Key Vault or HashiCorp Vault should be used to store and manage secrets securely rather than being baked into the application artefact during deployment, as this simplifies operational tasks like key rotation as well as improving overall security
            
                  
* Do you have procedures in place for key/secret rotation?
  > In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with rotation processes([Key Vault Key Rotation](https://docs.microsoft.com/en-us/azure/key-vault/secrets/tutorial-rotation-dual))
            
                  
* Does the application use Managed Identities?
  > Managed Identities in Azure can be used to securely access Azure services while removing the need to store the secrets or certificates of Service Principals([Managed Identities Overview](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview))
            
                  
* Are the expiry dates of SSL certificates monitored and are processes in place to renew them? 
  > Expired SSL certificates are one of the most common yet avoidable causes of application outages; even Azure and more recently Microsoft Teams have experienced outages due to expired certificates. Tracking expiry dates and renewing them in due time is therefore highly critical. Ideally the process should be automated, although this often depends on leveraged CA. If not automated, sufficient alerting should be applied to ensure expiry dates do not go unnoticed
            
                  
              
## Operational Lifecycles
            
* How are operational shortcomings and failures analysed?
  > Reviewing operational incidents where the response and remediation to  issues either failed or could have been optimized is vital to improving overall operational effectiveness. Failures provide a valuable learning opportunity and in some cases these learnings can also be shared across the entire organization
            
                  
* Are operational procedures reviewed and refined frequently?
  > Operational procedures should be updated based on outcomes from frequent testing
            
                  
              
## Patch &amp; Update Process (PNU)
            
* Is the PNU process defined and for all relevant application components?
  > The PNU process will vary based on the type of Azure service used (i.e. VM, VMSS, Containers on AKS). Applications using IaaS will typically require more investment to define a PNU process
            
    - Is the PNU process automated?
    > Ideally the PNU process should be fully or partially automated to optimize response times for new updates and also to reduce the risks associated with manual intervention
                      
    - Are PNU operations performed &#39;as-code&#39;?
    > Performing operations 'as-code' helps to minimize human error and increase consistency
                      
                  
* How are patches rolled back?
  > It is recommended to have a defined strategy in place to rollback patches in case of an error or unexpected side effects
            
                  
* Are emergency patches handled differently than normal updates?
  > Emergency patches might contain critical security updates that cannot wait till the next maintenance or release window
            
                  
* What is the strategy to keep up with changing dependencies?
  > Changing dependencies, such as new versions of packages, updated Docker images, should be factored into operational processes; the application team should be subscribed to release notes of dependent services, tools, and libraries
            
                  
              
# Deployment &amp; Testing
    
## Application Deployments
            
* What is the process to deploy application releases to production?
  > The entire end-to-end CI/CD deployment process should be understood
            
    - How long does it take to deploy an entire production environment?
    > The time it takes to perform a complete environment deployment should align with recovery targets
                      
                  
* How often are changes deployed to production?
  > Are numerous releases deployed each day or do releases have a fixed cadence, such as every quarter
            
                  
* Can the application be deployed automatically from scratch without any manual operations?
  > Manual deployment steps introduce significant risks where human error is concerned and also increases overall deployment times. Automated end-to-end deployments, with manual approval gates where necessary, should be used to ensure a consistent and efficient deployment process([Deployment considerations for DevOps](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/deployment))
            
    - Is there a documented process for any portions of the deployment that require manual intervention?
    > Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application
                      
                  
* Can N-1 or N&#43;1 versions be deployed via automated pipelines where N is current deployment version in production?
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle
            
                  
* Is there a defined hotfix process which bypasses normal deployment procedures?
  > In some scenarios there is an operational need to rapidly deploy changes, such as critical security updates. Having a defined process for how such changes can be safely and effectively performed helps greatly to prevent 'heat of the moment' issues
            
                  
* Does the application deployment process leverage blue-green deployments and/or canary releases?
  > Blue-green deployments and/or canary releases can be used to deploy updates in a controlled manner that helps to minimize disruption from unanticipated deployment issues([Stage your workloads](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/deployment#stage-your-workloads)) For example, Azure uses canary regions to test and validate new services and capabilities before they are more broadly rolled out to other Azure regions. Where appropriate the application can also use canary environments to validate changes before wider production rollout. Moreover, certain large application platforms may also derive benefit from leveraging Azure canary regions as a basis for validating the potential impact of Azure platform changes on the application.
            
                  
* How does the development team manage application source code, builds, and releases?
  > The use of source code control systems, such as Azure Repos or GitHub, and build and release systems, such as Azure Pipelines or GitHub Actions, should be understood, including the corresponding processes to access, review and approve changes
            
    - If Git is used for source control, what branching strategy is used?
    > To optimize for collaboration and ensure developers spend less time managing version control and more time developing code, a clear and simple branching strategy should be used, such as Trunk-Based Development which is employed internally within Microsoft Engineering([Microsoft Git Strategy](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/use-git-microsoft))
                      
                  
              
## Application Infrastructure Deployments &amp; Infrastructure as Code (IaC)
            
* Is application infrastructure defined as code?
  > It is highly recommended do describe the entire infrastructure as code, using either ARM Templates, Terraform, or other tools. This allows for proper versioning and configuration management, encouraging consistency and reproducibility across environments
            
    - Are any operational changes performed outside of IaC?
    > Are any resources provisioned or operationally configured manually through the Azure Portal or via Azure CLI. It is recommended that even small operational changes and modifications be implemented as-code to track changes and ensure they are fully reproduceable and revertible
                      
    - How does the application track and address configuration drift?
    > Configuration drift occurs when changes are applied outside of IaC processes such as manual changes. Tools like terraform support a plan command that helps to identify change and monitor configuration drift, with Azure as the ultimate source of truth
                      
                  
* Is the process to deploy infrastructure automated?
  > It is recommended to use build and release tools to define automated or partially automated CI/CD pipelines
            
                  
              
## Build Environments
            
* Do critical test environments have 1:1 parity with the production environment?
  > To completely validate the suitability of application changes, all changes should be tested in an environment that is fully reflective of production, to ensure there is no potential impact from environment deltas
            
                  
* Are mocks/stubs used to test external dependencies in non-production environments?
  > The use of dependent services should be appropriately reflected in test environments
            
                  
* Are releases to production gated by having it successfully deployed and tested in other environments?
  > It is recommended to have a staged deployment process which requires changes to have been validate in test environments first before they can hit production
            
                  
* Are feature flags used to test features before rolling them out to everyone?
  > Feature flags are a technique to help frequently integrate code into a shared repository, even if incomplete. It allows for deployment decisions to be separated from release decisions([Feature Flags](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/development#feature-flags))
            
                  
              
## Testing &amp; Validation
            
* Is the application tested for performance, scalability, and resiliency?
  > Performance Testing: Performance testing is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behaviour for the application([Performance Testing](https://docs.microsoft.com/en-us/azure/architecture/checklist/dev-ops#testing))
Load Testing : Load testing validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limit 
Stress Testing : *Stress testing is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues
            
    - When do you do test for performance, scalability, and resiliency?
    > Regular testing should be performed as part of each major change and if possible on a regular basis to validate existing thresholds, targets and assumptions, as well as ensuring the validity of the health model, capacity model and operational procedures
                      
    - Are any tests performed in production?
    > While the majority of testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system
                      
    - Is the application tested with injected faults?
    > It is a common "chaos monkey" practice to verify the effectiveness of operational procedures using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.) or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
                      
                  
* Are smoke tests performed during application deployments?
  > Smoke tests are a lightweight way to perform high-level validation of changes. For instance, performing a ping test immediately after a deployment([Smoke Testing](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/testing#smoke-testing))
            
                  
* When is integration testing performed?
  > Integration tests should be applied as part of the application deployment process, to ensure that different application components  interact with each other as they should. Integration tests typically take longer than smoke testing, and as a consequence occur at a latter stage of the deployment process so they are executed less frequently([Integration Testing](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/testing#integration-testing)
            
                  
* Is unit testing performed to validate application functionality? 
  > Unit tests are typically run by each new version of code committed into version control. Unit Tests should be extensive and quick to verify things like syntax correctness of application code, Resource Manager templates or Terraform configurations, that the code is following best practices, or that they produce the expected results when provided certain inputs([Unit Testing](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/testing#unit-testing))
            
                  
* Are these tests automated and carried out periodically or on-demand?
  > Testing should be fully automated where possible and performed as part of the deployment lifecycle to validate the impact of all application changes. Additionally, manual explorative testing may also be conducted
            
                  
* Are tests and test data regularly validated and updated to reflect necessary changes?
  > Tests and test data should be evaluated and updated after each major application change, update, or outage
            
                  
* What happens when a test fails?
  > Failed tests should temporarily block a deployment and lead to a deeper analysis of what has happened and to either a refinement of the test or an improvement of the change that caused the test to fail
            
                  
* Do you perform Business Continuity &#39;fire drills&#39; to test regional failover scenarios?
  > Business Continuity 'fire drills' help to ensure operational readiness and validate the accuracy of recovery procedures ready for critical incidents
            
                  
* What degree of security testing is performed?
  > Security and penetration testing, such as scanning for open ports or known vulnerabilities and exposed credentials, is vital to ensure overall security and also support operational effectiveness of the system
            
                  
              
# Operational Model &amp; DevOps
    
## General
            
* Are specific methodologies, like DevOps, used to structure the development and operations process? 
  > The contraction of “Dev” and “Ops” refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. Essential DevOps practices include agile planning, continuous integration, continuous delivery, and monitoring of applications (from [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-devops)).
            
                  
* Is the current development and operations process connected to a Service Management framework like ISO or ITIL?
  > [ITIL](https://en.wikipedia.org/wiki/ITIL) is a set of detailed [IT service management (ITSM)](https://en.wikipedia.org/wiki/IT_service_management) practices that can complement DevOps by providing support for products and services built and deployed using DevOps practices.
            
                  
              
## Roles &amp; Responsibilities
            
* Has the application been built and maintained in-house or by an external partner?
  > Exploring where technical delivery capabilities reside helps to qualify operational model boundaries
            
                  
* Is there a separation between development and operations?
  > A true DevOps model positions the responsibility of operations with developers, but many customers do not fully embrace DevOps and maintain some degree of team separation between operations and development, either to enforce clear segregation of duties for regulated environments, or to share operations as a business function
            
    - Does the development team own production deployments?
    > It is important to understand if developers are responsible for production deployments end-to-end, or if a handover point exists where responsibility is passed to an alternative operations team, potentially to ensure a strict segregation of duties such as Sarbanes-Oxley Act where developers cannot touch financial reporting systems
                      
    - How do development and operations teams collaborate to resolve production issues?
    > It is important to understand how operations and development teams collaborate to address operational issues, and what processes exist to support and structure this collaboration. Moreover, mitigating issues might require the involvement of different teams outside of development or operations, such as networking, and in some cases external parties as well. The processes to support this collaboration should also be understood
                      
    - Is the workload isolated to a single operations team?
    > The goal of workload isolation is to associate an application's specific resources to a team, so that the team can independently manage all aspects of those resources([Workload isolation](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/app-design#workload-isolation))
                      
                  
* Are any broader teams responsible for operational aspects of the application? 
  > Different teams such as Central IT, Security, or Networking may be responsible for aspects of the application which are controlled centrally, such as a shared network virtual appliance (NVA).
            
                  
* How are development priorities managed for the application?
  > It is important to understand how business features are prioritized relative to engineering fundamentals, especially if operations is a separate function
            
                  
* Are manual approval gates or workflows required to release to production?
  > Even with an automated deployment process there might be a requirement for manual approvals to fulfil regulatory compliance, and it is important to understand who owns any gates that do exist
            
                  
* Are tools or processes in place to grant access on a just in-time basis?
  > For example, Azure AD [Privileged Identity Management](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-configure) provides time-based and approval-based role activation to mitigate the risks of excessive, unnecessary, or misused access permissions on resources that you care about
            
    - Does anyone have long-standing write-access to production environments?
    > Write-access to production systems should be limited to service principals and no user accounts have regular write-access
                      
                  
              
## Common Engineering Criteria 
            
* Is the choice and desired configuration of Azure services centrally governed or can the developers pick and choose?
  > Many customers govern service configuration through a catalogue of allowed services that developers and application owners must pick from
            
                  
* Are tools and processes in place to govern available services, enforce mandatory operational functionality and ensure compliance? 
  > Proper standards for naming, tagging, the deployment of specific configurations such as diagnostic logging, and the available set of services and regions is important to drive consistency and ensure compliance. Solutions like [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) can help to enforce and assess compliance at-scale.
            
                  
* Are standards, policies, restrictions and best practices defined as code?
  > Policy-as-Code provides the same benefits as Infrastructure-as-Code in regards to versioning, automation, documentation as well as encouraging consistency and reproducibility. Available solutions in the market are [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) or [HashiCorp Sentinel](https://www.hashicorp.com/resources/introduction-sentinel-compliance-policy-as-code/).
            
                  
              