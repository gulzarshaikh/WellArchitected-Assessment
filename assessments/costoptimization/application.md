# Application Cost Optimization

# Navigation Menu

- [Design Principles](#design-principles)
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
    - [Design](#Design)
    - [Targets &amp; Non Functional Requirements](#Targets--Non-Functional-Requirements)
    - [Key Scenarios](#Key-Scenarios)
    - [Dependencies](#Dependencies)
    - [Application Composition](#Application-Composition)
  - [Health Modelling &amp; Monitoring](#Health-Modelling--Monitoring)
    - [Application Level Monitoring](#Application-Level-Monitoring)
    - [Resource and Infrastructure Level Monitoring](#Resource-and-Infrastructure-Level-Monitoring)
    - [Dashboarding](#Dashboarding)
    - [Alerting](#Alerting)
  - [Capacity &amp; Service Availability Planning](#Capacity--Service-Availability-Planning)
    - [Scalability &amp; Capacity Model](#Scalability--Capacity-Model)
    - [Service SKU](#Service-SKU)
    - [Efficiency](#Efficiency)
  - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Connectivity](#Connectivity)
    - [Endpoints](#Endpoints)
    - [Data flow](#Data-flow)
  - [Operational Procedures](#Operational-Procedures)
    - [Operational Lifecycles](#Operational-Lifecycles)
  - [Deployment &amp; Testing](#Deployment--Testing)
    - [Application Code Deployments](#Application-Code-Deployments)
    - [Build Environments](#Build-Environments)
    - [Testing &amp; Validation](#Testing--Validation)
  - [Operational Model &amp; DevOps](#Operational-Model--DevOps)
    - [Roles &amp; Responsibilities](#Roles--Responsibilities)
  - [Governance](#Governance)
    - [Standards](#Standards)
    - [Financial Management &amp; Cost Models](#Financial-Management--Cost-Models)
    - [Culture &amp; Dynamics](#Culture--Dynamics)
    - [Licensing](#Licensing)


# Design Principles

The following Design Principles provide context for questions, why a certain aspect is important and how is it applicable to Cost Optimization.

These critical design principles are used as lenses to assess the Cost Optimization of an application deployed on Azure, providing a framework for the application assessment questions that follow.


## Choose the correct resources for your business goals


  Choose the right resources that are aligned with business goals and can handle the performance needs of the workload. When onboarding new workloads explore the possibility of modernization and cloud native offerings where possible. Using the PaaS or SaaS layer as opposed to IaaS is typically more cost effective.



## Set up budgets and keep within cost constraints


  Consider the budget constraints as part of the architectural design, identifying acceptable boundaries pertaining to scale, redundancy, and performance against cost. After initial estimations, set budgets and alerts at different scopes to continuously measure the cost.



## Dynamically allocate and de-allocate resources to match performance needs


  Identify idle or underutilised resources (e.g. through Azure Advisor or other tools) and reconfigure, consolidate or shut down.



## Optimise your workloads and aim for scalable costs


  Consider the usage metrics and performance to determine the number of instances used as your workload cost should scale linearly with demand. The cost management process should be rigorous, iterative and a key principle of responsible cloud optimization.



## Continuously monitor and optimise your cost management


  Conduct regular cost reviews, measure and forecast the capacity needs so that you can provision resources dynamically and scale with demand.




---



# Application Assessment Checklist
## Application Design
    
### Design
            
* Was the application built natively for the cloud or was an existing on-premises system migrated?

  _Understanding if the application is cloud-native or not provides a very useful high level indication about potential technical debt for operability and cost efficiency._
  > While cloud-native workloads are preferred, migrated or modernized applications are reality and they might not utilize the available cloud functionality like auto-scaling, platform notifications etc. Make sure to understand the limitations and implement workarounds if available. 
* Is the workload deployed across multiple regions?

  _Multiple regions should be used for failover purposes in a disaster state, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active strategies. Additional cost needs to be taken into consideration - mostly from compute, data and networking perspective, but also services like [Azure Site Recovery (ASR)](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)._
  > Deploy across multiple regions for higher availability.  The ultimate goal is to set up the infrastructure in a way that it's able to automatically react to regional disasters. While active-active configuration would be the north star, not every workload requires two regions running simultaneously at all times, some don't even support it due to technical limitations. Depending on the availability, performance and cost requirements, passive or warm standby can be viable alternatives too.
    - Were regions chosen based on location and proximity to your users or based on resource types that were available?

      _Not only is it important to utilize regions close to your audience, but it is equally important to choose regions that offer the SKUs that will support your future growth. Not all regions share the same parity when it comes to product SKUs._
      > Plan your growth, then choose regions that will support those plans.  The ultimate goal is to set up the infrastructure in a way that it's able to automatically react to regional disasters. While active-active configuration would be the north star, not every workload requires two regions running simultaneously at all times, some don't even support it due to technical limitations. Depending on the availability, performance and cost requirements, passive or warm standby can be viable alternatives too.
  
      Additional resources:
        - [Products available by region](https://azure.microsoft.com/global-infrastructure/services/)
    - Are paired regions used?

      _[Paired regions](https://docs.microsoft.com/azure/best-practices-availability-paired-regions) exist within the same geography and provide native replication features for recovery purposes, such as Geo-Redundant Storage (GRS) asynchronous replication. In the event of planned maintenance, updates to a region will be performed sequentially only._
  
      Additional resources:
        - [Business continuity with Azure Paired Regions](https://docs.microsoft.com/azure/best-practices-availability-paired-regions)
    - Have you ensured that both (all) regions in use have the same performance and scale SKUs that are currently leveraged in the primary region?

      _When planning for scale and efficiency, it is important that regions are not only paired, but homogenous in their service offerings. Additionally, you should make sure that, if one region fails, the second region can scale appropriately to sufficiently handle the influx of additional user requests._
  
      Additional resources:
        - [Products available by region](https://azure.microsoft.com/en-us/global-infrastructure/services/)
  
    Additional resources:
    - [Failover strategies](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones)
  
    - [About Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)
* Within a region is the application architecture designed to use Availability Zones?

  _[Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) can be used to optimise application availability within a region by providing datacenter level fault tolerance. However, the application architecture must not share dependencies between zones to use them effectively. It is also important to note that Availability Zones may introduce performance and cost considerations for applications which are extremely 'chatty' across zones given the implied physical separation between each zone and inter-zone bandwidth charges. That also means that AZ can be considered to get higher SLA for lower cost. Be aware of [pricing changes](https://azure.microsoft.com/pricing/details/bandwidth/) coming to Availability Zone bandwidth starting February 2021._
  > Use Availability Zones where applicable to improve reliability and optimize costs. 
  
    Additional resources:
    - [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones)
* Is component proximity required for application performance reasons?

  _If all or part of the application is highly sensitive to latency it may mandate component co-locality which can limit the applicability of multi-region and multi-zone strategies._
  > Consider using the same datacenter region, Availability Zone and [Proximity Placement Groups](https://azure.microsoft.com/blog/announcing-the-general-availability-of-proximity-placement-groups/) and other options to bring latency sensitive components closer together. Keep also in mind that additional charges may apply when chatty workloads are spread across zones and region. 
* Has the application been designed to scale-out?

  _Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally. Don't forget about scale in as well, as this is important to drive cost down. For example, scale in and out for App Service is done via rules. Often customers write scale out rule and never write scale in rule, this leaves the App Service more expensive._
  > Design your solution with scalability in mind, leverage PaaS capabilities to [scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out) and in by adding additional intances when needed. 
  
    Additional resources:
    - [Design to scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out)
* Is an availability strategy defined? i.e. multi-geo, full/partial

  _An availability strategy should capture how the application remains available when in a failure state and should apply across all application components and the application deployment stamp as a whole such as via multi-geo scale-unit deployment approach. There are cost implications as well: More resources need to be provisioned in advance to provide high availability. Active-active setup, while more expensive than single deployment, can balance cost by lowering load on one stamp and reducing the total amount of resources needed._
* Has a Business Continuity Disaster Recovery (BCDR) strategy been defined for the application and/or its key scenarios?

  _A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach. To drive cost down consider splitting application components and data into groups. For example: 1) must protect, 2) nice to protect, 3) ephemeral/can be rebuilt/lost, instead of protecting all data with the same policy._
    - If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?

      _Quotas and limits typically apply at the region level and, therefore, the needed capacity should also be planned for the secondary region._
* Is the workload designed to scale independently?

  _If the workload contains multiple components and one component requires scale, this triggers scale-out/up of the entire infrastructure. It needs to be evaluated if the application scale is monolithic or each component is scaled independently and for example how the database scales with the rest of the workload._
* Is there a plan to modernize the workload?

  _Is there a plan to change the execution model to Serverless? To move as far as you can up the stack towards cloud-native. When the workload is serverless, it’s charged only for actual use, whereas whith traditional infrastructure there are many underlying things that need to be factored into the price. By applying an end date to the application it encourages you to discuss the goal of re-designing the application to make even better use of the cloud. It might be more expensive from an Azure cost point of view but factoring in other things like licenses, people, time to deploy can drive down cost._
### Targets &amp; Non Functional Requirements
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?

  _Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational actionality required by the application is going to far greater than if an SLO of 99.9% was the aspiration._
  > Have clearly defined availability targets.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?

      _If the application is depending on external services, their availability targets/commitments should be understood and ideally aligned with application targets._
      > Make sure SLAs/SLOs/SLIs for all leveraged dependencies are understood.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
    - Has a composite Service-Level Agreement (SLA) been calculated for the application and/or key scenarios using Azure SLAs?

      _A [composite SLA](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements) captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets._
      > Make sure the composite SLA of all components and dependencies on the critical paths are understood.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
  
      Additional resources:
        - [Composite SLA](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements)
    - Are availability targets considered while the system is running in disaster recovery mode?

      _The above defined targets might or might not be applied when running in DR mode. This depends from application to application._
      > Consider availability targets for disaster recovery mode.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
    - Are availability targets monitored and measured?

      _Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets._
      > Measure and monitor key availability targets.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
  
      Additional resources:
        - [Mean Time Between Failures](https://en.wikipedia.org/wiki/Mean_time_between_failures)
    - What are the consequences if availability targets are not satisfied?

      _Are there any penalties, such as financial charges, associated with failing to meet SLA commitments? Additional measures can be used to prevent penalties, but that also brings additional cost to operate the infrastructure. This has to be factored in and evaluated._
      > Understand the consequences of missing availability targets.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?

  _Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriate<br />**Recovery time objective (RTO)**: The maximum acceptable time the application is unavailable after a disaster incident<br />**Recovery point objective (RPO)**: The maximum duration of data loss that is acceptable during a disaster event_
  > Recovery targets should be defined in accordance to the required RTO and RPO targets for the workloads. 
  
    Additional resources:
    - [Protect and recover in cloud management](https://docs.microsoft.com/azure/cloud-adoption-framework/manage/considerations/protect)
* Are you able to predict general application usage?

  _It is important to understand application and environment usage. The customer may have an understanding of certain seasons or incidents that increase user load (e.g. a weather service being hit by users facing a storm, an e-commerce site during the holiday season)._
  > Traffic patterns should be identified by analyzing historical traffic data and the effect of significant external events on the application. 
    - If typical usage is predictable, are your predictions based on time of day, day of week, or season (e.g. holiday shopping season)?

      _Dig deeper and document predictable periods. By doing so, you can leverage resources like Azure Automation and Autoscale to proactively scale the application and its underlying environment._
    - Do you understand why your application responds to its typical load in the ways that it does?

      _Identifying a typical load helps you determine realistic expectations for performance testing. A "typical load" can be measured in individual users, web requests, user sessions, or transactions. When documenting typical loads, also ensure that all predictable periods have typical loads documented._
    - Are you able to reasonably predict when these peaks will occur?

    - Are you able to accurately predict the amount of load your application will experience during these peaks?

### Key Scenarios
            
* Have critical system flows through the application been defined for all key business scenarios?

  _Understanding critical system flows is vital to assessing overall operational effectiveness, and should be used to inform a health model for the application. It can also tell if areas of the application are over or under utilized and should be adjusted to better meet business needs and cost goals._
  > Path-wise analysis should be used to define critical system flows for key business scenarios, such as the checkout process for an eCommerce application. 
    - Do these critical system flows have distinct availability, performance, or recovery targets?

      _Critical sub-systems or paths through the application may have higher expectations around availability, recovery, and performance due to the criticality of associated business scenarios and functionality. This also helps to understand if cost will be affected due to these higher needs._
      > Targets should be specific and measurable. 
* Are there any application components which are less critical and have lower availability or performance requirements?

  _Some less critical components or paths through the application may have lower expectations around availability, recovery, and performance. This can result in cost reduction by choosing lower SKUs with less performance and availability._
  > Identify if there are components with more relaxed performance requirements. 
### Dependencies
            
* Are all internal and external dependencies identified and categorized as either weak or strong?

  _Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies captures required components outside the scope of the application, such as another application or third-party service._
  > Categorize dependencies as either weak or strong.  Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence.
    - Do you maintain a complete list of application dependencies?

      _Examples of typical dependencies include platform dependencies outside the remit of the application, such as Azure Active Directory, Express Route, or a central NVA (Network Virtual Appliance), as well as application dependencies such as APIs which may be in-house or externally owned by a third-party. For cost it’s important to  understand the price for these services and how they are being charged, this makes it easier to understanding an all up cost. For more details see cost models._
      > Map application dependencies either as a simple list or a document (usually this is part of a design document or reference architecture).  Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence.
    - Is the impact of an outage with each dependency well understood?

      _Strong dependencies play a critical role in application function and availability meaning their absence will have a significant impact, while the absence of weak dependencies may only impact specific features and not affect overall availability. For cost this reflects the cost that is needed to maintain the HA relationship between the service and it’s dependencies. It would explain why certain measures needs to be maintained in order to hold a given SLA._
      > Classify dependencies either as strong or weak. This will help identify which components are essential to the application.  Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence.
  
    Additional resources:
    - [Twelve-Factor App: Dependencies](https://12factor.net/dependencies)
* Are SLAs and support agreements in place for all critical dependencies?

  _Service Level Agreement (SLA) represents a commitment around performance and availability of the application. Understanding the SLA of individual components within the system is essential in order to define reliability targets. Knowing the SLA of dependencies will also provide a justifications for additional spend when making the dependencies highly available and with proper support contracts._
  > The operational commitments of all external and internal dependencies should be understood to inform the broader application operations and health model. 
### Application Composition
            
* What Azure services are used by the application?

  _It is important to understand what Azure services, such as App Services and Event Hubs, are used by the application platform to host both application code and data. In a discussion around cost, this can drive decisions towards the right replacements (e.g. moving from Virtual Machines to containers to increase efficiency, or migrating to .NET Core to use cheaper SKUs etc.)._
  > All Azure services in use should be identified. 
    - What operational features/capabilities are used for leveraged services?

      _Operational capabilities, such as auto-scale and auto-heal for App Services, can reduce management overheads, support operational effectiveness and reduce cost._
      > Make sure you understand the operational features/capabilities available and how they can be used in the solution. 
* What technologies and frameworks are used by the application?

  _It is important to understand what technologies are used by the application and must be managed, such as .NET Core , Spring, or Node.js._
  > Identify technologies and frameworks used by the application.  All technologies and frameworks should be identified. Vulnerabilities of these dependencies must be understood (there are automated solutions on the market that can help: [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) or [NPM audit](https://docs.npmjs.com/cli/audit).
  
    Additional resources:
    - [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
  
    - [NPM audit](https://docs.npmjs.com/cli/audit)
* Are components hosted on shared application or data platforms which are used by other applications?

  _Do application components leverage shared data platforms, such as a central data lake, or application hosting platforms, such as a centrally managed AKS or ASE cluster? Shared platforms drive down cost, but the workload needs to maintain the expected performance._
  > Make sure you understand the design decisions and implications of using shared hosting platforms. 
* How do you ensure that cloud resources are appropriately provisioned?

  _Deliberate selection of resources and sizing is important to maintain efficiency and optimal cost._
  > Automate based on the application lifespan, use DevOps and deployment automation, configure auto-scale policies for the workload (both in and out), select the right resource offering size (VM, disk, database), choose appropriate services that match business requirements. 
## Health Modelling &amp; Monitoring
    
### Application Level Monitoring
            
* Is an Application Performance Management (APM) tool used collect application level logs?

  _In order to successfully maintain the application it's important to 'turn the lights on' and have clear visibility of important metrics both in real-time and historically._
  > Use Application Performance Management tools.  An APM technology, such as [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview), should be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation. It should be considered what is the appropriate level of logging, because too much can incur significant costs.
  
    Additional resources:
    - [What is Application Insights?](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
### Resource and Infrastructure Level Monitoring
            
* Which log aggregation technology is used to collect logs and metrics from Azure resources?

  _Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as 3rd-party appliances such as firewalls or anti-malware solutions used in the application. For instance, if Azure Event Hub is used, the [Diagnostic Settings](https://docs.microsoft.com/azure/event-hubs/event-hubs-diagnostic-logs) should be configured to push logs and metrics to the data sink. Understanding usage helps with right-sizing of the workload, but additional cost for logging needs to be accepted and included in the cost model._
  > Use log aggregation technology, such as Azure Log Analytics or Splunk, to gather information across all application components. 
### Dashboarding
            
* Is Role Based Access Control (RBAC) used to control access to operational and financial dashboards and underlying data?

  _Are the dashboards openly available in your organization or do you limit access based on roles etc.? For example: developers usually don't need to know the overall cost of Azure for the company, but it might be good for them to be able to watch a particular workload._
  > Access to operational and financial data should be tightly controlled to align with segregation of duties, while making sure that it doesn't hinder operational effectiveness; i.e. scenarios where developers have to raise an ITSM (IT service management) ticket to access logs should be avoided. 
* Is there a dashboard showing cost related KPIs for this workload which gives a transparent view of the current situation?

  _Single pane of glass which can be shown during weekly ops meetings and instills accountability within everyone whilst also allowing you to understand where you are in terms of budget through every stage._
* Are you using Azure Cost Management (ACM) to track spending in this workload?

  _In order to track spending an ACM tool can help with understanding how much is spent, where and when. This helps to make better decisions about how and if cost can be reduced._
  > Use ACM or other cost management tools to understand if savings are possible. 
### Alerting
            
* What technology is used for alerting?

  _Alerts from tools such as Splunk or Azure Monitor proactively notify or respond to operational states that deviate from norm. Alerts can also enable cost-awareness by watching budgets and limits and helping workload teams to scale appropriately._
  > You should not rely on people to actively look for issues. Instead an alerting solution should be in place that can push notifications to relevant teams. For example by email, SMS or into an mobile app. 
* Are specific owners and processes defined for each alert type?

  _Having well-defined owners and response playbooks per alert is vital to optimizing operational effectiveness. Alerts don't have to be only technical, for example the budget owner should be made aware of capacity issues so that budgets can be adjusted and discussed._
  > Instead of treating all alerts the same, there should be a well-defined process which determines what teams are responsible to react to which alert type. 
* Are push notifications enabled to inform responsible parties of alerts in real time?

  _Do teams have to actively monitor the systems and dashboard or are alerts sent to them by email etc.? This can help identify not just operational incidents but also budget overruns._
  > It is important that alert owners get reliably notified of alerts, which could use many communication channels such as text messages, emails or push notifications to a mobile app. 
* Are there alerts defined for cost thresholds and limits?

  _This is to ensure that if any budget is close to threshold, the cost owner gets notified to take appropriate actions on the change._
  > Set up alerts for cost limits and thresholds. 
## Capacity &amp; Service Availability Planning
    
### Scalability &amp; Capacity Model
            
* Is there a capacity model for the application?

  _A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out._
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where N describes the capacity required to satisfy performance and availability requirements. This also prevents cost-related surprises when scaling out and realizing that multiple services need to be scaled at the same time. 
  
    Additional resources:
    - [Performance Efficiency - Capacity](https://docs.microsoft.com/azure/architecture/framework/scalability/capacity)
* Is capacity utilization monitored and used to forecast future growth?

  _Predicting future growth and capacity demands can prevent outages due to insufficient provisioned capacity over time._
  > Especially when demand is fluctuating, it is useful to monitor historical capacity utilization to derive predictions about future growth. Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status. 
  
    Additional resources:
    - [Supported metrics with Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/platform/metrics-supported)
### Service SKU
            
* Is Azure Advisor being used to optimize SKUs discovered in this workload?

  _Azure Advisor helps to optimize and improve efficiency of the workload by identifying idle and underutilized resources. It analyzes your configurations and usage telemetry and consolidates it into personalized, actionable recommendations to help you optimise your resources._
  > Use Azure Advisor to identify SKUs for optimization. 
    - Are the Advisor recommendations being reviewed weekly or bi-weekly for optimization?

      _Your underutilised resources need to be reviewed often in order to be identified and dealt with accordingly, in addition to ensuring that your actionable recommendations are up-to-date and fully optimised. For example, Azure Advisor monitors your virtual machine (VM) usage for 7 days and then identifies low-utilization VMs._
      > Review Azure Advisor recommendation periodically. 
* Have you deployed a Hub and Spoke Design or Virtual WAN?

  _Virtual WAN has costs that are different in hub and spoke design. The cost of the peering network or other service routing has to be included. If Private Link is deployed, peering is not billed - only private link._
  > Consider whether to deploy Hub and Spoke or Virtual WAN for this workload. 
### Efficiency
            
* Are cost-effective regions considered as part of the deployment selection?

  _Is there a technical/legal reason for deploying in a particular region? If not, it might be worth looking at another region to decrease cost. Also depending on the workload and data processing model, choosing a cheaper region might make more financial sense._
  > Choose appropriate region for workload deployment to optimize cost. 
* Is the price model of this workload clear? Do the consumers understand why they are paying the price per month?

  _As part of driving a good behavior it's important that the consumer has understood why they are paying the price for a service and also that the cost is transparent and fair to the user of the service or else it can drive wrong behavior._
* Is the distribution of the cost done in accordance with the usage of the service?

  _In order to drive down cost it can be advised to incentivize the user of driving the use of a service that helps put less burden on the platform and via this drive down cost as it falls back on the user if a good behavior is followed in order to drive down the price._
* Is it possible to benefit from higher density in this workload?

  _When running multiple applications (typically in multi-tenant or microservices scenarios) density can be increased by deploying them on shared infrastructure and utilizing it more. For example: Containerization and moving to Kubernetes (Azure Kubernetes Services) enables pod-based deployment which can utilize underlying nodes efficiently. Similar approach can be taken with App Service Plans. To prevent the 'noisy neighbour' situation, proper monitoring must be in place and performance analysis must be done (if possible)._
* Are the right sizes and SKUs used for workload services?

  _The required performance and infrastructure utilization are key factors which define the 'size' of Azure resources to be used, but there can be hidden aspects that affect cost too. Watch for cost variations between different SKUs - for example App Service Plans S3 cost the same as P2v2, but have worse performance characteristics. Once the purchased SKUs have been identified, determine if they purchased resources have the capabilities of supporting anticipated load. For example, if you expect the load to require 30 instances of an App Service, yet you are currently leveraging a Standard App Service Plan SKU (maximum of 10 instances supported), then you will need to upgrade your App Service Plan in order to accommodate the anticipated load._
  > Make sure the optimal service SKUs are used for this workload. 
* Is the workload using the right operating system for its servers?

  _Analyze the technology stack and identify which workloads are capable of running on Linux and which require Windows. Linux-based VMs and App Services are significantly cheaper, but require the app to run on supported stack (.NET Core, Node.js etc.)._
  > Make sure the optimal operating systems are used for this workload. 
## Networking &amp; Connectivity
    
### Connectivity
            
* Does the workload use Service Endpoints or Private Link for accessing Azure PaaS services?

  _[Service Endpoints](https://docs.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview) and [Private Link](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) can be leveraged to restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios). Don’t forget that Private Link is a paid service and has meters for inbound and outbound data processed. Private Endpoints are charged as well._
  > Use service endpoints and private links where appropriate. 
* Are you using Microsoft backbone or MPLS network?

  _Are you closer to your users or on-prem? If users are closer to the cloud you should use MSFT (i.e. egress traffic). MPLS is when another service provider gives you the line._
### Endpoints
            
* Does the organization have the capability and plans in place to mitigate DDoS attacks for this workload?

  _DDoS attacks can be very debilitating and completely block access to your services or even take down the services, depending on the type of DDoS attack._
  > Mitigate DDoS attacks. Use Standard protection for critical workloads where outage would have business impact. Also consider CDN as another layer of protection. 
* Are you using Azure Front Door, Azure App Gateway or Web Application Firewall?

  _There are cost implications to using Front Door with Web Application Firewall enabled, but it can save costs compared to using a 3rd party solution. Front Door has a good latency, because it uses unicast. If only 1 or 2 regions are required, Application Gateway can be used. There are cost implications of having a WAF – you should check pricing of hours and GB/s._
### Data flow
            
* Are you moving data between regions?

  _Moving data between regions can add additional cost - both on the storage layer or networking layer. It's worth reviewing if this cost is can be replaced via re-architecture or justified due to e.g. disaster recovery (DR)._
  > Consider if the cost of data transfer is acceptable. 
* How is the workload connected between regions? Is it using network peering or gateways?

  _VNET Peering has additional cost. Peering within the same region is cheaper than peering between regions or Global regions. Inbound and outbound traffic is charged at both ends of the peered networks._
  > Make sure the workload works with cross-region peering efficiently and be aware of additional costs. 
* How are Azure resources connecting to the internet? Via NSG or via on-prem internet?

  _Tunnelling internet traffic through on-premises can add extra cost as data has to go back to local network before it reaches the internet, this cost should be acknowledged._
## Operational Procedures
    
### Operational Lifecycles
            
* Does every environment have a target end date?

  _If your workload or environment isn't needed then you should be able to decommission it. The same should occur if you are introducing a new service or new feature._
* Does every environment have a target date for migrating to PaaS or serverless to bring all up cost and transfer risk?

  _To bring down cost the goal should be to get as many applications to only consume resources when they are used, this goes as an evolution from IaaS to PaaS to serverless where you only pay when a service I triggered. The PaaS and serverless might appear more expensive, but risk and other operational work is transferred to the cloud provider which should also be factored in as part of the cost (e.g. patching, monitoring, licenses)._
  > Utilize the PaaS pay-as-you-go consumption model where relevant. 
## Deployment &amp; Testing
    
### Application Code Deployments
            
* What is the process to deploy application releases to production?

  > The entire end-to-end CI/CD deployment process should be understood. 
    - How long does it take to deploy an entire production environment?

      _The time it takes to perform a complete environment deployment should align with recovery targets. Automation and agility also lead to cost savings due to the reduction of manual labor and errors._
      > The time it takes to perform a complete environment deployment should be fully understood as it needs to align with the recovery targets. 
### Build Environments
            
* Are releases to production gated by having it successfully deployed and tested in other environments?

  _Deploying to other environments and verifying changes before going into production can prevent bugs getting in front of end users._
  > It is recommended to have a staged deployment process which requires changes to have been validated in test environments first before they can hit production. 
* Is the application deployed to multiple environments with different configurations?

  _Understand the scope of the solution and distinguish between SKUs used in production and non-production environments. To drive down cost, it might be possible to for example consolidate environments for applications that are not as critical to the business and don't need the same testing._
    - What is the ratio of cost of production and non-production environments for this workload?

      _When the customer is spending more money on testing than production, it usually means they have too many non-production environments. Consider ratio of non-production to production environments and if ratio is substantially higher you should consider merging testing environments or re-visit why the cost is so much higher._
    - How many production vs. non-production environments do you have?

      _Provisioning non-production environments (like development, test, integration...) each on a separate infrastructure is not always necessary. E.g. using shared App Service Plans and consolidating Web Apps for development and testing environments can save costs._
### Testing &amp; Validation
            
* Are Dev/Test offerings used correctly for the workload?

  _Special SKUs and subscription offers for development and testing purposes can save costs, but have to be used properly. Dev SKUs are not meant for production deployments._
  > Use developer SKUs for dev/test purposes. 
* Are test-environments deployed automatically and deleted after use? Use of tagging for end date?

  _Automating test cases reduces time, cost and helps inefficient resource utilization. It also provides a structured approach to testing with test scripts. Test environments can quickly become overhead if not monitored properly, therefore stopping these resources when they are not in use enables cost saving. In order to drive down cost a good place to look is test environments that might not be used anymore. Implementing a process can help by tagging all test environments with an end date and an owner and after this date follow up with the owner if the environment is still needed and if so set a new end-of-life date._
  > Make sure to delete/deallocate resources used in test environments. 
## Operational Model &amp; DevOps
    
### Roles &amp; Responsibilities
            
* Has the application been built and maintained in-house or by an external partner?

  _Exploring where technical delivery capabilities reside helps to qualify operational model boundaries and estimate the cost of operating the application as well as defining a budget and cost model._
  > Explore where technical delivery capabilities reside. 
* Are Billing account names and structure consistent with reference to or use of Departments or Services, or Organization?

  _Transparency and traceability when it comes to cost in order to ensure that any discrepancies are able to be followed back to the source and be dealt with accordingly._
## Governance
    
### Standards
            
* Are Azure Tags used to enrich Azure resources with operational metadata?

  _Using tags can help to manage resources and make it easier to find relevant items during operational procedures._
  > [Azure Tags](https://docs.microsoft.com/azure/azure-resource-manager/management/tag-resources) provide the ability to associate critical metadata as a name-value pair, such as billing information (e.g. cost center code), environment information (e.g. environment type), with Azure resources, resource groups, and subscriptions. See [Tagging Strategies](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging) for best practices. 
  
    Additional resources:
    - [Use tags to organize your Azure resources and management hierarchy](https://docs.microsoft.com/azure/azure-resource-manager/management/tag-resources)
  
    - [Tagging Strategies](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging)
* Does the application have a well-defined naming standard for Azure resources?

  _A well-defined naming convention is important for overall operations to be able to easily determine the usage of certain resources and help understand owners and cost centers responsible for the workload. Naming conventions allow the matching of resource costs to particular workloads._
  > Implement a naming convention.  Having a well-defined [naming convention](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging) is important for overall operations, particularly for large application platforms where there are numerous resources.
  
    Additional resources:
    - [Naming Conventions](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
### Financial Management &amp; Cost Models
            
* How is your organization modeling cloud costs for this workload?

  _Estimate and track costs, educate the employees about the cloud and various pricing models, have appropriate governance about expenditure._
* What actions are you taking to optimize cloud costs of this workload?

  _Identify opportunities to reduce overall cost, use cost management tools to plan and track costs, tag resources and track that back to costs._
* Is there any weekly review process to follow up on budget overrun or signs of spend that should be dealt with?

  _During a weekly review a key area to discuss is high spending on SKUs or workloads that has a high cost, which might cause a budget overrun. Discussing these spendings early and plan for next step enables the business to be pro-active about spending._
  > Perform regular reviews focused on cost and spending for this workload. 
* Do all services used in this workload have a budget assigned to them?

  _For cost management it is recommended to have a budget even for the smallest services operated as that allows to track and understand the flow of the spend and also understand the impact of a smaller service in a bigger picture._
  > Assign a budget and spend limit to the workload. 
* Is there a cost owner for every service used by this workload?

  _Every service should have a cost owner that is tracking and is responsible for cost. This drives responsibility and awareness on who owns the cost tracking._
  > Establish a cost owner for each service used by the workload. 
* Is spending forecast to ensure it aligns with budget?

  _In order to predict costs and trends it’s recommended to use forecasting to be proactive for any spending that might be going up due to higher demand than anticipated._
  > Use cost forcasting as a tool to estimate if the workload is aligned with budget. 
* Do shared services have an owner and is all up cost with the distribution model defined and communicated by the owner to the service subscribers?

### Culture &amp; Dynamics
            
* What happens to the money that you’ve saved? If you go over budget do you have to save somewhere else?

* Are you allowed to exceed budget, if there is proven business justification for it?

* Is there a yearly or monthly meeting where you are able to re-negotiate budget or is it given to you?

  _As Azure changes and new services are introduced, it’s recommended that key services are revisited to see if any new services offered in Azure can help drive down cost or if new SKUs can help drive down cost. It’s recommended that this is done 1-4 times a year._
  > Revisit key Azure services to see if there were any updates which could reduce the spend. 
* When new applications are introduced to the company, how is the budget defined?

  _It is important to have a clear understanding how an IT budget is defined. This is especially true for applications that are not built in-house, where IT budget has to be factored in as part of the delivery._
  > Understand how is the budget defined. 
* When you build new workloads, are you factoring the budget into the building phase? (Is the cost associated to the criticality to the business?)

  _When building new applications it’s a good practice to have a discussion with the business regarding expectations and build a budget as early as possible and document assumptions of how the IT budget for the service was calculated._
* Is there an ongoing conversation between the app owner and the business?

  _Is what’s delivered from IT and what the business is expecting from IT mapped to the cost of the application?_
### Licensing
            
* Is A-HUB (Azure Hybrid Use Benefit) used to drive cost down in order to re-use licenses to drive cost down in cloud?

  _Understanding your current spending on licenses can help you drive down cost in the cloud. A-HUB allows you to reuse licenses that you purchased for on-premises in Azure and via this drive down the cost as the license is already paid._
  > See if you can use the hybrid use benefit to reuse licensing. 
* Are any special discounts given to services or licenses that should be factored in when calculating new cost models for services being moved to the cloud?

  _When alternative cost options are considered it should be understood first if any special offers or deals are given for the existing SKUs to verify that the correct prices are being used to build a business case._
  > Learn if there are any discounts available for the services already in use. 
* Is there an owner for licensing and is this owner aware of any benefits that can be driven for hybrid license models?

  _Having a go to person in the company who understands the rules and knows what has been bought helps making sure that the right licenses are being used before building a business case for a new workload / application in Azure._