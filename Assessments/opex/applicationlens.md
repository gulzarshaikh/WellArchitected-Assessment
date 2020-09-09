# Operational Excellence Assessment
# Application Design
    
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
            
                  
* Are all internal and external dependencies identified and categorized as either weak or strong?
  > Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies captures required components outside the scope of the application, such as another application or third-party service. Such dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence([Twelve-Factor App: Dependencies](https://12factor.net/dependencies))
            
                  
* Are all platform level dependencies identified and understood?
  > The usage of platform level dependencies such as Azure Active Directory must also be understood to ensure that their availability and recovery targets align with that of the application
            
                  
* Can the application operate in the absence of its dependencies?
  > If the application has strong dependencies which it cannot operate in the absence of, then the availability and recovery targets of these dependencies should align with that of the application itself. Effort should be taken to minimize dependencies to achieve control over application reliability([Minimize dependencies](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/minimize-coordination))
            
                  
* Is the lifecycle of the application decoupled from its dependencies?
  > If the application lifecycle is closely coupled with that of its dependencies it can limit the operational agility of the application, particularly where new releases are concerned
            
                  
              
## Design
            
* Is the application deployed across multiple Azure regions and/or utilizing Availability Zones?
  > Understanding the global operational footprint, for failover or performance purposes, is critical to evaluating overall operations. Generally speaking, multiple Azure regions should be used for disaster recovery procedures, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active recovery strategies([Failover strategies](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/backup-and-recovery)).   [Availability Zones](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones) are a high-availability offering that protects your applications and data from datacenter failures. Using zone-redundant or zonal (pinned to a specific AZ) deployments can increase resiliency of an application
            
    - Is the application deployed in either active-active, active-passive, or isolated configurations across leveraged regions?
    > The regional deployment strategy will partly shape operational boundaries, particularly where operational procedures for recovery and scale are concerned
                      
                  
* Are there any regulatory requirements around data sovereignty?
  > Regulatory requirements may mandate that operational data, such as application logs and metrics, remain within a certain geo-political region. This has obvious implications for how the application should be operationalized
            
                  
* Does the application have components on-premises or in another cloud platform?
  > Hybrid and cross-cloud workloads with components on-premises or on different cloud platforms, such as AWS or GCP, introduce additional operational considerations around achieving a &#39;single pane of glass&#39; for operations
            
                  
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
            
                  
* Does the application support multi-region deployments?
  > Multiple regions should be used for failover purposes in a disaster state, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active strategies([Failover strategies](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones))
            
                  
* Within a region is the application architecture designed to use Availability Zones?
  > Availability Zones can be used to optimise application availability within a region by providing datacenter level fault tolerance. However, the application architecture must not share dependencies between zones to use them effectively. It is also important to note that Availability Zones may introduce performance and cost considerations for applications which are extremely &#39;chatty&#39; across zones given the implied physical separation between each zone and inter-zone bandwidth charges([Availability Zones](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones))
            
                  
* Is component proximity required for application performance reasons?
  > If all or part of the application is highly sensitive to latency it may mandate component co-locality which can limit the applicability of multi-region and multi-zone strategies
            
                  
* Can the application operate with reduced functionality or degraded performance in the presence of an outage?
  > Avoiding failure is impossible in the public cloud, and as a result applications require resilience to respond to outages and deliver reliability. The application should therefore be designed to operate even when impacted by regional, zonal, service or component failures across critical application scenarios and functionality
            
                  
* Is the application designed to use managed services?
  > Azure managed services provide native resiliency capabilities to support overall application reliability, and where possible platform as a service offerings should be used to leverage these capabilities([Use managed services](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/managed-services))
            
                  
* Has the application been designed to scale-out?
  > Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally([Design to scale out](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out))
            
                  
* Is the application deployed across multiple Azure subscriptions?
  > Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when analyzing if relevant subscription limits or quotas can be navigated
            
                  
              
## Failure Mode Analysis
            
* Has pathwise analysis been conducted to identify key flows within the application?
  > Pathwise analysis can be used to decompose a complex application into key flows to which business impact can be attached. Frequently, these key flows can be used to identify business critical paths within the application to which reliability targets are most applicable
            
                  
* Have all fault-points and fault-modes been identified?
  > Fault-points describe the elements within an application architecture which are capable of failing, while fault-modes capture the various ways by which a fault-point may fail. To ensure an application is resilient to end-to-end failures, it is essential that all fault-points and fault-modes are understood and operationalized([Failure Mode Analysis for Azure applications](https://docs.microsoft.com/en-us/azure/architecture/resiliency/failure-mode-analysis))
            
                  
* Have all single points of failure been eliminated?
  > A single point of failure describes a specific fault-point which if it where to fail would bring down the entire application. Single points of failure  introduce significant risk since any failure of this component will cause an application outage([Make all things redundant](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/redundancy))
            
                  
* Have all &#39;singletons&#39; been eliminated?
  > A &#39;singleton&#39; describes a logical component within an application for which there can only ever be a single instance. It can apply to stateful architectural components or application code constructs. Ultimately, singletons introduce a significant risk by creating single points of failure within the application design
            
                  
              
## Key Scenarios
            
* Have critical system flows through the application been defined for all key business scenarios?
  > Path-wise analysis should be used to define critical system flows for key business scenarios, such as the checkout process for an eCommerce application. Understanding critical system flows is vital to assessing overall operational effectiveness, and should be used to inform a health model for the application
            
    - Do these critical system flows have distinct availability, performance, or recovery targets? 
    > Critical sub-systems or paths through the application may have higher expectations around availability, recovery, and performance due to the criticality of associated business scenarios and functionality
                      
                  
* Are there any application components which are less critical and have lower availability or performance requirements?
  > Similarly, some less critical components or paths through the application may have lower expectations around availability, recovery, and performance
            
                  
              
## Targets &amp; Non Functional Requirements
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?
  > Understanding customer availability expectations is vital to reviewing overall operations for the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent operational actionality required by the application is going to far greater than if an SLO of 99.9% was the aspiration
            
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?
    > Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets
                      
    - Are availability targets considered while the system is running in disaster recovery mode?
    > If targets must also apply in a failure state then an n&#43;1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability
                      
    - Are these availability targets monitored and measured?
    > Mean Time Between Failures (MTBF)**: The average time between failures of a particular component
                      
    - What are the consequences if availability targets are not satisfied?
    > Are there any penalties, such as financial charges, associated with failing to meet SLA commitments
                      
                  
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?
  > Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriateRecovery time objective (RTO)**: The maximum acceptable time the application is unavailable after a disaster incidentRecovery point objective (RPO)**: The maximum duration of data loss that is acceptable during a disaster event
            
                  
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
                      
                  
              
# Application Platform Availability
    
## Application State and Configuration
            
* Is the application stateless or stateful? If it is stateful, is the state externalized in a data store?
  > Stateless processes can easily be hosted across multiple compute instances to meet scale demands, as well as helping to reduce complexity and ensure high cacheability([Stateless web services](https://docs.microsoft.com/en-us/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices))
            
                  
* Is the session state (if any) non-sticky and externalized to a data store?
  > Sticky session state limits application scalability because it is not possible to balance load. With sticky sessions all requests from a client must be sent to the same compute instance where the session state was initially created, regardless of the load on that compute instance. Externalizing session state allows for traffic to be evenly distributed across multiple compute nodes, with required state retrieved from the external data store([Avoid session state](https://docs.microsoft.com/en-us/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices#sessionstate))
            
                  
* Is application configuration deployed with the application?
  > Application configuration data should be treated as an artifact deployed alongside the application itself and managed in source control with other application assets to ensure operational effectiveness and flexibility
            
                  
              
## Compute Availability
            
* Is the application platform deployed across multiple regions?
  > The ability to respond to disaster scenarios for overall compute platform availability and application resiliency is dependant on the use of multiple regions or other deployment locations
            
    - Are paired regions used?
    > Paired regions exist within the same geography and provide native replication features for recovery purposes, such as Geo-Redundant Storage (GRS) asynchronous replication. In the event of planned maintenance, updates to a region will be performed sequentially only([Business continuity with Azure Paired Regions](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions))
                      
                  
* Is the underlying application platform service Availability Zone aware?
  > Platform services that can leverage Availability Zones are deployed in either a zonal manner within a particular zone, or in a zone-redundant configuration across multiple zones([Building solutions for high availability using Availability Zones](https://docs.microsoft.com/en-us/azure/architecture/high-availability/building-solutions-for-high-availability))
            
                  
* Is the application hosted across 2 or more application platform nodes?
  > To ensure application platform reliability, it is vital that the application be hosted across at least two nodes to ensure there are no single points of failure. Ideally An n&#43;1 model should be applied for compute availability where n is the number of instances required to support application availability and performance requirements. It is important to note that the higher SLAs provided for virtual machines and associated related platform services, require at least two replica nodes deployed to either an Availability Set or across two or more Availability Zones([SLA for Virtual Machines](https://azure.microsoft.com/en-us/support/legal/sla/virtual-machines/v1_9/))
            
    - Does the application platform use Availability Zones or Availability Sets?
    > An Availability Set (AS) is a logical construct to inform Azure that it should distribute contained virtual machine instances across multiple fault and update domains within an Azure region. Availability Zones (AZ) elevate the fault level for virtual machines to a physical datacenter by allowing replica instances to be deployed across multiple datacenters within an Azure region. While zones provide greater resiliency than sets, there are performance and cost considerations where applications are extremely &#39;chatty&#39; across zones given the implied physical separation and inter-zone bandwidth charges. Ultimately, Azure Virtual Machines and Azure PaaS services, such as Service Fabric and Azure Kubernetes Service (AKS) which use virtual machines underneath, can leverage either AZs or an AS to provide application resiliency within a region([Business continuity with data resiliency](https://azurecomcdn.azureedge.net/cvt-27012b3bd03d67c9fa81a9e2f53f7d081c94f3a68c13cdeb7958edf43b7771e8/mediahandler/files/resourcefiles/azure-resiliency-infographic/Azure_resiliency_infographic.pdf))
                      
                  
* How is the client traffic routed to the application in the case of region, zone or network outage?
  > In the event of a major outage, client traffic should be routable to application deployments which remain available across other regions or zones. This is ultimately where cross-premises connectivity and global load balancing should be used, depending on whether the application is internal and/or external facing. Services such as Azure Front Door, Azure Traffic Manager, or third-party CDNs can route traffic across regions based on application health solicited via health probes([Traffic Manager endpoint monitoring](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-monitoring))
            
                  
              
## Service SKU
            
* Are all application platform services running in a HA configuration/SKU? 
  > Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Service Bus Premium SKU provides predictable latency and throughput to mitigate noisy neighbor scenarios, as well as the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes([Azure Service Bus Premium SKU](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-premium-messaging)
            
                  
* Are all data and storage services running in a HA configuration/SKU?
  > Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Azure SQL Database Business Critical SKUs, or Azure Storage Zone Redundant Storage (ZRS) with three synchronous replicas spread across AZs
            
                  
              
# Capacity &amp; Service Availability
    
## Capacity
            
* Is there a capacity model for the application?
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N&#43;1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements([Performance Efficiency - Capacity](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/capacity))
            
                  
* Is the required capacity (initial and future growth) within Azure service scale limits and quotas?
  > Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should therefore take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a &#39;spill and fill&#39; model([Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits))
            
                  
* Is the required capacity (initial and future growth) available within targeted regions?
  > While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region([Azure Capacity](https://aka.ms/AzureCapacity))
            
                  
* Is capacity utilization monitored and used to forecast future growth?
  > Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status([Supported metrics with Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported))
            
                  
* Is the process to provision and deprovision capacity automated?
  > Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations
            
                  
              
## Service Availability
            
* Are Azure services available in the required regions?
  > All Azure services and SKUs are not available within every Azure region, so it is important to understand if the selected regions for the application offer all of the required capabilities. Service availability also varies across sovereign clouds, such as China (&#34;Mooncake&#34;) or USGov, USNat, and USSec clouds. In situations where capabilities are missing, steps should be taken to ascertain if a roadmap exists to deliver required services([Azure Products by Region](https://azure.microsoft.com/en-us/global-infrastructure/services/)). 
            
                  
* Are Azure Availability Zones available in the required regions?
  > Not all regions support Availability Zones today, so when assessing the suitability of availability strategy in relation to targets it is important to confirm if targeted regions also provide zonal support. All net new Azure regions will conform to the 3 &#43; 0 datacenter design, and where possible existing regions will expand to provide support for Availability Zones([Regions that support Availability Zones in Azure](https://docs.microsoft.com/en-us/azure/availability-zones/az-region))
            
                  
* Are any preview services/capabilities required in production?
  > If the application has taken a dependency on preview services or SKUs then it is important to ensure that the level of support and committed SLAs are in alignment with expectations and that roadmap plans for preview services to go Generally Available (GA) are understoodPrivate Preview** : *SLAs do not apply and formal support is not generally providedPublic Preview** : *SLAs do not apply and formal support may be provided on a best-effort basis
            
                  
* Are all APIs/SDKs validated against target runtime/languages for required functionality?
  > While there is a desire across Azure to achieve API/SDK uniformity for supported languages and runtimes, the reality is that capability deltas exist. For instance, not all CosmosDB APIs support the use of direct connect mode over TCP to bypass the platform HTTP gateway. It is therefore important to ensure that APIs/SDKs for selected languages and runtimes provide all of the required capabilities
            
                  
              
# Data Platform Availability
    
## Consistency
            
* How does CAP theorem apply to the data platform and key application scenarios?
  > CAP theorem proves that it is impossible for a distributed data store to simultaneously provide more than two guarantees across 1) Consistency (every read receives the most recent write or an error), 2) Availability (very request receives a non-error response, without the guarantee that it contains the most recent write), and 3) Partition tolerance (a system continues to operate despite an arbitrary number of transactions being dropped or delayed by the network between nodes). Determining which of these guarantees are most important in the context of application requirements is critical
            
                  
* Are data types categorized by data consistency requirements?
  > Data consistency requirements, such as strong or eventual consistency, should be understood for all data types and used to inform data grouping and categorization, as well as what data replication/synchronization strategies can be considered to meet application reliability targets
            
                  
              
## Replication and Redundancy
            
* Is data replicated across paired regions and/or Availability Zones
  > Replicating data across zones or paired regions supports application availability objectives to limit the impact of failure scenarios
            
                  
* Is data backed-up to zone-redundant or geo-redundant storage?
  > The ability to restore data from a backup is essential when recovering from data corruption situations as well as failure scenarios. To ensure sufficient redundancy and availability for zonal and regional failure scenarios, such backups should be stored across zones and/or regions
            
                  
* Has a data restore process been defined and tested to ensure a consistent application state?
  > Regular testing of the data restore process promotes operational excellence and confidence in the ability to recover data in alignment with defined recovery objectives for the application
            
                  
* How is application traffic routed to data sources in the case of region, zone, or network outage?
  > Understanding the method used to route application traffic to data sources in the event of a major failure event is critical to identify whether failover processes will meet recovery objectives. Many Azure data platform services offer native reliability capabilities to handle major failures, such as Cosmos DB Automatic Failover or Azure SQL DB Active Geo-Replication. However, it is important to note that some capabilities such as Azure Storage RA-GRS and Azure SQL DB Active Geo-Replication require application-side failover to alternate endpoints in some failure scenarios, so application logic should be developed to handle these scenarios
            
                  
              
## Service SKU
            
* Are all application platform services running in a HA configuration/SKU? 
  > Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Service Bus Premium SKU provides predictable latency and throughput to mitigate noisy neighbor scenarios, as well as the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes([Azure Service Bus Premium SKU](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-premium-messaging)
            
                  
* Are all data and storage services running in a HA configuration/SKU?
  > Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Azure SQL Database Business Critical SKUs, or Azure Storage Zone Redundant Storage (ZRS) with three synchronous replicas spread across AZs
            
                  
              
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
  > In some scenarios there is an operational need to rapidly deploy changes, such as critical security updates. Having a defined process for how such changes can be safely and effectively performed helps greatly to prevent &#39;heat of the moment&#39; issues
            
                  
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
  > Performance Testing** : *Performance testing is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behaviour for the application([Performance Testing](https://docs.microsoft.com/en-us/azure/architecture/checklist/dev-ops#testing))Load Testing** : *Load testing validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limitStress Testing** : *Stress testing is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues
            
    - When do you do test for performance, scalability, and resiliency?
    > Regular testing should be performed as part of each major change and if possible on a regular basis to validate existing thresholds, targets and assumptions, as well as ensuring the validity of the health model, capacity model and operational procedures
                      
    - Are any tests performed in production?
    > While the majority of testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system
                      
    - Is the application tested with injected faults?
    > It is a common &#34;chaos monkey&#34; practice to verify the effectiveness of operational procedures using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.) or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
                      
                  
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
  > Business Continuity &#39;fire drills&#39; help to ensure operational readiness and validate the accuracy of recovery procedures ready for critical incidents
            
                  
* What degree of security testing is performed?
  > Security and penetration testing, such as scanning for open ports or known vulnerabilities and exposed credentials, is vital to ensure overall security and also support operational effectiveness of the system
            
                  
* Are specific methodologies, like DevOps, used to structure the development and operations process? 
  > The contraction of “Dev” and “Ops” refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. Essential DevOps practices include agile planning, continuous integration, continuous delivery, and monitoring of applications (from [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-devops)).
            
                  
* Is the current development and operations process connected to a Service Management framework like ISO or ITIL?
  > [ITIL](https://en.wikipedia.org/wiki/ITIL) is a set of detailed [IT service management (ITSM)](https://en.wikipedia.org/wiki/IT_service_management) practices that can complement DevOps by providing support for products and services built and deployed using DevOps practices.
            
                  
              
# Health Modelling
    
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
            
                  
* Have Azure Service Health alerts been created to respond to Service level events?
  > Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories. Alerts should be configured to operationalize Service Health events([Azure Service Health](https://docs.microsoft.com/en-us/azure/service-health/overview))
            
                  
* Have Azure Resource Health alerts been created to respond to Resource level events?
  > Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources. Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered
            
                  
* Do all alerts require an immediate response from an on-call engineer?
  > Alerts only deliver value if they are actionable and effectively prioritized by on-call engineers through defined operational procedures
            
                  
              
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
                      
                  
              
## Dashboarding
            
* What technology in used to visualize the application health model and encompassed logs and metrics?
  > Dashboarding tools, such as Azure Monitor or Grafana, should be used to visualize metrics and events collected at the application and resource levels, to illustrate the health model and the current operational state of the application
            
                  
* Are dashboards tailored to a specific audience? 
  > Dashboards should be customized to represent the precise lens of interest of the end-user. For example, the areas of interest when evaluating the current state will differ greatly between developers, security and networking. Tailored dashboards makes interpretation easier and accelerates time to detection and action
            
                  
* Is Role Based Access Control (RBAC) used to control access to dashboards and underlying data?
  > Access to operational data may be tightly controlled to align with segregation of duties, and careful attention should be made to ensure it doesn&#39;t hinder operational effectiveness; i.e. scenarios where developers have to raise an ITSM ticket to access logs should be avoided
            
                  
              
## Data Interpretation &amp; Health Modelling
            
* Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?
  > To build a robust application health model it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues
            
                  
* Are application level events automatically correlated with resource level metrics to quantify the current application state?
  > The overall health state can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults
            
                  
* Is the transaction flow data used to generate application/service maps?
  > An [Application Map](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.
            
                  
* Is a health model used to qualify what &#39;healthy&#39; and &#39;unhealthy&#39; states represent for the application?
  > A holistic application health model should be used to quantify what &#39;healthy&#39; and &#39;unhealthy&#39; states represent across all application components. It is highly recommended that a &#39;traffic light&#39; model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in &lt;= 500ms with AKS node utilization at x% etc.
            
    - Are critical system flows used to inform the health model?
    > The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow
                      
    - Can the health model distinguish between transient and non-transient faults?
    > The health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state
                      
                  
* Are long-term trends analysed to predict operational issues before they occur?
  > Analytics can and should be performed across long-term operational data to help inform operational strategies and also to predict what operational issues are likely to occur and when. For instance, if the average response times have been slowly increasing over time and getting closer to the maximum target
            
                  
* Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?
  > Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis
            
                  
              
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
            
                  
              
# Networking &amp; Connectivity
    
## Connectivity
            
* Is a global load balancer used to distribute traffic and/or failover across regions? 
  > Azure Front Door, Azure Traffic Manager, or third-party CDN services can be used to direct inbound requests to external-facing application endpoints deployed across multiple regions. It is important to note that Traffic Manager is a DNS based load balancer, so failover must wait for DNS propagation to occur. A sufficiently low TTL (Time To Live) value should be used for DNS records, though not all ISPs may honor this. For application scenarios requiring transparent failover, Azure Front Door should be used([Disaster Recovery using Azure Traffic Manager](https://docs.microsoft.com/en-us/azure/networking/disaster-recovery-dns-traffic-manager))([Azure Frontdoor routing architecture](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-routing-architecture))
            
                  
* For cross-premises connectivity (ExpressRoute or VPN) are there redundant connections from different locations?
  > At least two redundant connections should be established across two or more Azure regions and peering locations to ensure there are no single points of failure. An active/active load-shared configuration provides path diversity and promotes availability of network connection paths([Cross-network connectivity](https://docs.microsoft.com/azure/expressroute/cross-network-connectivity))
            
                  
* Has a failure path been simulated to ensure connectivity is available over alternative paths?
  > The failure of a connection path onto other connection paths should be tested to validate connectivity and operational effectiveness. Using Site-to-Site VPN connectivity as a backup path for ExpressRoute provides an additional layer of network resiliency for cross-premises connectivity([Using site-to-site VPN as a backup for ExpressRoute private peering](https://docs.microsoft.com/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering))
            
                  
* Have all single points of failure been eliminated from the data path (on-premises and Azure)?
  > Single-instance Network Virtual Appliances (NVAs), whether deployed in Azure or within an on-premises datacenter, introduce significant connectivity risk([Deploy highly available network virtual appliances](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/nva-ha)
            
                  
              
## Zone-Aware Services
            
* Are ExpressRoute/VPN zone-redundant Virtual Network Gateways used?
  > Zone-redundant virtual network gateways distribute gateway instances across Availability Zones to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region([Zone-redundant Virtual Network Gateways](https://docs.microsoft.com/en-us/azure/vpn-gateway/about-zone-redundant-vnet-gateways))
            
                  
* If used, is Azure Application Gateway v2 deployed in a zone-redundant configuration?
  > Azure Application Gateway v2 can be deployed in a zone-redundant configuration to deploy gateway instances across zones for improved reliability and availability during failure scenarios impacting a datacenter within a region([Zone-redundant Application Gateway v2](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-autoscaling-zone-redundant))
            
                  
* Is Azure Load Balancer Standard being used to load-balance traffic across Availability Zones?
  > Azure Load Balancer Standard is zone-aware to distribute traffic across Availability Zones and can also be configured in a zone-redundant configuration to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region([Standard Load Balancer and Availability Zones](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-standard-availability-zones))
            
                  
* Are health probes configured for Azure Load Balancer(s)/Azure Application Gateway(s)?
  > Health probes allow Azure Load Balancers to assess the health of backend endpoints to prevent traffic from being sent to unhealthy instances([Load Balancer health probes](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview))
            
                  
* Do health probes assess critical application dependencies?
  > Custom health probes should be used to assess overall application health including downstream components and dependent services, such as APIs and datastores, so that traffic is not sent to backend instances that cannot successfully process requests due to dependency failures([Health Endpoint Monitoring Pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring))
            
                  
              
# Operational Model &amp; DevOps
    
## Common Engineering Criteria 
            
* Is the choice and desired configuration of Azure services centrally governed or can the developers pick and choose?
  > Many customers govern service configuration through a catalogue of allowed services that developers and application owners must pick from
            
                  
* Are tools and processes in place to govern available services, enforce mandatory operational functionality and ensure compliance? 
  > Proper standards for naming, tagging, the deployment of specific configurations such as diagnostic logging, and the available set of services and regions is important to drive consistency and ensure compliance. Solutions like [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) can help to enforce and assess compliance at-scale.
            
                  
              
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
    > The goal of workload isolation is to associate an application&#39;s specific resources to a team, so that the team can independently manage all aspects of those resources([Workload isolation](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/app-design#workload-isolation))
                      
                  
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
                      
                  
              
## Testing &amp; Validation
            
* Is the application tested for performance, scalability, and resiliency?
  > Performance Testing** : *Performance testing is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behaviour for the application([Performance Testing](https://docs.microsoft.com/en-us/azure/architecture/checklist/dev-ops#testing))Load Testing** : *Load testing validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limitStress Testing** : *Stress testing is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues
            
    - When do you do test for performance, scalability, and resiliency?
    > Regular testing should be performed as part of each major change and if possible on a regular basis to validate existing thresholds, targets and assumptions, as well as ensuring the validity of the health model, capacity model and operational procedures
                      
    - Are any tests performed in production?
    > While the majority of testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system
                      
    - Is the application tested with injected faults?
    > It is a common &#34;chaos monkey&#34; practice to verify the effectiveness of operational procedures using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.) or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
                      
                  
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
  > Business Continuity &#39;fire drills&#39; help to ensure operational readiness and validate the accuracy of recovery procedures ready for critical incidents
            
                  
* What degree of security testing is performed?
  > Security and penetration testing, such as scanning for open ports or known vulnerabilities and exposed credentials, is vital to ensure overall security and also support operational effectiveness of the system
            
                  
* Are specific methodologies, like DevOps, used to structure the development and operations process? 
  > The contraction of “Dev” and “Ops” refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. Essential DevOps practices include agile planning, continuous integration, continuous delivery, and monitoring of applications (from [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-devops)).
            
                  
* Is the current development and operations process connected to a Service Management framework like ISO or ITIL?
  > [ITIL](https://en.wikipedia.org/wiki/ITIL) is a set of detailed [IT service management (ITSM)](https://en.wikipedia.org/wiki/IT_service_management) practices that can complement DevOps by providing support for products and services built and deployed using DevOps practices.
            
                  
              
# Operational Procedures
    
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
    > Performing operations &#39;as-code&#39; helps to minimize human error and increase consistency
                      
                  
* How are patches rolled back?
  > It is recommended to have a defined strategy in place to rollback patches in case of an error or unexpected side effects
            
                  
* Are emergency patches handled differently than normal updates?
  > Emergency patches might contain critical security updates that cannot wait till the next maintenance or release window
            
                  
* What is the strategy to keep up with changing dependencies?
  > Changing dependencies, such as new versions of packages, updated Docker images, should be factored into operational processes; the application team should be subscribed to release notes of dependent services, tools, and libraries
            
                  
              
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
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N&#43;1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements([Performance Efficiency - Capacity](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/capacity))
            
                  
* Is auto-scaling enabled for supporting PaaS and IaaS services?
  > Leveraging built-in Auto-scaling capabilities can help to maintain system reliability in times of increased demand while not needing to overprovision resources up-front, by letting a service automatically scale within a pre-configured range of resources. It greatly simplifies management and operational burdens. However, it must take into account the capacity model, else automated scaling of one component can impact downstream services if those are not also automatically scaled accordingly.
            
                  
* Is the process to provision and deprovision capacity codified?
  > While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or deprovisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood.
            
                  
* Is the impact of changes in application health on capacity fully understood?
  > For example, if an outage in an external API is mitigated by writing messages into a retry queue, this queue will get sudden spikes in load which it will need to be able to handle
            
                  
* Is the required capacity (initial and future growth) within Azure service scale limits and quotas?
  > Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should therefore take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a &#39;spill and fill&#39; model([Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits))
            
    - Is the required capacity (initial and future growth) available within targeted regions?
    > While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region([Azure Capacity](https://aka.ms/AzureCapacity))
                      
                  
* Is capacity utilization monitored and used to forecast future growth?
  > Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status([Supported metrics with Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported))
            
                  
              
# Resiliency &amp; Recovery
    
## Approach
            
* Is an availability strategy defined? i.e. multi-geo, full/partial
  > An availability strategy should capture how the application remains available when in a failure state and should apply across all application components and the application deployment stamp as a whole such as via multi-geo scale-unit deployment approach
            
                  
* Has a Business Continuity Disaster Recovery (BCDR) strategy been defined for the application and/or its key scenarios? 
  > A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach
            
                  
              
## Availability Targets
            
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?
  > Understanding customer availability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application SLO of 99.999%, the level of inherent resiliency required by the application is going to far greater than if an SLO of 99.9% was the aspiration
            
    - Are SLAs/SLOs/SLIs for all leveraged dependencies understood?
    > Availability targets for any dependencies leveraged by the application should be understood and ideally align with application targets
                      
    - Has a composite SLA been calculated for the application and/or key scenarios using Azure SLAs?
    > A composite SLA captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets([Composite SLAs](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements))
                      
    - Are availability targets considered while the system is running in disaster recovery mode?
    > If targets must also apply in a failure state then an n&#43;1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability
                      
                  
* Are these availability targets monitored and measured?
  > Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets.Mean Time To Recover (MTTR)**: *The average time it takes to restore a particular component after a failure has occurredMean Time Between Failures (MTBF)**: *The average time between failures of a particular component
            
                  
              
## Recovery Targets
            
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?
  > Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriateRecovery time objective (RTO)**: *The maximum acceptable time the application is unavailable after a disaster incidentRecovery point objective (RPO)**: *The maximum duration of data loss that is acceptable during a disaster event
            
                  
* Are recovery steps defined for failover and failback?
  > The steps required to failover the application to a secondary Azure region in failure situations should be codified, preferably in an automated manner, to ensure capabilities exist to effectively respond to an outage in a way that limits impact. Similar codified steps should also exist to capture the process required to failback the application to the primary region once a failover triggering issue has been addressed
            
                  
* Has the failover and failback approach been tested/validated at least once?
  > The precise steps required to failover and failback the application must be tested to validate the effectiveness of the defined disaster recovery approach. Testing of the disaster recovery strategy should occur according to a reasonably regular cadence, such as annually, to ensure that operational application changes do not impact the applicability of the selected approach
            
                  
              
# Scalability &amp; Performance
    
## App Performance
            
* Does the application logic handle exceptions and errors using resiliency patterns?
  > Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults([Error handling for resilient applications](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/app-design-error-handling))
            
                  
* Does the application require long running TCP connections?
  > If an application is initiating many outbound TCP or UDP connections it may exhaust all available ports leading to SNAT port exhaustion and poor application performance. Long-running connections exacerbate this risk by occupying ports for sustained durations. Effort should be taken to ensure that the application can scale within the port limits of the chosen application hosting platform([Managing SNAT port exhaustion](https://docs.microsoft.com/en-us/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust))    
            
                  
              
## Data Latency and Throughput
            
* Are latency targets defined, tested, and validated for key scenarios? 
  > Latency targets, which are commonly defined as first byte in to last byte out, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health
            
                  
* Are throughput targets defined, tested, and validated for key scenarios?
  > Throughput targets, which are commonly defined in terms of IOPS, MB/s and Block Size, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health. Available throughput typically varies based on SKU, so defined targets should be used to inform the use of appropriate SKUs
            
                  
              
## Data Size/Growth
            
* Are target data sizes and associated growth rates calculated per scenario or service?
  > Scale limits and recovery options should be assessed in the context of target data sizes and growth rates to ensure suitable capacity exists
            
                  
* Are there any mitigation plans defined in case data size exceeds limits?
  > Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits
            
                  
              
## Elasticity
            
* Can the application scale horizontally in response to changing load?
  > A scale-unit approach should be taken to ensure that each application component and the application as a whole can scale effectively in response to changing demand. A robust capacity model should be used to define when and how the application should scale
            
                  
* Has the time to scale in/out been measured?
  > Time to scale-in and scale-out can vary between Azure services and instance sizes and should be assessed to determine if a certain amount of pre-scaling is required to handle scale requirements and expected traffic patterns, such as seasonal load variations
            
                  
* Is autoscaling enabled and integrated within Azure Monitor?
  > Autoscaling can be leveraged to address unanticipated peak loads to help prevent application outages caused by overloading
            
    - Has autoscaling been tested under sustained load?
    > The scaling on any single component may have an impact on downstream application components and dependencies. Autoscaling should therefore be tested regularly to help inform and validate a capacity model describing when and how application components should scale
                      
                  
              
## Network Throughput and Latency
            
* Are there any components/scenarios that are very sensitive to network latency?
  > Components or scenarios that are sensitive to network latency may indicate a need for co-locality within a single Availability Zone or even closer using Proximity Placement Groups with Accelerated Networking enabled([Proximity Placement Groups](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/co-location#proximity-placement-groups))
            
                  
* Have gateways (ExpressRoute or VPN) been sized accordingly to the expected cross-premises network throughput?
  > Azure Virtual Network Gateways throughput varies based on SKU. Gateways should therefore be sized according to required throughput([VPN Gateway SKUs](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku))
            
                  
* Does the application require dedicated bandwidth?
  > Applications with stringent throughput requirements may require dedicated bandwidth to remove the risks associated with noisy neighbor scenarios
            
                  
* If NVAs are used, has expected throughput been tested?
  > Maximum potential throughput for third-party NVA solutions is based on a combination of the leveraged VM SKU size, support for Accelerated Networking, support for HA ports, and more generally the NVA technology used. Expected throughput should be tested to ensure optimal performance, however, it is best to confirm throughput requirements with the NVA vendor directly
            
    - Is autoscaling enabled based on throughput
    > Autoscaling capabilities can vary between NVA solutions, but ultimately help to mitigate common bottle-neck situations
                      
                  
              
# Security &amp; Compliance
    
## Data Protection and Compliance
            
* Has monitoring for continuous compliance been implemented?
  > Azure Policy provides native governance capabilities to monitor and enforce the continuous compliance of underlying application resources
            
                  
              
## Identity and Access
            
* Is the identity provider and associated dependencies highly available?
  > It is important to confirm that the identity provider (e.g. Azure AD, AD, or ADFS) and its dependencies (e.g. DNS and network connectivity to the identity provider) are designed in a way and provide an SLA/SLO that aligns with application availability targets
            
                  
* Has role-based and/or resource-based authorization been configured within Azure AD?
  > Role-based and resource-based authorization are common approaches to authorize users based on required permission scopes([Role-based and resource-based authorization](https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/authorize))
            
    - Does the application write-back to Azure AD?
    > The Azure AD SLA includes authentication, read, write, and administrative actions.  In many cases, applications only require authentication and read access to Azure AD, which aligns with a much higher operational availability due to geographically distributed read replicas([Azure AD Architecture](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-architecture))
                      
    - Are authentication tokens cached and encrypted for sharing across web servers?
    > Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability([Acquire and cache tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-acquire-cache-tokens))
                      
                  
* Are Azure AD emergency access accounts and processes defined for recovering from identity failures?
  > The impact of no administrative access can be mitigated by creating two or more emergency access accounts([Emergency Access accounts in Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-emergency-access))
            
                  
              
## Key Management
            
* Are keys and secrets backed-up to geo-redundant storage?
  > Keys and secrets should be backed up to geo-redundant storage so that they can be accessed in the event of a regional failure and support recovery objectives. In the event of a regional outage, the Key Vault service will automatically be failed over to the secondary region in a read-only state([Azure Key Vault availability and reliability](https://docs.microsoft.com/en-us/azure/key-vault/general/disaster-recovery-guidance))
            
    - Are certificate/key backups and data backups stored in different geo-redundant storage accounts?
    > Encryption keys and data should be backed up separately to optimise the security of underlying data
                      
                  
* Is Soft-Delete enabled for Key Vaults and Key Vault objects?
  > The Soft-Delete feature retains resources for a given retention period after a DELETE operation has been performed, while giving the appearance that the object is deleted. It helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted([Azure Key Vault Soft-Delete](https://docs.microsoft.com/en-us/azure/key-vault/general/overview-soft-delete))
            
                  
* Is the process for key and certificate rotation automated and tested?
  > Key and certificate rotation is often the cause of application outages; even Azure itself has fallen victim to expired certificates in the past. It is therefore critical that the rotation of keys and certificates be scheduled and fully operationalized. The rotation process should be fully automated and tested to ensure effectiveness([Azure Key Vault key rotation and auditing](https://docs.microsoft.com/en-us/azure/key-vault/secrets/key-rotation-log-monitoring))
            
                  
              
## Network Security
            
* Are all external application endpoints secured?
  > External application endpoints should be protected against common attack vectors, such as Denial of Service (DoS) attacks like Slowloris, to prevent potential application downtime due to malicious intent. Azure native technologies such as Azure Firewall, Application Gateway/Azure Front Door WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection([Azure DDoS Protection](https://docs.microsoft.com/en-us/azure/virtual-network/ddos-protection-overview))
            
                  
* Is communication to Azure PaaS services secured using VNet Service Endpoints or Private Link?
  > Service Endpoints and Private Link can be leveraged to restrict access to PaaS endpoints from only authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios)
            
                  
* If data exfiltration concerns exist for services where Private Link is not yet supported, is filtering via Azure Firewall or an NVA being used?
  > NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported([Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/features))
            
                  
* Are Network Security Groups (NSGs) being used?
  > If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked([Azure Platform Considerations for NSGs](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview#azure-platform-considerations))
            
    - Are NSG flow logs being collected?
    > NSG flow logs should be captured and analyzed to monitor performance and security([Why use NSG flow logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview#why-use-flow-logs))
                      
                  
              
# Site Reliability Engineering &amp; DevOps
    
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
            
                  
* Have Azure Service Health alerts been created to respond to Service level events?
  > Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories. Alerts should be configured to operationalize Service Health events([Azure Service Health](https://docs.microsoft.com/en-us/azure/service-health/overview))
            
                  
* Have Azure Resource Health alerts been created to respond to Resource level events?
  > Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources. Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered
            
                  
* Do all alerts require an immediate response from an on-call engineer?
  > Alerts only deliver value if they are actionable and effectively prioritized by on-call engineers through defined operational procedures
            
                  
              
## Deployment Automation
            
* How long does it take to deploy an entire production environment?
  > The entire end-to-end deployment process should be understood and align with recovery targets
            
                  
* Can the application be deployed automatically from scratch without any manual operations?
  > Manual deployment steps introduce significant risks where human error is concerned and also increases overall deployment times. Automated end-to-end deployments, with manual approval gates where necessary, should be used to ensure a consistent and efficient deployment process([Deployment considerations for DevOps](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/deployment))
            
    - Is there a documented process for any portions of the deployment that require manual intervention?
    > Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application
                      
                  
* Can N-1 or N&#43;1 versions be deployed via automated pipelines where N is current deployment version in production?
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle
            
                  
* Does the application deployment process leverage blue-green deployments and/or canary releases?
  > Blue-green deployments and/or canary releases can be used to deploy updates in a controlled manner that helps to minimize disruption from unanticipated deployment issues([Stage your workloads](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/deployment#stage-your-workloads))
            
                  
              
## Monitoring and Measurement
            
* Is there a health model for the application?
  > A holistic health model should be defined for the application to qualify what “healthy” and “unhealthy” states represent across all system components, in a measurable and observable format. A “traffic light” model should be used to indicate a green/healthy state when key non-functional requirements are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in &lt;= 500ms with AKS utilization at x% etc. Once established, this health model should inform critical monitoring metrics across system components and operational sub-system composition. It is important to note that the health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state
            
    - Are key metrics, thresholds and indicators defined and deployed?
    > Critical metrics and indicators should be understood to inform that the application meets performance, availability, and recovery targets
                      
                  
* Is white-box monitoring used to instrument the application with semantic logs and metrics?
  > Application level metrics and logs, such as current memory consumption or request latency, should be collected from the application to inform a health model and detect/predict issues([Instrumenting an application with Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview))
            
                  
* Is the application instrumented to measure the customer experience?
  > Effective instrumentation is vital to detecting and resolving performance anomalies that can impact customer experience and application availability([Monitor performance](https://docs.microsoft.com/en-us/azure/azure-monitor/app/web-monitor-performance))
            
                  
* Is the application instrumented to track calls to dependent services?
  > Dependency tracking and measuring the duration/status of dependency calls is vital to measuring overall application health and should be used to inform a health model for the application([Dependency Tracking](https://docs.microsoft.com/en-us/azure/azure-monitor/app/asp-net-dependencies))
            
                  
* Is black-box monitoring used to measure platform services and the resulting customer experience?
  > Black-box monitoring tests externally visible application behavior without knowledge of the internals of the system. This is a common approach to measuring customer-centric SLIs/SLOs/SLAs([Azure Monitor Reference](https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability))
            
                  
* Are all platform logs for services correlated with application telemetry?
  > Telemetry correlation should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform-level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues([Telemetry correlation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/correlation))
            
                  
* Are there known gaps in application observability that led to missed incidents and/or false positives?
  > What you cannot see, you cannot measure. What you cannot measure, you cannot improve
            
                  
* Are error budgets used to track service reliability?
  > An error budget describes the maximum amount of time that the application can fail without consequence, and is typically calculated as 1-SLA. For example, if the SLA specifies that the application will function 99.99% of the time before the business has to compensate customers, the error budget is 52 minutes and 35 seconds per year. Error budgets are a device to encourage development teams to minimize real incidents and maximize innovation by taking risks within acceptable limits, given teams are free to ‘spend’ budget appropriately
            
                  
* Is there an policy that dictates what will happen when the error budget has been exhausted?
  > If the application error budget has been met or exceeded and the application is operating at or below the defined SLA, a policy may stipulate that all deployments are frozen until they reduce the number of errors to a level that allows deployments to proceed
            
                  
              
## Testing and Validation
            
* Is the application tested for performance, scalability and resiliency?
  > Performance Testing** : *Performance testing is the superset of both load and stress testing. The primary goal of performance testing is to validate benchmark behaviour for the applicationLoad Testing** : *Load testing validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limitStress Testing** : *Stress testing is a type of negative testing which involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues.
            
    - Is the application tested with injected faults?
    > It is a common &#39;chaos monkey&#39; practice to verify application resiliency using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.), or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
                      
                  
* Are these tests automated and carried out periodically or on-demand?
  > Testing should be fully automated where possible and performed as part of the deployment lifecycle to validate the impact of all application changes
            
                  
* Do critical test environments have 1:1 parity with the production environment?
  > To completely validate the suitability of application changes, all changes should be tested in an environment that is fully reflective of production, to ensure there is no potential impact from environment deltas
            
                  
              