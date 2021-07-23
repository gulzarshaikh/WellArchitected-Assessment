# Application Operational Excellence

# Navigation Menu

- [Design Principles](#design-principles)
- [Definition of Workload](#Workload-Definition)
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
    - [Design](#Design)
    - [Targets &amp; Non-Functional Requirements](#Targets--Non-Functional-Requirements)
    - [Key Scenarios](#Key-Scenarios)
    - [Dependencies](#Dependencies)
    - [Application Composition](#Application-Composition)
  - [Health Modelling &amp; Monitoring](#Health-Modelling--Monitoring)
    - [Application Level Monitoring](#Application-Level-Monitoring)
    - [Resource and Infrastructure Level Monitoring](#Resource-and-Infrastructure-Level-Monitoring)
    - [Monitoring and Measurement](#Monitoring-and-Measurement)
    - [Dependencies](#Dependencies)
    - [Data Interpretation &amp; Health Modelling](#Data-Interpretation--Health-Modelling)
    - [Dashboarding](#Dashboarding)
    - [Alerting](#Alerting)
  - [Capacity &amp; Service Availability Planning](#Capacity--Service-Availability-Planning)
    - [Scalability &amp; Capacity Model](#Scalability--Capacity-Model)
    - [Service Availability](#Service-Availability)
  - [Application Performance Management](#Application-Performance-Management)
    - [Data Size/Growth](#Data-SizeGrowth)
    - [Data Latency and Throughput](#Data-Latency-and-Throughput)
    - [Elasticity](#Elasticity)
  - [Operational Procedures](#Operational-Procedures)
    - [Recovery &amp; Failover](#Recovery--Failover)
    - [Configuration &amp; Secrets Management](#Configuration--Secrets-Management)
    - [Operational Lifecycles](#Operational-Lifecycles)
    - [Patch &amp; Update Process (PNU)](#Patch--Update-Process-PNU)
  - [Deployment &amp; Testing](#Deployment--Testing)
    - [Application Code Deployments](#Application-Code-Deployments)
    - [Application Infrastructure Provisioning](#Application-Infrastructure-Provisioning)
    - [Build Environments](#Build-Environments)
    - [Testing &amp; Validation](#Testing--Validation)
  - [Operational Model &amp; DevOps](#Operational-Model--DevOps)
    - [General](#General)
    - [Roles &amp; Responsibilities](#Roles--Responsibilities)
  - [Governance](#Governance)
    - [Standards](#Standards)


# Design Principles

The following Design Principles provide context for questions, why a certain aspect is important and how is it applicable to Operational Excellence.

These critical design principles are used as lenses to assess the Operational Excellence of an application deployed on Azure, providing a framework for the application assessment questions that follow.


## Optimize build and release processes


  From provisioning with Infrastructure as Code, to build and releases with CI/CD pipelines, to automated testing, embrace software engineering disciplines across your entire environment. This approach ensures the creation and management of environments throughout the software development lifecycle is consistent, repeatable, and enables early detection of issues.



## Understand operational health through focused and assertive monitoring


  Implement systems and processes to monitor build and release processes, infrastructure health, and application health. Telemetry is critical to understanding the health of a workload and whether the service is meeting the business goals.



## Rehearse recovery and practice failure


  Run DR drills on regular cadence and use chaos engineering practices to identify and remediate weak points in application reliability. Regular rehearsal of failure will validate the effectiveness of recovery processes and ensure teams are familiar with their responsibilities.



## Embrace continuous operational improvement


  Continuously evaluate and refine operational procedures and tasks, while striving to reduce complexity and ambiguity. This approach enables an organization to evolve processes over time, optimizing inefficiencies and learning from failures.



## Use loosely coupled architecture


  Enable teams to independently test, deploy, and update their systems on demand without depending on other teams for support, services, resources, or approvals.




---



# Definition of Workload

To ensure a successful assessment it is important to scope it to the right customer *workload*. We realize that the term is quite ambiguous and used in various contexts, so for the Well Architected assessments, we define it as:

*A "workload" or "application" is a resource or collection of resources that provide end-to-end functionality to one or multiple clients (humans or systems). Another way to think of it: A workload is an end-to-end scenario (a process) and the IT infrastructure supporting it. It can be one application, it can be multiple apps, APIs and databases working together to deliver a specific functionality.*

Some examples:
* The Azure part of ticket ordering workload would be 1) the client web application, used by consumers to book tickets, 2) the payment gateway used to process credit card transactions, 3) the backend API handling communication, 4) the database where everything is stored, 5) the gateway to on-premises systems handling capacities and available seats, 5) the admin web application, 6) the shared AAD supporting authentication for administrators across the organization... etc.
* A data processing pipeline, which every night 1) ingests data from SAP and other on-premises systems, 2) runs data analytics workbooks on Azure Databricks, 3) stores results into Storage Accounts, 4) is accessed by a desktop application, 5) only for authenticated users from the organization.

Compared to reviewing the whole Azure landscape of an organization, this focus allows us to go deeper into the workload and architecture and provide more relevant recommendations, which are quite often transferrable to other workloads within the same customer as well. 

# Application Assessment Checklist
## Application Design
    
### Design
            
* Was the application built natively for the cloud or was an existing on-premises system migrated?

  _Understanding if the application is cloud-native or not provides a very useful high-level indication about potential technical debt for operability and cost efficiency._
  > While cloud-native workloads are preferred, migrated or modernized applications are reality and they might not utilize the available cloud functionality like auto-scaling, platform notifications etc. Make sure to understand the limitations and implement workarounds if available.
* Does the application have components on-premises or in another cloud platform?

  _Hybrid and cross-cloud workloads with components on-premises or on different cloud platforms, such as AWS or GCP, introduce additional operational considerations around achieving a 'single pane of glass' for operations._
  > Make sure that any hybrid or cross cloud relationships and dependencies are well understood
* Is the workload deployed across multiple regions?

  _Multiple regions should be used for failover purposes in a disaster state, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active strategies. Additional cost needs to be taken into consideration - mostly from compute, data and networking perspective, but also services like [Azure Site Recovery (ASR)](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)._
  > Deploy across multiple regions for higher availability
  > 
  > *The ultimate goal is to set up the infrastructure in a way that it's able to automatically react to regional disasters. While active-active configuration would be the north star, not every workload requires two regions running simultaneously at all times, some don't even support it due to technical limitations. Depending on the availability, performance and cost requirements, passive or warm standby can be viable alternatives too.*
    - Were regions chosen based on location and proximity to your users or based on resource types that were available?

      _Not only is it important to utilize regions close to your audience, but it is equally important to choose regions that offer the SKUs that will support your future growth. Not all regions share the same parity when it comes to product SKUs._
      > Plan your growth, then choose regions that will support those plans
  
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

  _[Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) can be used to optimize application availability within a region by providing datacenter level fault tolerance. However, the application architecture must not share dependencies between zones to use them effectively. It is also important to note that Availability Zones may introduce performance and cost considerations for applications which are extremely 'chatty' across zones given the implied physical separation between each zone and inter-zone bandwidth charges. That also means that AZ can be considered to get higher Service Level Agreement (SLA) for lower cost. Be aware of [pricing changes](https://azure.microsoft.com/pricing/details/bandwidth/) coming to Availability Zone bandwidth starting February 2021._
  > Use Availability Zones where applicable to improve reliability and optimize costs
  
    Additional resources:
    - [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones)
* Is the application implemented with strategies for resiliency and self-healing?

  _Strategies for resiliency and self-healing include retrying transient failures and failing over to a secondary instance or even another region._
  > Consider implementing strategies and capabilities for resiliency and self-healing needed to achieve workload availability targets. Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults.
  
    Additional resources:
    - [Designing resilient Azure applications](https://docs.microsoft.com/azure/architecture/framework/resiliency/app-design)
  
    - [Error handling for resilient applications](https://docs.microsoft.com/azure/architecture/framework/resiliency/app-design-error-handling)
* Is the application designed to use managed services?

  _Platform-as-a-Service (PaaS) services provide native resiliency capabilities to support overall application reliability and native capabilities for scalability, monitoring and disaster recovery._
  > Where possible prefer Platform-as-a-Service (PaaS) offerings to leverage their advanced capabilities and to avoid managing the underlying infrastructure
  
    Additional resources:
    - [Use managed services](https://docs.microsoft.com/azure/architecture/guide/design-principles/managed-services)
  
    - [What is PaaS?](https://azure.microsoft.com/overview/what-is-paas/)
* Has the application been designed to scale-out?

  _Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally. Don't forget about scale in as well, as this is important to drive cost down. For example, scale in and out for App Service is done via rules. Often customers write scale out rule and never write scale in rule, this leaves the App Service more expensive._
  > Design your solution with scalability in mind, leverage PaaS capabilities to [scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out) and in by adding additional instances when needed
  
    Additional resources:
    - [Design to scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out)
* Is the application deployed across multiple Azure subscriptions?

  _Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when analyzing if relevant subscription limits or quotas can be navigated._
* Has a Business Continuity Disaster Recovery (BCDR) strategy been defined for the application and/or its key scenarios?

  _A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach. To drive cost down consider splitting application components and data into groups. For example: 1) must protect, 2) nice to protect, 3) ephemeral/can be rebuilt/lost, instead of protecting all data with the same policy._
    - If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?

      _Quotas and limits typically apply at the region level and, therefore, the needed capacity should also be planned for the secondary region._
### Targets &amp; Non-Functional Requirements
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?

  _Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational activity required by the application is going to be far greater than if an SLO of 99.9% was the aspiration._
  > Have clearly defined availability targets
  > 
  > *Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the Service Level Agreement (SLA) they offer.*
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?

      _If the application is depending on external services, their availability targets/commitments should be understood and ideally aligned with application targets._
      > Make sure SLAs/SLOs/SLIs for all leveraged dependencies are understood
    - Has a composite Service-Level Agreement (SLA) been calculated for the application and/or key scenarios using Azure SLAs?

      _A [composite SLA](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements) captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets._
      > Make sure the composite SLA of all components and dependencies on the critical paths are understood
  
      Additional resources:
        - [Composite Service Level Agreement (SLA)](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements)
    - Are availability targets considered while the system is running in disaster recovery mode?

      _The above defined targets might or might not be applied when running in Disaster Recovery (DR) mode. This depends from application to application._
      > Consider availability targets for disaster recovery mode
      > 
      > *If targets must also apply in a failure state, then an N+1 model should be used to achieve greater availability and resiliency, where N is the capacity needed to deliver required availability. There's also a cost implication, because a more resilient infrastructure usually means more costs being involved. This has to be accepted by business.*
    - Are availability targets monitored and measured?

      _Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets._
      > Measure and monitor key availability targets
      > 
      > *Make sure you measure and monitor key targets such as **Mean Time Between Failures (MTBF)** which denotes the average time between failures of a particular component.*
  
      Additional resources:
        - [Mean Time Between Failures](https://en.wikipedia.org/wiki/Mean_time_between_failures)
    - What are the consequences if availability targets are not satisfied?

      _Are there any penalties, such as financial charges, associated with failing to meet Service Level Agreement (SLA) commitments? Additional measures can be used to prevent penalties, but that also brings additional cost to operate the infrastructure. This has to be factored in and evaluated._
      > Understand the consequences of missing availability targets
      > 
      > *It should be fully understood what are the consequences if availability targets are not satisfied. This will also inform when to initiate a failover case.*
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?

  _Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriate<br />**Recovery time objective (RTO)**: The maximum acceptable time the application is unavailable after a disaster incident<br />**Recovery point objective (RPO)**: The maximum duration of data loss that is acceptable during a disaster event_
  > Recovery targets should be defined in accordance to the required RTO and RPO targets for the workloads
  
    Additional resources:
    - [Protect and recover in cloud management](https://docs.microsoft.com/azure/cloud-adoption-framework/manage/considerations/protect)
* Are you able to predict general application usage?

  _It is important to understand application and environment usage. The customer may have an understanding of certain seasons or incidents that increase user load (e.g. a weather service being hit by users facing a storm, an e-commerce site during the holiday season)._
  > Traffic patterns should be identified by analyzing historical traffic data and the effect of significant external events on the application
    - If typical usage is predictable, are your predictions based on time of day, day of week, or season (e.g. holiday shopping season)?

      _Dig deeper and document predictable periods. By doing so, you can leverage resources like Azure Automation and Autoscale to proactively scale the application and its underlying environment._
    - Do you understand why your application responds to its typical load in the ways that it does?

      _Identifying a typical load helps you determine realistic expectations for performance testing. A "typical load" can be measured in individual users, web requests, user sessions, or transactions. When documenting typical loads, also ensure that all predictable periods have typical loads documented._
    - Are you able to reasonably predict when these peaks will occur?

    - Are you able to accurately predict the amount of load your application will experience during these peaks?

* Are there well-defined performance requirements for the application and/or key scenarios?

  _Non-functional performance requirements, such as those relating to end-user experiences (e.g. average and maximum response times) are vital to assessing the overall health of an application, and is a critical lens required for assessing operations._
  > Identify sensible non-functional requirements
  > 
  > *Work with stakeholders to identify sensible non-functional requirements based on business requirements, research and user testing.*
    - Are there any targets defined for the time it takes to perform scale operations?

      _Scale operations (horizontal - changing the number of identical instances, vertical - switching to more/less powerful instances) can be fast, but usually take time to complete. It's important to understand how this delay affects the application under load and if degraded performance is acceptable._
      > The application should be designed to scale to cope with spikes in load in-line with what is an acceptable duration for degraded performance
    - What is the maximum traffic volume the application is expected to serve without performance degradation?

      _Scale requirements the application must be able to effectively satisfy, such as the number of concurrent users or requests per second, is a critical lens for assessing operations. From the cost perspective, it's recommended to set a budget for extreme circumstances and indicate upper limit for cost (when it's not worth serving more traffic due to overall costs)._
      > Traffic limits for the application should be defined in quantified and measurable manner
    - Are these performance targets monitored and measured across the application and/or key scenarios?

      _Monitoring and measuring end-to-end application performance is vital to qualifying overall application health and progress towards defined targets._
      > Automation and specialized tooling (such as Application Insights) should be used to orchestrate and measure application performance
### Key Scenarios
            
* Have critical system flows through the application been defined for all key business scenarios?

  _Understanding critical system flows is vital to assessing overall operational effectiveness, and should be used to inform a health model for the application. It can also tell if areas of the application are over or under-utilized and should be adjusted to better meet business needs and cost goals._
  > Path-wise analysis should be used to define critical system flows for key business scenarios, such as the checkout process for an eCommerce application
    - Do these critical system flows have distinct availability, performance, or recovery targets?

      _Critical sub-systems or paths through the application may have higher expectations around availability, recovery, and performance due to the criticality of associated business scenarios and functionality. This also helps to understand if cost will be affected due to these higher needs._
      > Targets should be specific and measurable
* Are there any application components which are less critical and have lower availability or performance requirements?

  _Some less critical components or paths through the application may have lower expectations around availability, recovery, and performance. This can result in cost reduction by choosing lower SKUs with less performance and availability._
  > Identify if there are components with more relaxed performance requirements
### Dependencies
            
* Are all internal and external dependencies identified and categorized as either weak or strong?

  _Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies capture required components outside the scope of the application, such as another application or third-party service._
  > Categorize dependencies as either weak or strong
  > 
  > *Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence.*
    - Do you maintain a complete list of application dependencies?

      _Examples of typical dependencies include platform dependencies outside the remit of the application, such as Azure Active Directory, Express Route, or a central NVA (Network Virtual Appliance), as well as application dependencies such as APIs which may be in-house or externally owned by a third-party. For cost it’s important to understand the price for these services and how they are being charged, this makes it easier to understanding an all-up cost. For more details see cost models._
      > Map application dependencies either as a simple list or a document (usually this is part of a design document or reference architecture)
    - Is the impact of an outage with each dependency well understood?

      _Strong dependencies play a critical role in application function and availability meaning their absence will have a significant impact, while the absence of weak dependencies may only impact specific features and not affect overall availability. This reflects the cost that is needed to maintain the HA relationship between the service and its dependencies. It would explain why certain measures needs to be maintained in order to hold a given Service Level Agreement (SLA)._
      > Classify dependencies either as strong or weak. This will help identify which components are essential to the application
  
    Additional resources:
    - [Twelve-Factor App: Dependencies](https://12factor.net/dependencies)
* Are Service Level Agreement (SLA) and support agreements in place for all critical dependencies?

  _Service Level Agreement (SLA) represents a commitment around performance and availability of the application. Understanding the Service Level Agreement (SLA) of individual components within the system is essential in order to define reliability targets. Knowing the SLA of dependencies will also provide a justification for additional spend when making the dependencies highly available and with proper support contracts._
  > The operational commitments of all external and internal dependencies should be understood to inform the broader application operations and health model
* Are all platform-level dependencies identified and understood?

  _The usage of platform level dependencies such as Azure Active Directory must also be understood to ensure that their availability and recovery targets align with that of the application._
* Is the lifecycle of the application decoupled from its dependencies?

  _If the application lifecycle is closely coupled with that of its dependencies it can limit the operational agility of the application, particularly where new releases are concerned._
### Application Composition
            
* What Azure services are used by the application?

  _It is important to understand what Azure services, such as App Services and Event Hubs, are used by the application platform to host both application code and data. In a discussion around cost, this can drive decisions towards the right replacements (e.g. moving from Virtual Machines to containers to increase efficiency, or migrating to .NET Core to use cheaper SKUs etc.)._
  > All Azure services in use should be identified
    - What operational features/capabilities are used for leveraged services?

      _Operational capabilities, such as auto-scale and auto-heal for App Services, can reduce management overheads, support operational effectiveness and reduce cost._
      > Make sure you understand the operational features/capabilities available and how they can be used in the solution
* What technologies and frameworks are used by the application?

  _It is important to understand what technologies are used by the application and must be managed, such as .NET Core, Spring, or Node.js._
  > Identify technologies and frameworks used by the application
  > 
  > *All technologies and frameworks should be identified. Vulnerabilities of these dependencies must be understood (there are automated solutions on the market that can help: [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) or [NPM audit](https://docs.npmjs.com/cli/audit).*
  
    Additional resources:
    - [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
  
    - [NPM audit](https://docs.npmjs.com/cli/audit)
* Are components hosted on shared application or data platforms which are used by other applications?

  _Do application components leverage shared data platforms, such as a central data lake, or application hosting platforms, such as a centrally managed Azure Kubernetes Service (AKS) or App Service Environment (ASE) cluster? Shared platforms drive down cost, but the workload needs to maintain the expected performance._
  > Make sure you understand the design decisions and implications of using shared hosting platforms
* Do you monitor and regularly review new features and capabilities?

  _Azure is continuously evolving, with new features and services becoming available which may be beneficial for the application._
  > Keep up to date on newest developments and feature updates, at least for services most relevant to your application
    - Do you subscribe to Azure service announcements for new features and capabilities?

      _Service announcements provide insights into new features and services, as well as features or services which become deprecated._
      > Use announcement subscriptions to stay up to date
## Health Modelling &amp; Monitoring
    
### Application Level Monitoring
            
* Is an Application Performance Management (APM) tool used collect application level logs?

  _In order to successfully maintain the application it's important to 'turn the lights on' and have clear visibility of important metrics both in real-time and historically._
  > Use Application Performance Management tools
  > 
  > *An APM technology, such as [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview), should be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation. It should be considered what is the appropriate level of logging, because too much can incur significant costs.*
  
    Additional resources:
    - [What is Application Insights?](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
* Are application logs collected from different application environments?

  _Application logs support the end-to-end application lifecycle. Logging is essential in understanding how the application operates in various environments and what events occur and under which conditions._
  > Collect application logs across application environments
  > 
  > *Application logs and events should be collected across all major environments. Sufficient degree of separation and filtering should be in place to ensure non-critical environments do not convolute production log interpretation. Furthermore, corresponding log entries across the application should capture a correlation ID for their respective transactions.*
* Are log messages captured in a structured format?

  _Structured format, following well-known schema can help in parsing and analyzing logs._
  > Application events should be captured as a structured data type with machine-readable data points rather than unstructured string types
  > 
  > *Structured data can easily be indexed and searched, and reporting can be greatly simplified.*
* Are log levels used to capture different types of application events?

  _Different log levels, such as INFO, WARNING, ERROR, and DEBUG can be used across environments (such as DEBUG for development environment)._
  > Configure appropriate log levels for environments
  > 
  > *Different log levels, such as INFO, WARNING, ERROR, and DEBUG should be pre-configured and applied within relevant environments. The approach to change log levels should be simple configuration change to support operational scenarios where it is necessary to elevate the log level within an environment.*
* Are application events correlated across all application components?

  _[Distributed tracing](https://docs.microsoft.com/azure/architecture/microservices/logging-monitoring#distributed-tracing) provides the ability to build and visualize end-to-end transaction flows for the application._
  > Events coming from different application components or different component tiers of the application should be correlated to build end-to-end transaction flows
  > 
  > *For instance, this is often achieved by using consistent correlation IDs transferred between components within a transaction.<br /><br />Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made, you can see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a given transaction that has flowed through the system.*
  
    Additional resources:
    - [Distributed tracing](https://docs.microsoft.com/azure/architecture/microservices/logging-monitoring#distributed-tracing)
* Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?

  > Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.
    - Is the end-to-end performance of critical system flows monitored?

      _To fully assess the health of key scenarios in the context of targets and NFRs, application log events across critical system flows should be correlated._
      > Correlate application log events across critical system flows, such as user login
* Do you have detailed instrumentation in the application code?

  _Instrumentation of your code allows precise detection of underperforming pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code. Application Performance Monitoring (APM) tools, such as Application Insights, should be used to manage the performance and availability of the application, along with aggregating application level logs and events for subsequent interpretation._
### Resource and Infrastructure Level Monitoring
            
* Which log aggregation technology is used to collect logs and metrics from Azure resources?

  _Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as 3rd-party appliances such as firewalls or anti-malware solutions used in the application. For instance, if Azure Event Hub is used, the [Diagnostic Settings](https://docs.microsoft.com/azure/event-hubs/event-hubs-diagnostic-logs) should be configured to push logs and metrics to the data sink. Understanding usage helps with right-sizing of the workload, but additional cost for logging needs to be accepted and included in the cost model._
  > Use log aggregation technology, such as Azure Log Analytics or Splunk, to gather information across all application components
* Are you collecting Azure Activity Logs within the log aggregation tool?

  _Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. Such information is extremely useful for the interpretation and troubleshooting of operational and performance issues, as it provides transparency around configuration changes._
  > Azure Activity Logs should be collected and aggregated
* Is resource-level monitoring enforced throughout the application?

  _Resource- or infrastructure-level monitoring refers to the used platform services such as Azure VMs, Express Route or SQL Database. But also covers 3rd-party solutions like an NVA._
  > All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Azure Policy should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.
* Are logs and metrics available for critical internal dependencies?

  _To be able to build a robust application health model it is vital that visibility into the operational state of critical internal dependencies, such as a shared NVA or Express Route connection, be achieved._
  > Collect and store logs and key metrics of critical components
### Monitoring and Measurement
            
* Is white-box monitoring used to instrument the application with semantic logs and metrics?

  _Application level metrics and logs, such as current memory consumption or request latency, should be collected from the application to inform a health model and detect/predict issues._
  
    Additional resources:
    - [Instrumenting an application with Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
* Is the application instrumented to measure the customer experience?

  _Effective instrumentation is vital to detecting and resolving performance anomalies that can impact customer experience and application availability._
  
    Additional resources:
    - [Monitor performance](https://docs.microsoft.com/azure/azure-monitor/app/web-monitor-performance)
* Is black-box monitoring used to measure platform services and the resulting customer experience?

  _Black-box monitoring tests externally visible application behavior without knowledge of the internals of the system. This is a common approach to measuring customer-centric SLIs/SLOs/SLAs._
  
    Additional resources:
    - [Azure Monitor Reference](https://docs.microsoft.com/azure/azure-monitor/app/monitor-web-app-availability)
* Are there known gaps in application observability that led to missed incidents and/or false positives?

  _What you cannot see, you cannot measure. What you cannot measure, you cannot improve._
* Are error budgets used to track service reliability?

  _An error budget describes the maximum amount of time that the application can fail without consequence, and is typically calculated as 1-Service Level Agreement (SLA). For example, if the SLA specifies that the application will function 99.99% of the time before the business has to compensate customers, the error budget is 52 minutes and 35 seconds per year. Error budgets are a device to encourage development teams to minimize real incidents and maximize innovation by taking risks within acceptable limits, given teams are free to ‘spend’ budget appropriately._
* Is there an policy that dictates what will happen when the error budget has been exhausted?

  _If the application error budget has been met or exceeded and the application is operating at or below the defined Service Level Agreement (SLA), a policy may stipulate that all deployments are frozen until they reduce the number of errors to a level that allows deployments to proceed._
### Dependencies
            
* Are critical external dependencies monitored?

  _It's common for applications to depend on other services or libraries. Despite these are external, it is still possible to monitor their health and availability using probes._
  > Monitor critical external dependencies
  > 
  > *Critical external dependencies, such as an API service, should be monitored to ensure operational visibility of dependency health. For instance, a probe could be used to measure the availability and latency of an external API.*
* Is the application instrumented to track calls to dependent services?

  _[Dependency tracking](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-dependencies) and measuring the duration/status of dependency calls is vital to measuring overall application health and should be used to inform a health model for the application._
  
    Additional resources:
    - [Dependency tracking](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-dependencies)
### Data Interpretation &amp; Health Modelling
            
* Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?

  _To build a robust application health model it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues._
  > Implement a unified solution to aggregate and query application and resource level logs, such as Azure Log Analytics
* Are application level events automatically correlated with resource level metrics to quantify the current application state?

  _The overall health state can be impacted by both application-level issues as well as resource-level failures. [Telemetry correlation](https://docs.microsoft.com/azure/azure-monitor/app/correlation) should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform-level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues. This can also help to distinguish between transient and non-transient faults._
  
    Additional resources:
    - [Telemetry correlation](https://docs.microsoft.com/azure/azure-monitor/app/correlation)
* Is the transaction flow data used to generate application/service maps?

  _Is there a correlation between events in different services and are those visualized?_
  > An [Application Map](https://docs.microsoft.com/azure/azure-monitor/app/app-map?tabs=net) can help spot performance bottlenecks or failure hotspots across components of a distributed application
  
    Additional resources:
    - [Application Map](https://docs.microsoft.com/azure/azure-monitor/app/app-map?tabs=net)
* Is a health model used to qualify what 'healthy' and 'unhealthy' states represent for the application?

  > Implement a health model
  > 
  > *A holistic application health model should be used to quantify what 'healthy' and 'unhealthy' states represent across all application components. It is highly recommended that a 'traffic light' model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in <= 500ms with Azure Kubernetes Service (AKS) node utilization at x% etc. Once established, this health model should inform critical monitoring metrics across system components and operational sub-system composition. It is important to note that the health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state.*
    - Are critical system flows used to inform the health model?

      > The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow.
    - Can the health model distinguish between transient and non-transient faults?

      _Is the health model treating all failures the same?_
      > The health model should clearly distinguish between expected transient but recoverable failures and a true disaster state
    - Can the health model determine if the application is performing at expected performance targets?

      _The health model should have the ability to evaluate application performance as a part of the application's overall health state_
* Are long-term trends analyzed to predict operational issues before they occur?

  _Are Operations and/or analytics teams using the stored events for machine learning or similar to make predictions for the future?_
  > Analytics can and should be performed across long-term operational data to help inform operational strategies and also to predict what operational issues are likely to occur and when. For instance, if the average response times have been slowly increasing over time and getting closer to the maximum target.
* Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?

  > Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis.
### Dashboarding
            
* What technology is used to visualize the application health model and encompassed logs and metrics?

  _Visualization, often also called Dashboarding, refers to how data is presented to operations teams and other interested users._
  > Dashboarding tools, such as Azure Monitor or [Grafana](https://grafana.com/), should be used to visualize metrics and events collected at the application and resource levels, to illustrate the health model and the current operational state of the application.
  
    Additional resources:
    - [Azure Monitor overview](https://docs.microsoft.com/azure/azure-monitor/overview)
  
    - [Grafana](https://grafana.com/)
* Are dashboards tailored to a specific audience?

  _Is there just one big dashboard or do you build individualized solutions for different teams (e.g. networking teams might have a different interest focus than the security team)?_
  > Dashboards should be customized to represent the precise lens of interest of the end-user. For example, the areas of interest when evaluating the current state will differ greatly between developers, security and networking. Tailored dashboards make interpretation easier and accelerates time to detection and action.
* Is Role Based Access Control (RBAC) used to control access to operational and financial dashboards and underlying data?

  _Are the dashboards openly available in your organization or do you limit access based on roles etc.? For example: developers usually don't need to know the overall cost of Azure for the company, but it might be good for them to be able to watch a particular workload._
  > Access to operational and financial data should be tightly controlled to align with segregation of duties, while making sure that it doesn't hinder operational effectiveness; i.e. scenarios where developers have to raise an ITSM (IT service management) ticket to access logs should be avoided.
### Alerting
            
* What technology is used for alerting?

  _Alerts from tools such as Splunk or Azure Monitor proactively notify or respond to operational states that deviate from norm. Alerts can also enable cost-awareness by watching budgets and limits and helping workload teams to scale appropriately._
  > Use automated alerting solution
  > 
  > *You should not rely on people to actively look for issues. Instead, an alerting solution should be in place that can push notifications to relevant teams. For example, by email, SMS or into a mobile app.*
* Are specific owners and processes defined for each alert type?

  _Having well-defined owners and response playbooks per alert is vital to optimizing operational effectiveness. Alerts don't have to be only technical, for example the budget owner should be made aware of capacity issues so that budgets can be adjusted and discussed._
  > Define a process for alert reaction
  > 
  > *Instead of treating all alerts the same, there should be a well-defined process which determines what teams are responsible to react to which alert type.*
* Are operational events prioritized based on business impact?

  _Are all alerts being treated the same or do you analyze the potential business impact when defining an alert?_
  > Tagging events with a specific severity or urgency helps operational teams prioritize in cases where multiple events require intervention at the same time. For example, alerts concerning critical system flows might require special attention.
* Are push notifications enabled to inform responsible parties of alerts in real time?

  _Do teams have to actively monitor the systems and dashboard or are alerts sent to them by email etc.? This can help identify not just operational incidents but also budget overruns._
  > Send reliable alert notifications
  > 
  > *It is important that alert owners get reliably notified of alerts, which could use many communication channels such as text messages, emails or push notifications to a mobile app.*
* Is alerting integrated with an IT Service Management (ITSM) system?

  > ITSM systems, such as ServiceNow, can help to document issues, notify and assign responsible parties, and track issues. For example,  operational alerts from the application could for be integrated to automatically create new tickets to track resolution.
* Have Azure Service Health alerts been created to respond to Service-level events?

  _Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories._
  > [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview) Alerts should be configured to operationalize Service Health events. However, Service Health alerts should not be used to detect issues due to associated latencies; there is a 5 minute Service Level Objectives (SLOs) for automated issues, but many issues require manual interpretation to define an RCA (Root Cause Analysis). Instead, they should be used to provide extremely useful information to help interpret issues that have already been detected and surfaced via the health model, to inform how best to operationally respond.
  
    Additional resources:
    - [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview)
* Have Azure Resource Health alerts been created to respond to Resource-level events?

  _Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources._
  > Azure Resource Health Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform-initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered.
* Are Azure notifications sent to subscriptions owners received and if necessary, properly routed to relevant technical stakeholders?

  _Subscription notification emails can contain important service notifications or security alerts._
  > Make sure that subscription notification emails are routed to the relevant technical stakeholders
  
    Additional resources:
    - [Azure account contact information](https://docs.microsoft.com/azure/cost-management-billing/manage/change-azure-account-profile#service-and-marketing-emails)
## Capacity &amp; Service Availability Planning
    
### Scalability &amp; Capacity Model
            
* Is there a capacity model for the application?

  _A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out._
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where N describes the capacity required to satisfy performance and availability requirements. This also prevents cost-related surprises when scaling out and realizing that multiple services need to be scaled at the same time.
  
    Additional resources:
    - [Performance Efficiency - Capacity](https://docs.microsoft.com/azure/architecture/framework/scalability/capacity)
* Is auto-scaling enabled for supporting PaaS and IaaS services?

  _Are built-in capabilities for automatic scale being used vs. scaling being always a manual decision?_
  > Leveraging built-in Auto-scaling capabilities can help to maintain system reliability in times of increased demand while not needing to overprovision resources up-front, by letting a service automatically scale within a pre-configured range of resources. It greatly simplifies management and operational burdens. However, it must take into account the capacity model, else automated scaling of one component can impact downstream services if those are not also automatically scaled accordingly.
* Is the process to provision and deprovision capacity codified?

  _Codifying and automating the process helps to avoid human error, varying results and to speed up the overall process._
  > Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations. While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or de-provisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood.
* Is the impact of changes in application health on capacity fully understood?

  _For example, if an outage in an external API is mitigated by writing messages into a retry queue, this queue will get sudden spikes in load which it will need to be able to handle._
  > Any change in the health state of application components can influence the capacity demands on other components. Those impacts need to be fully understood and measures such as auto-scaling need to be in place to handle those.
* Is the required capacity (initial and future growth) within Azure service scale limits and quotas?

  _Due to physical and logical resource constraints within the platform, Azure must apply [limits and quotas](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits) to service scalability, which may be either hard or soft._
  > The application should take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a 'spill and fill' model.
    - Is the required capacity (initial and future growth) available within targeted regions?

      _While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand._
      > If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region.
  
      Additional resources:
        - [Azure Capacity (internal)](https://aka.ms/AzureCapacity)
  
    Additional resources:
    - [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits)
* Is capacity utilization monitored and used to forecast future growth?

  _Predicting future growth and capacity demands can prevent outages due to insufficient provisioned capacity over time._
  > Especially when demand is fluctuating, it is useful to monitor historical capacity utilization to derive predictions about future growth. Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status.
  
    Additional resources:
    - [Supported metrics with Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/platform/metrics-supported)
### Service Availability
            
* Is the required capacity (initial and future growth) available within targeted regions?

  _While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region._
  
## Application Performance Management
    
### Data Size/Growth
            
* Do you know the growth rate of your data?

  _Your solution might work great in the first week or month, but what happens when data just keeps increasing? Will the solution slow down, or will it even break at a particular threshold? Planning for data growth, data retention, and archiving is essential in capacity planning. Without adequately planning capacity for your datastores, performance will be negatively affected._
* Are target data sizes and associated growth rates calculated per scenario or service?

  _Scale limits and recovery options should be assessed in the context of target data sizes and growth rates to ensure suitable capacity exists._
* Are there any mitigation plans defined in case data size exceeds limits?

  _Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits._
  > Make sure that data size and growth is monitored, proper alerts are configured and develop (automated and codified, if possible) mitigation plans to help the application to remain available - or to recover if needed
### Data Latency and Throughput
            
* Are latency targets defined, tested, and validated for key scenarios?

  _Latency targets, which are commonly defined as first byte in to last byte out, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health._
* Are throughput targets defined, tested, and validated for key scenarios?

  _Throughput targets, which are commonly defined in terms of IOPS, MB/s and Block Size, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health. Available throughput typically varies based on SKU, so defined targets should be used to inform the use of appropriate SKUs._
### Elasticity
            
* Is autoscaling enabled and integrated within Azure Monitor?

  _Autoscaling can be leveraged to address unanticipated peak loads to help prevent application outages caused by overloading._
    - Has autoscaling been tested under sustained load?

      _The scaling on any single component may have an impact on downstream application components and dependencies. Autoscaling should therefore be tested regularly to help inform and validate a capacity model describing when and how application components should scale._
## Operational Procedures
    
### Recovery &amp; Failover
            
* Are recovery steps defined for failover and failback?

  _Is there a clearly defined playbook or disaster recovery plan for failover and failback procedures?_
  > The steps required to recover or fail over the application to a secondary Azure region in failure situations should be codified, preferably in an automated manner, to ensure capabilities exist to effectively respond to an outage in a way that limits impact. Similar codified steps should also exist to capture the process required to failback the application to the primary region once a failover triggering issue has been addressed.
    - Has the failover and failback approach been tested/validated at least once?

      _Only plans and playbooks that have been executed successfully at least once can be considered working._
      > The precise steps required to failover and failback the application must be tested to validate the effectiveness of the defined disaster recovery approach. Testing of the disaster recovery strategy should occur according to a reasonably regular cadence, such as annually, to ensure that operational application changes do not impact the applicability of the selected approach.
    - How is a failover decided and initiated?

      _Regional failovers are significant operational activities and may incur some downtime, degraded functionality, or data loss depending on the recovery strategy used. The failover process should be fully automated and tested, or at least the process should be clearly documented._
      > Document and understand the failover process
      > 
      > *The failover process itself and also the decision process as to what constitutes a failover should be clearly understood.*
    - Is the health model being used to classify failover situations?

      _It is important to know if a formal procedure is used to classify failover situations._
      > A platform service outage in a specific region will likely require a failover to another region, whereas the accidental change of a firewall rule can be mitigated by a recovery process. The health model and all underlying data should be used to interpret which operational procedures should be triggered.
    - Does the playbook or disaster recovery plan consider every process, component and every category of data that can&#39;t afford unlimited loss or downtime?

      _Different components of an application might have different priorities and impact and therefore different priorities in case of a disaster._
      > When a disaster that affects multiple application components occurs, it's critical that the recovery plan can be used to take a complete inventory of what needs attention and how to prioritize each item. Each major process or workload that's implemented by an app should have separate RPO and RTO values. Each one should be generated through a separate analysis that examines disaster scenario risks and potential recovery strategies for each respective process.
    - Can individual processes and components of the application failover independently?

      _For example, is it possible to failover the compute cluster to a secondary region while keeping the database running in the primary region?_
      > Ideally failover can happen on a component-level instead of needing to failover the entire system together, when, for instance, only one service experiences an outage
* Are automated recovery procedures in place for common failure event?

  _Is there at least some automation for certain failure scenarios or are all those depending on manual intervention?_
  > Automated responses to specific events help to reduce response times and limit errors associated with manual processes. Thus, wherever possible, it is recommended to have automation in place instead of relying on manual intervention.
    - Are these automated recovery procedures tested and validated on a regular basis?

      > Automated operational responses should be tested frequently as part of the normal application lifecycle to ensure operational effectiveness
* Are critical manual processes defined and documented for manual failure responses?

  _While full automation is attainable, there might be cases where manual steps cannot be avoided._
  > Operational runbooks should be defined to codify the procedures and relevant information needed for operations staff to respond to failures and maintain operational health
    - Are these manual operational runbooks tested and validated on a regular basis?

      > Manual operational runbooks should be tested frequently as part of the normal application lifecycle to ensure appropriateness and efficiency
### Configuration &amp; Secrets Management
            
* Where is application configuration information stored and how does the application access it?

  _Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault._
  > Consider storing application configuration in a dedicated management system like Azure App Configuration or Azure Key Vault
  > 
  > *Storing application configuration outside of the application code makes it possible to update it separately and have tighter access control.*
* Can configuration settings be changed or modified without rebuilding or redeploying the application?

  > Application code and configuration should not share the same lifecycle to enable operational activities that change and update specific configurations without developer involvement or redeployment
* How are passwords and other secrets managed?

  _API keys, database connection strings and passwords are all sensitive to leakage, occasionally require rotation and are prone to expiration. Storing them in a secure store and not within the application code or configuration simplifies operational tasks like key rotation as well as improving overall security._
  > Store keys and secrets outside of application code in Azure Key Vault
  > 
  > *Tools like Azure Key Vault or [HashiCorp Vault](https://www.vaultproject.io/) should be used to store and manage secrets securely rather than being baked into the application artefact during deployment, as this simplifies operational tasks like key rotation as well as improving overall security. Keys and secrets stored in source code should be identified with static code scanning tools. Ensure that these scans are an integrated part of the continuous integration (CI) process.*
  
    Additional resources:
    - [HashiCorp Vault](https://www.vaultproject.io/)
* Do you have procedures in place for secret rotation?

  _In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Key rotation reduces the attack vectors and should be automated and executed without any human interactions._
  > Establish a process for key management and automatic key rotation
  > 
  > *Secrets (keys, certificates etc.) should be replaced once they have reached the end of their active lifetime or once they have been compromised. Renewed certificates should also use a new key. A process needs to be in place for situations where keys get compromised (leaked) and need to be regenerated on-demand. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with [rotation processes](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual).*
  
    Additional resources:
    - [Secret rotation process tutorial](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual)
* Does the application use Managed Identities?

  _[Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) in Azure can be used to securely access Azure services while removing the need to store the secrets or certificates of Service Principals._
  > Use Managed Identities for authentication to other Azure platform services
  > 
  > *Wherever possible Azure Managed Identities (either system-managed or user-managed) should be used since they remove the management burden of storing and rotating keys for service principles. Thus, they provide higher security as well as easier maintenance.*
  
    Additional resources:
    - [Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)
* Are keys and secrets backed-up to geo-redundant storage?

  _Keys and secrets must still be available in a failover case._
  > Keys and secrets should be backed up to geo-redundant storage so that they can be accessed in the event of a regional failure and support recovery objectives. In the event of a regional outage, the Key Vault service will automatically be failed over to the secondary region in a read-only state.
    - Are certificate/key backups and data backups stored in different geo-redundant storage accounts?

      > Encryption keys and data should be backed up separately to optimize the security of underlying data
  
    Additional resources:
    - [Azure Key Vault availability and reliability](https://docs.microsoft.com/azure/key-vault/general/disaster-recovery-guidance)
* Is Soft-Delete enabled for Key Vaults and Key Vault objects?

  _The [Soft-Delete feature](https://docs.microsoft.com/azure/key-vault/general/overview-soft-delete) retains resources for a given retention period after a DELETE operation has been performed, while giving the appearance that the object is deleted. It helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted._
  > Enable Key Vault Soft-Delete
  
    Additional resources:
    - [Azure Key Vault Soft-Delete](https://docs.microsoft.com/azure/key-vault/general/overview-soft-delete)
* Are the expiry dates of SSL/TLS certificates monitored and are processes in place to renew them?

  _Expired SSL/TLS certificates are one of the most common yet avoidable causes of application outages; even Azure and more recently Microsoft Teams have experienced outages due to expired certificates._
  > Implement lifecycle management process for SSL/TLS certificates
  > 
  > *Tracking expiry dates of SSL/TLS certificates and renewing them in due time is therefore highly critical. Ideally the process should be automated, although this often depends on leveraged CA. If not automated, sufficient alerting should be applied to ensure expiry dates do not go unnoticed.*
  
    Additional resources:
    - [Configure certificate auto-rotation in Key Vault](https://docs.microsoft.com/azure/key-vault/certificates/tutorial-rotate-certificates)
### Operational Lifecycles
            
* How are operational shortcomings and failures analyzed?

  > Reviewing operational incidents where the response and remediation to issues either failed or could have been optimized is vital to improving overall operational effectiveness. Failures provide a valuable learning opportunity and in some cases these learnings can also be shared across the entire organization.
* Are operational procedures reviewed and refined frequently?

  > Operational procedures should be updated based on outcomes from frequent testing
### Patch &amp; Update Process (PNU)
            
* Is the Patch & Update Process (PNU) process defined and for all relevant application components?

  _The PNU process will vary based on the type of Azure service used (i.e. Virtual Machines, Virtual Machine Scale Sets, Containers on Azure Kubernetes Service). Applications using IaaS will typically require more investment to define a PNU process_
  > The PNU process should be fully defined and understood for all relevant application components
    - Is the Patch &amp; Update Process (PNU) process automated?

      > Ideally the PNU process should be fully or partially automated to optimize response times for new updates and also to reduce the risks associated with manual intervention
    - Are Patch &amp; Update Process (PNU) operations performed &#39;as-code&#39;?

      > Performing operations should be defined 'as-code' since it helps to minimize human error and increase consistency
* How are patches rolled back?

  > It is recommended to have a defined strategy in place to rollback patches in case of an error or unexpected side effects
* Are emergency patches handled differently than normal updates?

  _Emergency patches might contain critical security updates that cannot wait till the next maintenance or release window._
* What is the strategy to keep up with changing dependencies?

  > Changing dependencies, such as new versions of packages, updated Docker images, should be factored into operational processes; the application team should be subscribed to release notes of dependent services, tools, and libraries
## Deployment &amp; Testing
    
### Application Code Deployments
            
* What is the process to deploy application releases to production?

  > The entire end-to-end CI/CD deployment process should be understood
    - How long does it take to deploy an entire production environment?

      _The time it takes to perform a complete environment deployment should align with recovery targets. Automation and agility also lead to cost savings due to the reduction of manual labor and errors._
      > The time it takes to perform a complete environment deployment should be fully understood as it needs to align with the recovery targets
* How often are changes deployed to production?

  _Are numerous releases deployed each day or do releases have a fixed cadence, such as every quarter?_
* Can the application be deployed automatically from scratch without any manual operations?

  _Manual deployment steps introduce significant risks where human error is concerned and also increases overall deployment times._
  > Automated end-to-end deployments, with manual approval gates where necessary, should be used to ensure a consistent and efficient deployment process
    - Is there a documented process for any portions of the deployment that require manual intervention?

      _Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application._
      > Any manual steps that are required in the deployment pipeline must be clearly documented with roles and responsibilities well defined
  
    Additional resources:
    - [Deployment considerations for DevOps](https://docs.microsoft.com/azure/architecture/framework/devops/deployment)
* How long does it take to deploy an entire production environment?

  _The time it takes for a full deployment needs to align with recovery targets._
  > The entire end-to-end deployment process should be understood and align with recovery targets
* Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?

  _N-1 and N+1 refer to roll-back and roll-forward. Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle._
  > Implement automated deployment process with rollback/roll-forward capabilities
* Is there a defined hotfix process which bypasses normal deployment procedures?

  > In some scenarios there is an operational need to rapidly deploy changes, such as critical security updates. Having a defined process for how such changes can be safely and effectively performed helps greatly to prevent 'heat of the moment' issues.
* Does the application deployment process leverage blue-green deployments and/or canary releases?

  _Blue/green or canary deployments are a way to gradually release new feature or changes without impacting all users at once._
  > Blue-green deployments and/or canary releases can be used to deploy updates in a controlled manner that helps to minimize disruption from unanticipated deployment issues. For example, Azure uses canary regions to test and validate new services and capabilities before they are more broadly rolled out to other Azure regions. Where appropriate the application can also use canary environments to validate changes before wider production rollout. Moreover, certain large application platforms may also derive benefit from leveraging Azure canary regions as a basis for validating the potential impact of Azure platform changes on the application.
  
    Additional resources:
    - [Stage your workloads](https://docs.microsoft.com/azure/architecture/framework/devops/deployment#stage-your-workloads)
* How does the development team manage application source code, builds, and releases?

  _It is important to understand whether there is a systematic approach to the development and release process._
  > The use of source code control systems, such as [Azure Repos](https://azure.microsoft.com/services/devops/) or GitHub, and build and release systems, such as Azure Pipelines or GitHub Actions, should be understood, including the corresponding processes to access, review and approve changes
    - If Git is used for source control, what branching strategy is used?

      _While there are various valid ways, a clearly defined strategy should be in place and understood_
      > To optimize for collaboration and ensure developers spend less time managing version control and more time developing code, a clear and simple branching strategy should be used, such as Trunk-Based Development which is employed internally [within Microsoft Engineering](https://docs.microsoft.com/azure/devops/learn/devops-at-microsoft/use-git-microsoft)
  
    Additional resources:
    - [Azure DevOps](https://azure.microsoft.com/services/devops/)
### Application Infrastructure Provisioning
            
* Is application infrastructure defined as code?

  _[Infrastructure as Code](https://docs.microsoft.com/azure/devops/learn/what-is-infrastructure-as-code) (IaC) is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) in a descriptive model, using the same versioning as the team uses for application source code. Like the principle that the same source code generates the same binary, an IaC model generates the same environment every time it is applied._
  > It is highly recommended to describe the entire infrastructure as code, using either ARM Templates, Terraform, or other tools. This allows for proper versioning and configuration management, encouraging consistency and reproducibility across environments.
    - How does the application track and address configuration drift?

      _Configuration drift occurs when changes are applied outside of IaC processes such as manual changes._
      > Tools like Terraform offer a 'plan' command that helps to identify changes and monitor configuration drift, with Azure as the ultimate source of truth
  
    Additional resources:
    - [What is Infrastructure as Code?](https://docs.microsoft.com/azure/devops/learn/what-is-infrastructure-as-code)
* Is direct write access to the infrastructure possible and are any resources provisioned or configured outside of IaC processes?

  _Are any resources provisioned or operationally configured manually through user tools such as the Azure Portal or via Azure CLI?_
  > It is recommended that even small operational changes and modifications be implemented as-code to track changes and ensure they are fully reproducible and revertible. No infrastructure changes should be done manually outside of IaC.
* Is the process to deploy infrastructure automated?

  _Manual changes via for example the Azure Portal or Azure CLI are difficult to test, document and introduce significant risks where human error is concerned and might also increase the overall deployment and recovery times._
  > It is recommended to define infrastructure deployments and changes as code and to use build and release tools to develop automated pipelines for their deployment
### Build Environments
            
* Do critical test environments have 1:1 parity with the production environment?

  _Do test environment differ from production in more than just smaller SKUs being used, e.g. by sharing components between different environments?_
  > To completely validate the suitability of application changes, all changes should be tested in an environment that is fully reflective of production, to ensure there is no potential impact from environment deltas
* Are mocks/stubs used to test external dependencies in non-production environments?

  _Mocks/stubs can help to test and validate external dependencies, to increase test coverage, when accessing those external dependencies is not possible due to for example IP restrictions._
  > The use of dependent services should be appropriately reflected in test environments
* Are releases to production gated by having it successfully deployed and tested in other environments?

  _Deploying to other environments and verifying changes before going into production can prevent bugs getting in front of end users._
  > It is recommended to have a staged deployment process which requires changes to have been validated in test environments first before they can hit production
* Are feature flags used to test features before rolling them out to everyone?

  > To test new features quickly and without bigger risk, [Feature flags](https://docs.microsoft.com/azure/architecture/framework/devops/development#feature-flags) are a technique to help frequently integrate code into a shared repository, even if incomplete. It allows for deployment decisions to be separated from release decisions
  
    Additional resources:
    - [Feature Flags](https://docs.microsoft.com/azure/architecture/framework/devops/development#feature-flags)
### Testing &amp; Validation
            
* Is the application tested for performance, scalability, and resiliency?

  _**Performance testing** is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behavior for the application.<br />**Load Testing** validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limit.<br />**Stress Testing** is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues._
  > Define a testing strategy
    - How does your team perceive the importance of performance testing?

      _It is critical that your team understands the importance of performance testing. Additionally, the team should be committed to providing the necessary time and resources for adequately executing performance testing proven practices._
    - When do you do test for performance, scalability, and resiliency?

      _Regular testing should be performed as part of each major change and if possible on a regular basis to validate existing thresholds, targets and assumptions, as well as ensuring the validity of the health model, capacity model and operational procedures._
    - Are any tests performed in production?

      _While the majority of testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system._
    - Is the application tested with injected faults?

      _It is a common "chaos monkey" practice to verify the effectiveness of operational procedures using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.) or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully._
  
    Additional resources:
    - [Testing strategies](https://docs.microsoft.com/azure/architecture/checklist/dev-ops#testing)
* Are smoke tests performed during application deployments?

  _[Smoke tests](https://docs.microsoft.com/azure/architecture/framework/devops/testing#smoke-testing) are a lightweight way to perform high-level validation of changes. For instance, performing a ping test immediately after a deployment._
  
    Additional resources:
    - [Smoke Testing](https://docs.microsoft.com/azure/architecture/framework/devops/testing#smoke-testing)
* When is integration testing performed?

  _[Integration tests](https://docs.microsoft.com/azure/architecture/framework/devops/testing#integration-testing) should be applied as part of the application deployment process, to ensure that different application components  interact with each other as they should. Integration tests typically take longer than smoke testing, and as a consequence occur at a latter stage of the deployment process so they are executed less frequently._
  
    Additional resources:
    - [Integration Testing](https://docs.microsoft.com/azure/architecture/framework/devops/testing#integration-testing)
* Is unit testing performed to validate application functionality?

  _[Unit tests](https://docs.microsoft.com/azure/architecture/framework/devops/testing#unit-testing) are typically run by each new version of code committed into version control. Unit Tests should be extensive and quick to verify things like syntax correctness of application code, Resource Manager templates or Terraform configurations, that the code is following best practices, or that they produce the expected results when provided certain inputs._
  
    Additional resources:
    - [Unit Testing](https://docs.microsoft.com/azure/architecture/framework/devops/testing#unit-testing)
* Are these tests automated and carried out periodically or on-demand?

  _Testing should be fully automated where possible and performed as part of the deployment lifecycle to validate the impact of all application changes. Additionally, manual explorative testing may also be conducted._
* Are tests and test data regularly validated and updated to reflect necessary changes?

  _Tests and test data should be evaluated and updated after each major application change, update, or outage._
* What happens when a test fails?

  _Failed tests should temporarily block a deployment and lead to a deeper analysis of what has happened and to either a refinement of the test or an improvement of the change that caused the test to fail._
* Do you perform Business Continuity 'fire drills' to test regional failover scenarios?

  _Business Continuity 'fire drills' help to ensure operational readiness and validate the accuracy of recovery procedures ready for critical incidents._
* What degree of security testing is performed?

  _Security and penetration testing, such as scanning for open ports or known vulnerabilities and exposed credentials, is vital to ensure overall security and also support operational effectiveness of the system._
## Operational Model &amp; DevOps
    
### General
            
* Are specific methodologies, like DevOps, used to structure the development and operations process?

  _The contraction of “Dev” and “Ops” refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. [Essential DevOps practices](https://docs.microsoft.com/azure/devops/learn/what-is-devops) include agile planning, continuous integration, continuous delivery, and monitoring of applications._
  
    Additional resources:
    - [What is DevOps?](https://docs.microsoft.com/azure/devops/learn/what-is-devops)
* Is the current development and operations process connected to a Service Management framework like ISO or ITIL?

  _[ITIL](https://en.wikipedia.org/wiki/ITIL) is a set of detailed [IT service management (ITSM)](https://en.wikipedia.org/wiki/IT_service_management) practices that can complement DevOps by providing support for products and services built and deployed using DevOps practices._
  
    Additional resources:
    - [ITIL](https://en.wikipedia.org/wiki/ITIL)
  
    - [IT service management (ITSM)](https://en.wikipedia.org/wiki/IT_service_management)
### Roles &amp; Responsibilities
            
* Has the application been built and maintained in-house or by an external partner?

  _Exploring where technical delivery capabilities reside helps to qualify operational model boundaries and estimate the cost of operating the application as well as defining a budget and cost model._
  > Explore where technical delivery capabilities reside
* Is there a separation between development and operations?

  _A true DevOps model positions the responsibility of operations with developers, but many customers do not fully embrace DevOps and maintain some degree of team separation between operations and development, either to enforce clear segregation of duties for regulated environments, or to share operations as a business function._
    - Does the development team own production deployments?

      _It is important to understand if developers are responsible for production deployments end-to-end, or if a handover point exists where responsibility is passed to an alternative operations team, potentially to ensure a strict segregation of duties such as Sarbanes-Oxley Act where developers cannot touch financial reporting systems._
    - How do development and operations teams collaborate to resolve production issues?

      _It is important to understand how operations and development teams collaborate to address operational issues, and what processes exist to support and structure this collaboration. Moreover, mitigating issues might require the involvement of different teams outside of development or operations, such as networking, and in some cases external parties as well. The processes to support this collaboration should also be understood._
    - Is the workload isolated to a single operations team?

      _The goal of [workload isolation](https://docs.microsoft.com/azure/architecture/framework/devops/app-design#workload-isolation) is to associate an application's specific resources to a team, so that the team can independently manage all aspects of those resources._
  
      Additional resources:
        - [Workload isolation](https://docs.microsoft.com/azure/architecture/framework/devops/app-design#workload-isolation)
* Are any broader teams responsible for operational aspects of the application?

  _Different teams such as Central IT, Security, or Networking may be responsible for aspects of the application which are controlled centrally, such as a shared network virtual appliance (NVA)._
* How are development priorities managed for the application?

  _It is important to understand how business features are prioritized relative to engineering fundamentals, especially if operations is a separate function._
* Are manual approval gates or workflows required to release to production?

  _Even with an automated deployment process there might be a requirement for manual approvals to fulfil regulatory compliance, and it is important to understand who owns any gates that do exist._
* Are tools or processes in place to grant access on a just-in-time basis?

  _Minimizing the number of people who have access to secure information or resources reduces the chance of a malicious actor gaining access or an authorized user inadvertently impacting a sensitive resource. For example, Azure AD [Privileged Identity Management](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure) provides time-based and approval-based role activation to mitigate the risks of excessive, unnecessary, or misused access permissions on resources that you care about._
  > Implement just-in-time privileged access management
    - Does anyone have long-standing write-access to production environments?

      _Regular, long-standing write access to production environments by user accounts can pose a security risk and manual intervention is often prone to errors._
      > Limit long-standing write access to production environments only to service principals
  
      Additional resources:
        - [No standing access / Just in Time privileges](https://docs.microsoft.com/azure/architecture/framework/security/design-admins#no-standing-access--just-in-time-privileges)
  
    Additional resources:
    - [No standing access / Just in Time privileges](https://docs.microsoft.com/azure/architecture/framework/security/design-admins#no-standing-access--just-in-time-privileges)
* Does the organization have the appropriate emergency access accounts configured for this workload in case of an emergency?

  _While rare, sometimes extreme circumstances arise where all normal means of administrative access are unavailable and for this reason emergency access accounts (also refered to as 'break glass' accounts) should be available. These accounts are strictly controlled in accordance with best practice guidance, and they are closely monitored for unsanctioned use to ensure they are not compromised or used for nefarious purposes._
  > Configure emergency access accounts
  > 
  > *The impact of no administrative access can be mitigated by creating two or more [emergency access accounts](https://docs.microsoft.com/azure/active-directory/roles/security-emergency-access) in Azure AD.*
  
    Additional resources:
    - [Emergency Access Accounts](https://docs.microsoft.com/azure/active-directory/roles/security-emergency-access)
## Governance
    
### Standards
            
* Are there any regulatory or governance requirements for this workload?

  _Regulatory requirements may mandate that operational data, such as application logs and metrics, remain within a certain geo-political region. This has obvious implications for how the application should be operationalized._
  > Make sure that all regulatory requirements are known and well understood
  > 
  > *Create processes for obtaining attestations and be familiar with the [Microsoft Trust Center](https://www.microsoft.com/trust-center). Regulatory requirements like data sovereignty and others might affect the overall architecture as well as the selection and configuration of specific PaaS and SaaS services.*
  
    Additional resources:
    - [Microsoft Trust Center](https://www.microsoft.com/trust-center)
* Are Azure Tags used to enrich Azure resources with operational metadata?

  _Using tags can help to manage resources and make it easier to find relevant items during operational procedures._
  > Enforce naming conventions and resource tagging for all Azure resources
  > 
  > *[Azure Tags](https://docs.microsoft.com/azure/azure-resource-manager/management/tag-resources) provide the ability to associate critical metadata as a name-value pair, such as billing information (e.g. cost center code), environment information (e.g. environment type), with Azure resources, resource groups, and subscriptions. See [Tagging Strategies](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging) for best practices.*
  
    Additional resources:
    - [Use tags to organize your Azure resources and management hierarchy](https://docs.microsoft.com/azure/azure-resource-manager/management/tag-resources)
  
    - [Tagging Strategies](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging)
* Does the application have a well-defined naming standard for Azure resources?

  _A well-defined naming convention is important for overall operations to be able to easily determine the usage of certain resources and help understand owners and cost centers responsible for the workload. Naming conventions allow the matching of resource costs to particular workloads._
  > Implement a naming convention
  > 
  > *Having a well-defined [naming convention](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging) is important for overall operations, particularly for large application platforms where there are numerous resources.*
  
    Additional resources:
    - [Naming Conventions](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
* Is the choice and desired configuration of Azure services centrally governed or can the developers pick and choose?

  _Many customers govern service configuration through a catalogue of allowed services that developers and application owners must pick from._
* Are tools and processes in place to govern available services, enforce mandatory operational functionality and ensure compliance?

  _Proper standards for naming, tagging, the deployment of specific configurations such as diagnostic logging, and the available set of services and regions is important to drive consistency and ensure compliance. Solutions like [Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview) can help to enforce and assess compliance at-scale._
* Are standards, policies, restrictions and best practices defined as code?

  _Policy-as-Code provides the same benefits as Infrastructure-as-Code in regards to versioning, automation, documentation as well as encouraging consistency and reproducibility. Available solutions in the market are [Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview) or [HashiCorp Sentinel](https://www.hashicorp.com/resources/introduction-sentinel-compliance-policy-as-code/)._
  
    Additional resources:
    - [Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview)
  
    - [HashiCorp Sentinel](https://www.hashicorp.com/resources/introduction-sentinel-compliance-policy-as-code/)