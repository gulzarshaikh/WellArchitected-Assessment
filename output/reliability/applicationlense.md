# Reliability Assessment
# Application Design
    
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
                      
                  
              
# Health Modelling
    
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
            
                  
              