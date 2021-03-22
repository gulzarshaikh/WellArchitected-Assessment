# Application Reliability

# Navigation Menu

- [Design Principles](#design-principles)
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
    - [Design](#Design)
    - [Failure Mode Analysis](#Failure-Mode-Analysis)
    - [Targets &amp; Non Functional Requirements](#Targets--Non-Functional-Requirements)
    - [Dependencies](#Dependencies)
  - [Health Modelling &amp; Monitoring](#Health-Modelling--Monitoring)
    - [Application Level Monitoring](#Application-Level-Monitoring)
    - [Resource and Infrastructure Level Monitoring](#Resource-and-Infrastructure-Level-Monitoring)
    - [Monitoring and Measurement](#Monitoring-and-Measurement)
    - [Dependencies](#Dependencies)
    - [Data Interpretation &amp; Health Modelling](#Data-Interpretation--Health-Modelling)
    - [Alerting](#Alerting)
  - [Capacity &amp; Service Availability Planning](#Capacity--Service-Availability-Planning)
    - [Scalability &amp; Capacity Model](#Scalability--Capacity-Model)
    - [Service Availability](#Service-Availability)
  - [Application Platform Availability](#Application-Platform-Availability)
    - [Service SKU](#Service-SKU)
    - [Compute Availability](#Compute-Availability)
  - [Data Platform Availability](#Data-Platform-Availability)
    - [Service SKU](#Service-SKU)
    - [Consistency](#Consistency)
    - [Replication and Redundancy](#Replication-and-Redundancy)
  - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Connectivity](#Connectivity)
    - [Zone-Aware Services](#Zone-Aware-Services)
  - [Application Performance Management](#Application-Performance-Management)
    - [Data Size/Growth](#Data-SizeGrowth)
    - [Network Throughput and Latency](#Network-Throughput-and-Latency)
    - [Elasticity](#Elasticity)
  - [Security &amp; Compliance](#Security--Compliance)
    - [Control-plane RBAC](#Control-plane-RBAC)
  - [Operational Procedures](#Operational-Procedures)
    - [Recovery &amp; Failover](#Recovery--Failover)
    - [Configuration &amp; Secrets Management](#Configuration--Secrets-Management)
  - [Deployment &amp; Testing](#Deployment--Testing)
    - [Application Code Deployments](#Application-Code-Deployments)
    - [Build Environments](#Build-Environments)
    - [Testing &amp; Validation](#Testing--Validation)
  - [Operational Model &amp; DevOps](#Operational-Model--DevOps)
    - [Roles &amp; Responsibilities](#Roles--Responsibilities)


# Design Principles

The following Design Principles provide context for questions, why a certain aspect is important and how is it applicable to Reliability.

These critical design principles are used as lenses to assess the Reliability of an application deployed on Azure, providing a framework for the application assessment questions that follow.


## Design for Business Requirements


  Reliability is a subjective concept and for an application to be appropriately reliable it must reflect the business requirements surrounding it. For example, a mission-critical application with a 99.999% SLA requires a higher level of reliability that another application with an SLA of 95%. There are obvious financial and opportunity cost implications for introducing greater reliability and high availability, and this trade-off should be carefully considered.



## Design for Failure


  Failure is impossible to avoid in a highly distributed multi-tenant environment like Azure. By anticipating failures, from individual components to entire Azure regions, a solution can be developed in a resilient way to increase reliability.



## Observe Application Health


  Before issues impacting application reliability can be mitigated, they must first be detected. By monitoring the operation of an application relative to a known healthy state it becomes possible to detect or even predict reliability issues, allowing for swift remedial action to be taken.



## Drive Automation


  One of the leading causes of application downtime is human error, whether that be due to the deployment of insufficiently tested software to misconfiguration. To minimize the possibility and impact of human errors, it is vital to strive for automation in all aspects of a cloud solution to improve reliability; automated testing, deployment, and management.



## Design for Self-Healing


  Self Healing describes a system's ability to deal with failures automatically through pre-defined remediation protocols connected to failure modes within the solution. It is an advanced concept that requires a high level of system maturity with monitoring and automation, but should be an aspiration from inception to maximise reliability.



## Design for Scale-out


  Scale-out is a concept that focuses on a system's ability to respond to demand through horizontal growth. This means that as traffic grows, _more_ resource units are added in parallel instead of increasing the size of the existing resources. A systems ability to handle expected and unexpected traffic increases through scale-units is essential to overall reliability and further reduces the impact of a single resource failure.




---



# Application Assessment Checklist
## Application Design
    
### Design
            
* Is the workload deployed across multiple regions?

  _Multiple regions should be used for failover purposes in a disaster state, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active strategies. Additional cost needs to be taken into consideration - mostly from compute, data and networking perspective, but also services like [Azure Site Recovery (ASR)](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview)._
  > Deploy across multiple regions for higher availability.  The ultimate goal is to set up the infrastructure in a way that it's able to automatically react to regional disasters. While active-active configuration would be the north star, not every workload requires two regions running simultaneously at all times, some don't even support it due to technical limitations. Depending on the availability, performance and cost requirements, passive or warm standby can be viable alternatives too.
    - Were regions chosen based on location and proximity to your users or based on resource types that were available?

      _Not only is it important to utilize regions close to your audience, but it is equally important to choose regions that offer the SKUs that will support your future growth. Not all regions share the same parity when it comes to product SKUs._
      > Plan your growth, then choose regions that will support those plans. 
  
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
* Is the application implemented with strategies for resiliency and self-healing?

  _Strategies for resiliency and self-healing include retrying transient failures and failing over to a secondary instance or even another region._
  > Consider implementing strategies and capabilities for resiliency and self-healing needed to achieve workload availability targets. Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults. 
  
    Additional resources:
    - [Designing resilient Azure applications](https://docs.microsoft.com/azure/architecture/framework/resiliency/app-design)
  
    - [Error handling for resilient applications](https://docs.microsoft.com/azure/architecture/framework/resiliency/app-design-error-handling)
* Can the application operate with reduced functionality or degraded performance in the presence of an outage?

  _Avoiding failure is impossible in the public cloud, and as a result applications require resilience to respond to outages and deliver reliability. The application should therefore be designed to operate even when impacted by regional, zonal, service or component failures across critical application scenarios and functionality._
* Is the application designed to use managed services?

  _Platform-as-a-Service (PaaS) services provide native resiliency capabilities to support overall application reliability and native capabilities for scalability, monitoring and disaster recovery._
  > Where possible prefer Platform-as-a-Service (PaaS) offerings to leverage their advanced capabilities and to avoid managing the underlying infrastructure. 
  
    Additional resources:
    - [Use managed services](https://docs.microsoft.com/azure/architecture/guide/design-principles/managed-services)
  
    - [What is PaaS?](https://azure.microsoft.com/overview/what-is-paas/)
* Has the application been designed to scale-out?

  _Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally. Don't forget about scale in as well, as this is important to drive cost down. For example, scale in and out for App Service is done via rules. Often customers write scale out rule and never write scale in rule, this leaves the App Service more expensive._
  > Design your solution with scalability in mind, leverage PaaS capabilities to [scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out) and in by adding additional intances when needed. 
  
    Additional resources:
    - [Design to scale out](https://docs.microsoft.com/azure/architecture/guide/design-principles/scale-out)
* Is the application deployed across multiple Azure subscriptions?

  _Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when analyzing if relevant subscription limits or quotas can be navigated._
* Is an availability strategy defined? i.e. multi-geo, full/partial

  _An availability strategy should capture how the application remains available when in a failure state and should apply across all application components and the application deployment stamp as a whole such as via multi-geo scale-unit deployment approach. There are cost implications as well: More resources need to be provisioned in advance to provide high availability. Active-active setup, while more expensive than single deployment, can balance cost by lowering load on one stamp and reducing the total amount of resources needed._
* Has a Business Continuity Disaster Recovery (BCDR) strategy been defined for the application and/or its key scenarios?

  _A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach. To drive cost down consider splitting application components and data into groups. For example: 1) must protect, 2) nice to protect, 3) ephemeral/can be rebuilt/lost, instead of protecting all data with the same policy._
    - If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?

      _Quotas and limits typically apply at the region level and, therefore, the needed capacity should also be planned for the secondary region._
### Failure Mode Analysis
            
* Has pathwise analysis been conducted to identify key flows within the application?

  _Pathwise analysis can be used to decompose a complex application into key flows to which business impact can be attached. Frequently, these key flows can be used to identify business critical paths within the application to which reliability targets are most applicable._
* Have all fault-points and fault-modes been identified?

  _Fault-points describe the elements within an application architecture which are capable of failing, while fault-modes capture the various ways by which a fault-point may fail. To ensure an application is resilient to end-to-end failures, it is essential that all fault-points and fault-modes are understood and operationalized._
  
    Additional resources:
    - [Failure Mode Analysis for Azure applications](https://docs.microsoft.com/azure/architecture/resiliency/failure-mode-analysis)
* Have all single points of failure been eliminated?

  _A single point of failure describes a specific fault-point which if it where to fail would bring down the entire application. Single points of failure introduce significant risk since any failure of this component will cause an application outage._
  > Make sure that all single points of failure are identified and wherever possible eliminated. Single point of failures that cannot be avoided need special attention during operations and with regards to resiliency. 
  
    Additional resources:
    - [Make all things redundant](https://docs.microsoft.com/azure/architecture/guide/design-principles/redundancy)
* Have all 'singletons' been eliminated?

  _A 'singleton' describes a logical component within an application for which there can only ever be a single instance. It can apply to stateful architectural components or application code constructs. Ultimately, singletons introduce a significant risk by creating single points of failure within the application design._
### Targets &amp; Non Functional Requirements
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?

  _Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational actionality required by the application is going to far greater than if an SLO of 99.9% was the aspiration._
  > Have clearly defined availability targets.  Having clearly defined availability targets is crucial in order to have a goal to work and measure against. This will also determine which services an application can leverage vs. those which do not qualify in terms of the SLA they offer.
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?

      _If the application is depending on external services, their availability targets/commitments should be understood and ideally aligned with application targets._
      > Make sure SLAs/SLOs/SLIs for all leveraged dependencies are understood. 
    - Has a composite Service-Level Agreement (SLA) been calculated for the application and/or key scenarios using Azure SLAs?

      _A [composite SLA](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements) captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets._
      > Make sure the composite SLA of all components and dependencies on the critical paths are understood. 
  
      Additional resources:
        - [Composite SLA](https://docs.microsoft.com/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements)
    - Are availability targets considered while the system is running in disaster recovery mode?

      _The above defined targets might or might not be applied when running in DR mode. This depends from application to application._
      > Consider availability targets for disaster recovery mode.  If targets must also apply in a failure state then an N+1 model should be used to achieve greater availability and resiliency, where N is the capacity needed to deliver required availability. There's also a cost implication, because more resilient infrastructure usually means more expensive. This has to be accepted by business.
    - Are availability targets monitored and measured?

      _Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets._
      > Measure and monitor key availability targets.  Make sure you measure and monitor key targets such as **Mean Time Between Failures (MTBF)** which denotes the average time between failures of a particular component.
  
      Additional resources:
        - [Mean Time Between Failures](https://en.wikipedia.org/wiki/Mean_time_between_failures)
    - What are the consequences if availability targets are not satisfied?

      _Are there any penalties, such as financial charges, associated with failing to meet SLA commitments? Additional measures can be used to prevent penalties, but that also brings additional cost to operate the infrastructure. This has to be factored in and evaluated._
      > Understand the consequences of missing availability targets.  It should be fully understood what are the consequences if availability targets are not satisfied. This will also inform when to initiate a failover case.
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?

  _Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriate<br />**Recovery time objective (RTO)**: The maximum acceptable time the application is unavailable after a disaster incident<br />**Recovery point objective (RPO)**: The maximum duration of data loss that is acceptable during a disaster event_
  > Recovery targets should be defined in accordance to the required RTO and RPO targets for the workloads. 
  
    Additional resources:
    - [Protect and recover in cloud management](https://docs.microsoft.com/azure/cloud-adoption-framework/manage/considerations/protect)
### Dependencies
            
* Are all internal and external dependencies identified and categorized as either weak or strong?

  _Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies captures required components outside the scope of the application, such as another application or third-party service._
  > Categorize dependencies as either weak or strong.  Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence.
    - Do you maintain a complete list of application dependencies?

      _Examples of typical dependencies include platform dependencies outside the remit of the application, such as Azure Active Directory, Express Route, or a central NVA (Network Virtual Appliance), as well as application dependencies such as APIs which may be in-house or externally owned by a third-party. For cost it’s important to  understand the price for these services and how they are being charged, this makes it easier to understanding an all up cost. For more details see cost models._
      > Map application dependencies either as a simple list or a document (usually this is part of a design document or reference architecture). 
    - Is the impact of an outage with each dependency well understood?

      _Strong dependencies play a critical role in application function and availability meaning their absence will have a significant impact, while the absence of weak dependencies may only impact specific features and not affect overall availability. For cost this reflects the cost that is needed to maintain the HA relationship between the service and it’s dependencies. It would explain why certain measures needs to be maintained in order to hold a given SLA._
      > Classify dependencies either as strong or weak. This will help identify which components are essential to the application. 
  
    Additional resources:
    - [Twelve-Factor App: Dependencies](https://12factor.net/dependencies)
* Are SLAs and support agreements in place for all critical dependencies?

  _Service Level Agreement (SLA) represents a commitment around performance and availability of the application. Understanding the SLA of individual components within the system is essential in order to define reliability targets. Knowing the SLA of dependencies will also provide a justifications for additional spend when making the dependencies highly available and with proper support contracts._
  > The operational commitments of all external and internal dependencies should be understood to inform the broader application operations and health model. 
* Are all platform-level dependencies identified and understood?

  _The usage of platform level dependencies such as Azure Active Directory must also be understood to ensure that their availability and recovery targets align with that of the application._
* Can the application operate in the absence of its dependencies?

  _If the application has strong dependencies which it cannot operate in the absence of, then the availability and recovery targets of these dependencies should align with that of the application itself. Effort should be taken to [minimize dependencies](https://docs.microsoft.com/azure/architecture/guide/design-principles/minimize-coordination) to achieve control over application reliability._
  
    Additional resources:
    - [Minimize dependencies](https://docs.microsoft.com/azure/architecture/guide/design-principles/minimize-coordination)
* Is the lifecycle of the application decoupled from its dependencies?

  _If the application lifecycle is closely coupled with that of its dependencies it can limit the operational agility of the application, particularly where new releases are concerned._
## Health Modelling &amp; Monitoring
    
### Application Level Monitoring
            
* Do you have detailed instrumentation in the application code?

  _Instrumentation of your code allows precise detection of underperforming pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code. Application Performance Monitoring (APM) tools, such as Application Insights, should be used to manage the performance and availability of the application, along with aggregating application level logs and events for subsequent interpretation._
### Resource and Infrastructure Level Monitoring
            
* Is resource-level monitoring enforced throughout the application?

  _Resource- or infrastructure-level monitoring refers to the used platform services such as Azure VMs, Express Route or SQL Database. But also covers 3rd-party solutions like an NVA._
  > All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Azure Policy should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service. 
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

  _An error budget describes the maximum amount of time that the application can fail without consequence, and is typically calculated as 1-SLA. For example, if the SLA specifies that the application will function 99.99% of the time before the business has to compensate customers, the error budget is 52 minutes and 35 seconds per year. Error budgets are a device to encourage development teams to minimize real incidents and maximize innovation by taking risks within acceptable limits, given teams are free to ‘spend’ budget appropriately._
* Is there an policy that dictates what will happen when the error budget has been exhausted?

  _If the application error budget has been met or exceeded and the application is operating at or below the defined SLA, a policy may stipulate that all deployments are frozen until they reduce the number of errors to a level that allows deployments to proceed._
### Dependencies
            
* Is the application instrumented to track calls to dependent services?

  _[Dependency tracking](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-dependencies) and measuring the duration/status of dependency calls is vital to measuring overall application health and should be used to inform a health model for the application._
  
    Additional resources:
    - [Dependency tracking](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-dependencies)
### Data Interpretation &amp; Health Modelling
            
* Are application level events automatically correlated with resource level metrics to quantify the current application state?

  _The overall health state can be impacted by both application-level issues as well as resource-level failures. [Telemetry correlation](https://docs.microsoft.com/azure/azure-monitor/app/correlation) should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform-level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues. This can also help to distinguish between transient and non-transient faults._
  
    Additional resources:
    - [Telemetry correlation](https://docs.microsoft.com/azure/azure-monitor/app/correlation)
* Is a health model used to qualify what 'healthy' and 'unhealthy' states represent for the application?

  > Implement a health model.  A holistic application health model should be used to quantify what 'healthy' and 'unhealthy' states represent across all application components. It is highly recommended that a 'traffic light' model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in <= 500ms with AKS node utilization at x% etc. Once established, this health model should inform critical monitoring metrics across system components and operational sub-system composition. It is important to note that the health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state.
    - Are critical system flows used to inform the health model?

      > The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow. 
    - Can the health model distinguish between transient and non-transient faults?

      _Is the health model treating all failures the same?_
      > The health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state. 
    - Can the health model determine if the application is performing at expected performance targets?

      _The health model should have the ability to evaluate application performance as a part of the application's overall health state._
### Alerting
            
* Have Azure Service Health alerts been created to respond to Service-level events?

  _Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories._
  > [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview) Alerts should be configured to operationalize Service Health events. However, Service Health alerts should not be used to detect issues due to associated latencies; there is a 5 minute SLO for automated issues, but many issues require manual interpretation to define an RCA (Root Cause Analysis). Instead, they should be used to provide extremely useful information to help interpret issues that have already been detected and surfaced via the health model, to inform how best to operationally respond. 
  
    Additional resources:
    - [Azure Service Health](https://docs.microsoft.com/azure/service-health/overview)
* Have Azure Resource Health alerts been created to respond to Resource-level events?

  _Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources._
  > Azure Resource Health Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered. 
* Do all alerts require an immediate response from an on-call engineer?

  _Alerts only deliver value if they are actionable and effectively prioritized by on-call engineers through defined operational procedures._
## Capacity &amp; Service Availability Planning
    
### Scalability &amp; Capacity Model
            
* Is there a capacity model for the application?

  _A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out._
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where N describes the capacity required to satisfy performance and availability requirements. This also prevents cost-related surprises when scaling out and realizing that multiple services need to be scaled at the same time. 
  
    Additional resources:
    - [Performance Efficiency - Capacity](https://docs.microsoft.com/azure/architecture/framework/scalability/capacity)
* Is the process to provision and deprovision capacity codified?

  _Codifying and automating the process helps to avoid human error, varying results and to speed up the overall process._
  > Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations. While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or de-provisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood. 
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
            
* Are Azure services available in the required regions?

  _All Azure services and SKUs are not available within every Azure region, so it is important to understand if the selected regions for the application offer all of the required capabilities. Service availability also varies across sovereign clouds, such as China ("Mooncake") or USGov, USNat, and USSec clouds. In situations where capabilities are missing, steps should be taken to ascertain if a roadmap exists to deliver required services._
  
    Additional resources:
    - [Azure Products by Region](https://azure.microsoft.com/global-infrastructure/services/)
* Are Azure Availability Zones available in the required regions?

  _Not all regions support [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) today, so when assessing the suitability of availability strategy in relation to targets it is important to confirm if targeted regions also provide zonal support. All net new Azure regions will conform to the 3 + 0 datacenter design, and where possible existing regions will expand to provide support for [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-region)._
  
    Additional resources:
    - [Regions that support Availability Zones in Azure](https://docs.microsoft.com/azure/availability-zones/az-region)
* Are any preview services/capabilities required in production?

  _If the application has taken a dependency on preview services or SKUs then it is important to ensure that the level of support and committed SLAs are in alignment with expectations and that roadmap plans for preview services to go<br />Generally Available (GA) are understood<br />Private Preview : SLAs do not apply and formal support is not generally provided <br />Public Preview : SLAs do not apply and formal support may be provided on a best-effort basis_
* Are all APIs/SDKs validated against target runtime/languages for required functionality?

  _While there is a desire across Azure to achieve API/SDK uniformity for supported languages and runtimes, the reality is that capability deltas exist. For instance, not all CosmosDB APIs support the use of direct connect mode over TCP to bypass the platform HTTP gateway. It is therefore important to ensure that APIs/SDKs for selected languages and runtimes provide all of the required capabilities_
* Is the required capacity (initial and future growth) available within targeted regions?

  _While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region._
  
## Application Platform Availability
    
### Service SKU
            
* Are all application platform services running in a HA configuration/SKU?

  _Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, [Service Bus Premium SKU](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-premium-messaging) provides predictable latency and throughput to mitigate noisy neighbor scenarios, as well as the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes._
  
    Additional resources:
    - [Azure Service Bus Premium SKU](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-premium-messaging)
### Compute Availability
            
* Is the underlying application platform service Availability Zone aware?

  _Platform services that can leverage Availability Zones are deployed in either a zonal manner within a particular zone, or in a zone-redundant configuration across multiple zones._
  
    Additional resources:
    - [Building solutions for high availability using Availability Zones](https://docs.microsoft.com/azure/architecture/high-availability/building-solutions-for-high-availability)
* Is the application hosted across 2 or more application platform nodes?

  _To ensure application platform reliability, it is vital that the application be hosted across at least two nodes to ensure there are no single points of failure. Ideally An n+1 model should be applied for compute availability where n is the number of instances required to support application availability and performance requirements. It is important to note that the higher [SLAs provided for virtual machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/) and associated related platform services, require at least two replica nodes deployed to either an Availability Set or across two or more [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones)._
    - Does the application platform use Availability Zones or Availability Sets?

      _An **Availability Set (AS)** is a logical construct to inform Azure that it should distribute contained virtual machine instances across multiple fault and update domains within an Azure region. **Availability Zones (AZ)** elevate the fault level for virtual machines to a physical datacenter by allowing replica instances to be deployed across multiple datacenters within an Azure region. While zones provide greater resiliency than sets, there are performance and cost considerations where applications are extremely 'chatty' across zones given the implied physical separation and inter-zone bandwidth charges. Ultimately, Azure Virtual Machines and Azure PaaS services, such as Service Fabric and Azure Kubernetes Service (AKS) which use virtual machines underneath, can leverage either AZs or an AS to provide application resiliency within a region._
  
      Additional resources:
        - [Business continuity with data resiliency](https://azurecomcdn.azureedge.net/cvt-27012b3bd03d67c9fa81a9e2f53f7d081c94f3a68c13cdeb7958edf43b7771e8/mediahandler/files/resourcefiles/azure-resiliency-infographic/Azure_resiliency_infographic.pdf)
  
    Additional resources:
    - [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/)
* How is the client traffic routed to the application in the case of region, zone or network outage?

  _In the event of a major outage, client traffic should be routable to application deployments which remain available across other regions or zones. This is ultimately where cross-premises connectivity and global load balancing should be used, depending on whether the application is internal and/or external facing. Services such as [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview), [Azure Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview), or third-party CDNs can route traffic across regions based on application health solicited via health probes._
  
    Additional resources:
    - [Traffic Manager endpoint monitoring](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-monitoring)
## Data Platform Availability
    
### Service SKU
            
* Are all data and storage services running in a HA configuration/SKU?

  _Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, [Azure SQL Database Business Critical SKUs](https://docs.microsoft.com/azure/azure-sql/database/service-tier-business-critical), or [Azure Storage Zone Redundant Storage (ZRS)](https://docs.microsoft.com/azure/storage/common/storage-redundancy) with three synchronous replicas spread across Availability Zones._
  
    Additional resources:
    - [Business Critical tier - Azure SQL Database and Azure SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/database/service-tier-business-critical)
  
    - [Azure Storage redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy)
### Consistency
            
* How does CAP theorem apply to the data platform and key application scenarios?

  _[CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem) proves that it is impossible for a distributed data store to simultaneously provide more than two guarantees across 1) Consistency (every read receives the most recent write or an error), 2) Availability (very request receives a non-error response, without the guarantee that it contains the most recent write), and 3) Partition tolerance (a system continues to operate despite an arbitrary number of transactions being dropped or delayed by the network between nodes). Determining which of these guarantees are most important in the context of application requirements is critical._
  
    Additional resources:
    - [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem)
* Are data types categorized by data consistency requirements?

  _Data consistency requirements, such as strong or eventual consistency, should be understood for all data types and used to inform data grouping and categorization, as well as what data replication/synchronization strategies can be considered to meet application reliability targets._
### Replication and Redundancy
            
* Is data replicated across paired regions and/or Availability Zones

  _Replicating data across zones or paired regions supports application availability objectives to limit the impact of failure scenarios._
  
    Additional resources:
    - [Azure Storage redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy)
* Has a data restore process been defined and tested to ensure a consistent application state?

  _Regular testing of the data restore process promotes operational excellence and confidence in the ability to recover data in alignment with defined recovery objectives for the application._
* How is application traffic routed to data sources in the case of region, zone, or network outage?

  _Understanding the method used to route application traffic to data sources in the event of a major failure event is critical to identify whether failover processes will meet recovery objectives. Many Azure data platform services offer native reliability capabilities to handle major failures, such as Cosmos DB Automatic Failover or Azure SQL DB Active Geo-Replication. However, it is important to note that some capabilities such as Azure Storage RA-GRS and Azure SQL DB Active Geo-Replication require application-side failover to alternate endpoints in some failure scenarios, so application logic should be developed to handle these scenarios._
## Networking &amp; Connectivity
    
### Connectivity
            
* Is a global load balancer used to distribute traffic and/or failover across regions?

  _Azure Front Door, Azure Traffic Manager, or third-party CDN (Content Delivery Network) services can be used to direct inbound requests to external-facing application endpoints deployed across multiple regions. It is important to note that Traffic Manager is a DNS based load balancer, so failover must wait for DNS propagation to occur. A sufficiently low TTL (Time To Live) value should be used for DNS records, though not all ISPs (Internet Service Providers) may honor this. For application scenarios which only need HTTP(S) support and are requiring transparent failover, Azure Front Door should be used._
  
    Additional resources:
    - [Disaster Recovery using Azure Traffic Manager](https://docs.microsoft.com/azure/networking/disaster-recovery-dns-traffic-manager)
  
    - [Azure Frontdoor routing architecture](https://docs.microsoft.com/azure/frontdoor/front-door-routing-architecture)
* For cross-premises connectivity (ExpressRoute or VPN) are there redundant connections from different locations?

  _At least two redundant connections should be established across two or more Azure regions and peering locations to ensure there are no single points of failure. An active/active load-shared configuration provides path diversity and promotes availability of network connection paths._
  
    Additional resources:
    - [Cross-network connectivity](https://docs.microsoft.com/azure/expressroute/cross-network-connectivity)
* Has a failure path been simulated to ensure connectivity is available over alternative paths?

  _The failure of a connection path onto other connection paths should be tested to validate connectivity and operational effectiveness. Using [Site-to-Site VPN connectivity as a backup path for ExpressRoute](https://docs.microsoft.com/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering) provides an additional layer of network resiliency for cross-premises connectivity._
  
    Additional resources:
    - [Using site-to-site VPN as a backup for ExpressRoute private peering](https://docs.microsoft.com/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering)
* Have all single points of failure been eliminated from the data path (on-premises and Azure)?

  _Single-instance Network Virtual Appliances (NVAs), whether deployed in Azure or within an on-premises datacenter, introduce significant connectivity risk and should be deployed [highly available](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/nva-ha)._
  
    Additional resources:
    - [Deploy highly available network virtual appliances](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/nva-ha)
* Do health probes assess critical application dependencies?

  _Custom health probes should be used to assess overall application health including downstream components and dependent services, such as APIs and datastores, so that traffic is not sent to backend instances that cannot successfully process requests due to dependency failures._
  
    Additional resources:
    - [Health Endpoint Monitoring Pattern](https://docs.microsoft.com/azure/architecture/patterns/health-endpoint-monitoring)
### Zone-Aware Services
            
* Are zone-redundant ExpressRoute/VPN Gateways used?

  _[Zone-redundant virtual network gateways](https://docs.microsoft.com/azure/vpn-gateway/about-zone-redundant-vnet-gateways) distribute gateway instances across [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region._
  
    Additional resources:
    - [Zone-redundant Virtual Network Gateways](https://docs.microsoft.com/azure/vpn-gateway/about-zone-redundant-vnet-gateways)
  
    - [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones)
* If used, is Azure Application Gateway v2 deployed in a zone-redundant configuration?

  _Azure Application Gateway v2 can be deployed in a [zone-redundant configuration](https://docs.microsoft.com/azure/application-gateway/application-gateway-autoscaling-zone-redundant) to deploy gateway instances across zones for improved reliability and availability during failure scenarios impacting a datacenter within a region._
  
    Additional resources:
    - [Zone-redundant Application Gateway v2](https://docs.microsoft.com/azure/application-gateway/application-gateway-autoscaling-zone-redundant)
* Is Azure Load Balancer Standard being used to load-balance traffic across Availability Zones?

  _Azure Load Balancer Standard is zone-aware to distribute traffic across [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) and [can also be configured in a zone-redundant configuration](https://docs.microsoft.com/azure/load-balancer/load-balancer-standard-availability-zones) to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region._
  
    Additional resources:
    - [Standard Load Balancer and Availability Zones](https://docs.microsoft.com/azure/load-balancer/load-balancer-standard-availability-zones)
* Are health probes configured for Azure Load Balancer(s)/Azure Application Gateway(s)?

  _[Health probes](https://docs.microsoft.com/azure/load-balancer/load-balancer-custom-probe-overview) allow Azure Load Balancers to assess the health of backend endpoints to prevent traffic from being sent to unhealthy instances._
  
    Additional resources:
    - [Load Balancer health probes](https://docs.microsoft.com/azure/load-balancer/load-balancer-custom-probe-overview)
## Application Performance Management
    
### Data Size/Growth
            
* Do you know the growth rate of your data?

  _Your solution might work great in the first week or month, but what happens when data just keeps increasing? Will the solution slow down, or will it even break at a particular threshold? Planning for data growth, data retention, and archiving is essential in capacity planning. Without adequately planning capacity for your datastores, performance will be negatively affected._
* Are there any mitigation plans defined in case data size exceeds limits?

  _Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits._
  > Make sure that data size and growth is monitored, proper alerts are configured and develop (automated and codified, if possible) mitigation plans to help the application to remain available - or to recover if needed. 
### Network Throughput and Latency
            
* Does the application require long running TCP connections?

  _If an application is initiating many outbound TCP or UDP connections it may exhaust all available ports leading to [SNAT port exhaustion](https://docs.microsoft.com/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust) and poor application performance. Long-running connections exacerbate this risk by occupying ports for sustained durations. Effort should be taken to ensure that the application can scale within the port limits of the chosen application hosting platform._
  
    Additional resources:
    - [Managing SNAT port exhaustion](https://docs.microsoft.com/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust)
* Are there any components/scenarios that are very sensitive to network latency?

  _Components or scenarios that are sensitive to network latency may indicate a need for co-locality within a single Availability Zone or even closer using [Proximity Placement Groups](https://docs.microsoft.com/azure/virtual-machines/windows/co-location#proximity-placement-groups) with Accelerated Networking enabled._
  
    Additional resources:
    - [Proximity Placement Groups](https://docs.microsoft.com/azure/virtual-machines/windows/co-location#proximity-placement-groups)
* Have gateways (ExpressRoute or VPN) been sized accordingly to the expected cross-premises network throughput?

  _Azure Virtual Network Gateways throughput varies based on SKU._
  > Consider sizing gateways according to required throughput based on the available [VPN Gateway SKUs](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku). 
  
    Additional resources:
    - [VPN Gateway SKUs](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku)
* Does the application require dedicated bandwidth?

  _Applications with stringent throughput requirements may require dedicated bandwidth to remove the risks associated with noisy neighbor scenarios._
* If NVAs are used, has expected throughput been tested?

  _Maximum potential throughput for third-party NVA (Network Virtual Appliance) solutions is based on a combination of the leveraged VM SKU size, support for Accelerated Networking, support for HA (Highly Available) ports, and more generally the NVA technology used. Expected throughput should be tested to ensure optimal performance, however, it is best to confirm throughput requirements with the NVA vendor directly._
    - Is autoscaling enabled based on throughput

      _Autoscaling capabilities can vary between NVA solutions, but ultimately help to mitigate common bottle-neck situations._
### Elasticity
            
* Can the application scale horizontally in response to changing load?

  _A scale-unit approach should be taken to ensure that each application component and the application as a whole can scale effectively in response to changing demand. A robust capacity model should be used to define when and how the application should scale._
* Has the time to scale in/out been measured?

  _Time to scale-in and scale-out can vary between Azure services and instance sizes and should be assessed to determine if a certain amount of pre-scaling is required to handle scale requirements and expected traffic patterns, such as seasonal load variations._
## Security &amp; Compliance
    
### Control-plane RBAC
            
* Is the identity provider and associated dependencies highly available?

  _It is important to confirm that the identity provider (e.g. Azure AD, AD, or ADFS) and its dependencies (e.g. DNS and network connectivity to the identity provider) are designed in a way and provide an SLA/SLO that aligns with application availability targets._
* Has role-based and/or resource-based authorization been configured within Azure AD?

  _[Role-based and resource-based authorization](https://docs.microsoft.com/azure/architecture/multitenant-identity/authorize) are common approaches to authorize users based on required permission scopes._
    - Does the application write-back to Azure AD?

      _The Azure AD SLA includes authentication, read, write, and administrative actions.  In many cases, applications only require authentication and read access to Azure AD, which aligns with a much higher operational availability due to geographically distributed read replicas._
  
      Additional resources:
        - [Azure AD Architecture](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-architecture)
    - Are authentication tokens cached and encrypted for sharing across web servers?

      _Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability._
  
      Additional resources:
        - [Acquire and cache tokens](https://docs.microsoft.com/azure/active-directory/develop/msal-acquire-cache-tokens)
  
    Additional resources:
    - [Role-based and resource-based authorization](https://docs.microsoft.com/azure/architecture/multitenant-identity/authorize)
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
      > Document and understand the failover process  The failover process itself and also the decision process as to what constitutes a failover should be clearly understood.
    - Is the health model being used to classify failover situations?

      _It is important to know if a formal procedure is used to classify failover situations._
      > A platform service outage in a specific region will likely require a failover to another region, whereas the accidental change of an firewall rule can be mitigated by a recovery process. The health model and all underlying data should be used to interpret which operational procedures should be triggered. 
    - Does the playbook or disaster recovery plan consider every process, component and every category of data that can&#39;t afford unlimited loss or downtime?

      _Different components of an application might have different priorities and impact and therefore different priorities in case of a disaster._
      > When a disaster that affects multiple application components occurs, it's critical that the recovery plan can be used to take a complete inventory of what needs attention and how to prioritize each item. Each major process or workload that's implemented by an app should have separate RPO and RTO values. Each one should be generated through a separate analysis that examines disaster scenario risks and potential recovery strategies for each respective process. 
    - Can individual processes and components of the application failover independently?

      _For example, is it possible to failover the compute cluster to a secondary region while keeping the database running in the primary region?_
      > Ideally failover can happen on a component-level instead of needing to failover the entire system together, when, for instance, only one service experiences an outage. 
* Are automated recovery procedures in place for common failure event?

  _Is there at least some automation for certain failure scenarios or are all those depending on manual intervention?_
  > Automated responses to specific events help to reduce response times and limit errors associated with manual processes. Thus, wherever possible, it is recommended to have automation in place instead of relying on manual intervention. 
    - Are these automated recovery procedures tested and validated on a regular basis?

      > Automated operational responses should be tested frequently as part of the normal application lifecycle to ensure operational effectiveness 
* Are critical manual processes defined and documented for manual failure responses?

  _While full automation is attainable, there might be cases where manual steps cannot be avoided._
  > Operational runbooks should be defined to codify the procedures and relevant information needed for operations staff to respond to failures and maintain operational health. 
    - Are these manual operational runbooks tested and validated on a regular basis?

      > Manual operational runbooks should be tested frequently as part of the normal application lifecycle to ensure appropriateness and efficiency. 
### Configuration &amp; Secrets Management
            
* Where is application configuration information stored and how does the application access it?

  _Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault._
  > Preferably configuration information is stored using a dedicated configuration management system like Azure App Configuration or Azure Key Vault so that it can be updated independently of the application code. 
* Do you have procedures in place for secret rotation?

  _In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Key rotation reduces the attack vectors and should be automated and executed without any human interactions._
  > Secrets (keys, certificates etc.) should be replaced once they have reached the end of their active lifetime or once they have been compromised. Renewed certificates should also use a new key. A process needs to be in place for situations where keys get compromised (leaked) and need to be regenerated on-demand. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with [rotation processes](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual). 
  
    Additional resources:
    - [Secret rotation process tutorial](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual)
* Are keys and secrets backed-up to geo-redundant storage?

  _Keys and secrets must still be available in a failover case._
  > Keys and secrets should be backed up to geo-redundant storage so that they can be accessed in the event of a regional failure and support recovery objectives. In the event of a regional outage, the Key Vault service will automatically be failed over to the secondary region in a read-only state. 
    - Are certificate/key backups and data backups stored in different geo-redundant storage accounts?

      > Encryption keys and data should be backed up separately to optimise the security of underlying data. 
  
    Additional resources:
    - [Azure Key Vault availability and reliability](https://docs.microsoft.com/azure/key-vault/general/disaster-recovery-guidance)
* Is Soft-Delete enabled for Key Vaults and Key Vault objects?

  _The [Soft-Delete feature](https://docs.microsoft.com/azure/key-vault/general/overview-soft-delete) retains resources for a given retention period after a DELETE operation has been performed, while giving the appearance that the object is deleted. It helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted._
  > It is highly recommended to enable Key Vault Soft-Delete. 
  
    Additional resources:
    - [Azure Key Vault Soft-Delete](https://docs.microsoft.com/azure/key-vault/general/overview-soft-delete)
* Is the application stateless or stateful? If it is stateful, is the state externalized in a data store?

  _[Stateless services](https://docs.microsoft.com/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices) and processes can easily be hosted across multiple compute instances to meet scale demands, as well as helping to reduce complexity and ensure high cacheability._
  > Use externalized data store for stateful applications. 
  
    Additional resources:
    - [Stateless web services](https://docs.microsoft.com/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices)
* Is the session state (if any) non-sticky and externalized to a data store?

  _Sticky session state limits application scalability because it is not possible to balance load. With sticky sessions all requests from a client must be sent to the same compute instance where the session state was initially created, regardless of the load on that compute instance. Externalizing session state allows for traffic to be evenly distributed across multiple compute nodes, with required state retrieved from the external data store._
  
    Additional resources:
    - [Avoid session state](https://docs.microsoft.com/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices#sessionstate)
## Deployment &amp; Testing
    
### Application Code Deployments
            
* Can the application be deployed automatically from scratch without any manual operations?

  _Manual deployment steps introduce significant risks where human error is concerned and also increases overall deployment times._
  > Automated end-to-end deployments, with manual approval gates where necessary, should be used to ensure a consistent and efficient deployment process. 
    - Is there a documented process for any portions of the deployment that require manual intervention?

      _Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application._
      > Any manual steps that are required in the deployment pipeline must be clearly documented with roles and responsibilities well defined. 
  
    Additional resources:
    - [Deployment considerations for DevOps](https://docs.microsoft.com/azure/architecture/framework/devops/deployment)
* How long does it take to deploy an entire production environment?

  _The time it takes for a full deployment needs to align with recovery targets._
  > The entire end-to-end deployment process should be understood and align with recovery targets. 
* Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?

  _N-1 and N+1 refer to roll-back and roll-forward. Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle._
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle. 
* Does the application deployment process leverage blue-green deployments and/or canary releases?

  _Blue/green or canary deployments are a way to gradually release new feature or changes without impacting all users at once._
  > Blue-green deployments and/or canary releases can be used to deploy updates in a controlled manner that helps to minimize disruption from unanticipated deployment issues. For example, Azure uses canary regions to test and validate new services and capabilities before they are more broadly rolled out to other Azure regions. Where appropriate the application can also use canary environments to validate changes before wider production rollout. Moreover, certain large application platforms may also derive benefit from leveraging Azure canary regions as a basis for validating the potential impact of Azure platform changes on the application. 
  
    Additional resources:
    - [Stage your workloads](https://docs.microsoft.com/azure/architecture/framework/devops/deployment#stage-your-workloads)
### Build Environments
            
* Do critical test environments have 1:1 parity with the production environment?

  _Do test environment differ from production in more than just smaller SKUs being used, e.g. by sharing components between different environments?_
  > To completely validate the suitability of application changes, all changes should be tested in an environment that is fully reflective of production, to ensure there is no potential impact from environment deltas. 
### Testing &amp; Validation
            
* Is the application tested for performance, scalability, and resiliency?

  _**Performance testing** is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behavior for the application.<br />**Load Testing** validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limit.<br />**Stress Testing** is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues._
  > Define a testing strategy. 
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
* Are these tests automated and carried out periodically or on-demand?

  _Testing should be fully automated where possible and performed as part of the deployment lifecycle to validate the impact of all application changes. Additionally, manual explorative testing may also be conducted._
## Operational Model &amp; DevOps
    
### Roles &amp; Responsibilities
            
* Does the organization have the appropriate emergency access accounts configured for this workload in case of an emergency?

  _While rare, sometimes extreme circumstances arise where all normal means of administrative access are unavailable and for this reason emergency access accounts (also refered to as 'break glass' accounts) should be available. These accounts are strictly controlled in accordance with best practice guidance, and they are closely monitored for unsanctioned use to ensure they are not compromised or used for nefarious purposes._
  > Configure emergency access accounts. The impact of no administrative access can be mitigated by creating two or more [emergency access accounts](https://docs.microsoft.com/azure/active-directory/roles/security-emergency-access) in Azure AD. 
  
    Additional resources:
    - [Emergency Access Accounts](https://docs.microsoft.com/azure/active-directory/roles/security-emergency-access)
