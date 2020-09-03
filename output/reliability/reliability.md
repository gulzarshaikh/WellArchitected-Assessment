# Reliability Assessment
# Application Design
    
## Design
        
* Do developers like cold beer?
  > Beer comes in a bottle or a can and is often served in a glass.
            
        
* Does the application support multi-region deployments?
  > Multiple regions should be used for failover purposes in a disaster state, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active strategies    ([Failover strategies](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones))
            
        
* Within a region is the application architecture designed to use Availability Zones?
  > Availability Zones can be used to optimise application availability within a region by providing datacenter level fault tolerance. However, the application architecture must not share dependencies between zones to use them effectively. It is also important to note that Availability Zones may introduce performance and cost considerations for applications which are extremely &#39;chatty&#39; across zones given the implied physical separation between each zone and inter-zone bandwidth charges    ([Availability Zones](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones))
            
        
* Is component proximity required for application performance reasons?
  > If all or part of the application is highly sensitive to latency it may mandate component co-locality which can limit the applicability of multi-region and multi-zone strategies
            
        
* Can the application operate with reduced functionality or degraded performance in the presence of an outage?
  > Avoiding failure is impossible in the public cloud, and as a result applications require resilience to respond to outages and deliver reliability. The application should therefore be designed to operate even when impacted by regional, zonal, service or component failures across critical application scenarios and functionality
            
        
* Is the application designed to use managed services?
  > Azure managed services provide native resiliency capabilities to support overall application reliability, and where possible platform as a service offerings should be used to leverage these capabilities  ([Use managed services](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/managed-services))
            
        
* Has the application been designed to scale-out?
  > Azure provides elastic scalability, however, applications must leverage a scale-unit approach to navigate service and subscription limits to ensure that individual components and the application as a whole can scale horizontally  ([Design to scale out](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out))
            
        
* Is the application deployed across multiple Azure subscriptions?
  > Understanding the subscription landscape of the application and how components are organized within or across subscriptions is important when analyzing if relevant subscription limits or quotas can be navigated
            
        
    
## Failure Mode Analysis
        
* Has pathwise analysis been conducted to identify key flows within the application?
  > Pathwise analysis can be used to decompose a complex application into key flows to which business impact can be attached. Frequently, these key flows can be used to identify business critical paths within the application to which reliability targets are most applicable
            
        
* Have all fault-points and fault-modes been identified?
  > Fault-points describe the elements within an application architecture which are capable of failing, while fault-modes capture the various ways by which a fault-point may fail. To ensure an application is resilient to end-to-end failures, it is essential that all fault-points and fault-modes are understood and operationalized    ([Failure Mode Analysis for Azure applications](https://docs.microsoft.com/en-us/azure/architecture/resiliency/failure-mode-analysis))
            
        
* Have all single points of failure been eliminated?
  > A single point of failure describes a specific fault-point which if it where to fail would bring down the entire application. Single points of failure  introduce significant risk since any failure of this component will cause an application outage    ([Make all things redundant](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/redundancy))
            
        
* Have all &#39;singletons&#39; been eliminated?
  > A &#39;singleton&#39; describes a logical component within an application for which there can only ever be a single instance. It can apply to stateful architectural components or application code constructs. Ultimately, singletons introduce a significant risk by creating single points of failure within the application design
            
        
    
## Dependencies
        
* Are all internal and external dependencies identified and categorized as either weak or strong?
  > Internal dependencies describe components within the application scope which are required for the application to fully operate, while external dependencies captures required components outside the scope of the application, such as another application or third-party service. Such dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence    ([Twelve-Factor App: Dependencies](https://12factor.net/dependencies))
            
        
* Are all platform level dependencies identified and understood?
  > The usage of platform level dependencies such as Azure Active Directory must also be understood to ensure that their availability and recovery targets align with that of the application
            
        
* Can the application operate in the absence of its dependencies?
  > If the application has strong dependencies which it cannot operate in the absence of, then the availability and recovery targets of these dependencies should align with that of the application itself. Effort should be taken to minimize dependencies to achieve control over application reliability    ([Minimize dependencies](https://docs.microsoft.com/en-us/azure/architecture/guide/design-principles/minimize-coordination))
            
        
* Is the lifecycle of the application decoupled from its dependencies?
  > If the application lifecycle is closely coupled with that of its dependencies it can limit the operational agility of the application, particularly where new releases are concerned
            
        
    

# Application Platform Availability
    
## Application State and Configuration
        
* Is the application stateless or stateful? If it is stateful, is the state externalized in a data store?
  > Stateless processes can easily be hosted across multiple compute instances to meet scale demands, as well as helping to reduce complexity and ensure high cacheability    ([Stateless web services](https://docs.microsoft.com/en-us/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices))
            
        
* Is the session state (if any) non-sticky and externalized to a data store?
  > Sticky session state limits application scalability because it is not possible to balance load. With sticky sessions all requests from a client must be sent to the same compute instance where the session state was initially created, regardless of the load on that compute instance. Externalizing session state allows for traffic to be evenly distributed across multiple compute nodes, with required state retrieved from the external data store    ([Avoid session state](https://docs.microsoft.com/en-us/aspnet/aspnet/overview/developing-apps-with-windows-azure/building-real-world-cloud-apps-with-windows-azure/web-development-best-practices#sessionstate))
            
        
* Is application configuration deployed with the application?
  > Application configuration data should be treated as an artifact deployed alongside the application itself and managed in source control with other application assets to ensure operational effectiveness and flexibility
            
        
    
## Service SKU
        
* Are all application platform services running in a HA configuration/SKU? 
  > Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Service Bus Premium SKU provides predictable latency and throughput to mitigate noisy neighbor scenarios, as well as the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes    ([Azure Service Bus Premium SKU](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-premium-messaging)
            
        
* Are all data and storage services running in a HA configuration/SKU?
  > Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Azure SQL Database Business Critical SKUs, or Azure Storage Zone Redundant Storage (ZRS) with three synchronous replicas spread across AZs
            
        
    
## Compute Availability
        
* Is the application platform deployed across multiple regions?
  > Paired regions exist within the same geography and provide native replication features for recovery purposes, such as Geo-Redundant Storage (GRS) asynchronous replication. In the event of planned maintenance, updates to a region will be performed sequentially only       ([Business continuity with Azure Paired Regions](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions))
            
  - Are paired regions used?
    > Paired regions exist within the same geography and provide native replication features for recovery purposes, such as Geo-Redundant Storage (GRS) asynchronous replication. In the event of planned maintenance, updates to a region will be performed sequentially only       ([Business continuity with Azure Paired Regions](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions))
            
        
* Is the underlying application platform service Availability Zone aware?
  > Platform services that can leverage Availability Zones are deployed in either a zonal manner within a particular zone, or in a zone-redundant configuration across multiple zones	([Building solutions for high availability using Availability Zones](https://docs.microsoft.com/en-us/azure/architecture/high-availability/building-solutions-for-high-availability))
            
        
* Is the application hosted across 2 or more application platform nodes?
  > An Availability Set (AS) is a logical construct to inform Azure that it should distribute contained virtual machine instances across multiple fault and update domains within an Azure region. Availability Zones (AZ) elevate the fault level for virtual machines to a physical datacenter by allowing replica instances to be deployed across multiple datacenters within an Azure region. While zones provide greater resiliency than sets, there are performance and cost considerations where applications are extremely &#39;chatty&#39; across zones given the implied physical separation and inter-zone bandwidth charges. Ultimately, Azure Virtual Machines and Azure PaaS services, such as Service Fabric and Azure Kubernetes Service (AKS) which use virtual machines underneath, can leverage either AZs or an AS to provide application resiliency within a region        ([Business continuity with data resiliency](https://azurecomcdn.azureedge.net/cvt-27012b3bd03d67c9fa81a9e2f53f7d081c94f3a68c13cdeb7958edf43b7771e8/mediahandler/files/resourcefiles/azure-resiliency-infographic/Azure_resiliency_infographic.pdf))
            
  - Does the application platform use Availability Zones or Availability Sets?
    > An Availability Set (AS) is a logical construct to inform Azure that it should distribute contained virtual machine instances across multiple fault and update domains within an Azure region. Availability Zones (AZ) elevate the fault level for virtual machines to a physical datacenter by allowing replica instances to be deployed across multiple datacenters within an Azure region. While zones provide greater resiliency than sets, there are performance and cost considerations where applications are extremely &#39;chatty&#39; across zones given the implied physical separation and inter-zone bandwidth charges. Ultimately, Azure Virtual Machines and Azure PaaS services, such as Service Fabric and Azure Kubernetes Service (AKS) which use virtual machines underneath, can leverage either AZs or an AS to provide application resiliency within a region        ([Business continuity with data resiliency](https://azurecomcdn.azureedge.net/cvt-27012b3bd03d67c9fa81a9e2f53f7d081c94f3a68c13cdeb7958edf43b7771e8/mediahandler/files/resourcefiles/azure-resiliency-infographic/Azure_resiliency_infographic.pdf))
            
        
* How is the client traffic routed to the application in the case of region, zone or network outage?
  > In the event of a major outage, client traffic should be routable to application deployments which remain available across other regions or zones. This is ultimately where cross-premises connectivity and global load balancing should be used, depending on whether the application is internal and/or external facing. Services such as Azure Front Door, Azure Traffic Manager, or third-party CDNs can route traffic across regions based on application health solicited via health probes    ([Traffic Manager endpoint monitoring](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-monitoring))
            
        
    

# Capacity &amp; Service Availability
    
## Service Availability
        
* Are Azure services available in the required regions?
  > All Azure services and SKUs are not available within every Azure region, so it is important to understand if the selected regions for the application offer all of the required capabilities. Service availability also varies across sovereign clouds, such as China (&#34;Mooncake&#34;) or USGov, USNat, and USSec clouds. In situations where capabilities are missing, steps should be taken to ascertain if a roadmap exists to deliver required services    ([Azure Products by Region](https://azure.microsoft.com/en-us/global-infrastructure/services/)). 
            
        
* Are Azure Availability Zones available in the required regions?
  > Not all regions support Availability Zones today, so when assessing the suitability of availability strategy in relation to targets it is important to confirm if targeted regions also provide zonal support. All net new Azure regions will conform to the 3 &#43; 0 datacenter design, and where possible existing regions will expand to provide support for Availability Zones    ([Regions that support Availability Zones in Azure](https://docs.microsoft.com/en-us/azure/availability-zones/az-region))
            
        
* Are any preview services/capabilities required in production?
  > If the application has taken a dependency on preview services or SKUs then it is important to ensure that the level of support and committed SLAs are in alignment with expectations and that roadmap plans for preview services to go Generally Available (GA) are understood
            
        
* Are all APIs/SDKs validated against target runtime/languages for required functionality?
  > While there is a desire across Azure to achieve API/SDK uniformity for supported languages and runtimes, the reality is that capability deltas exist. For instance, not all CosmosDB APIs support the use of direct connect mode over TCP to bypass the platform HTTP gateway. It is therefore important to ensure that APIs/SDKs for selected languages and runtimes provide all of the required capabilities
            
        
    
## Capacity
        
* Is there a capacity model for the application?
  > A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N&#43;1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements    ([Performance Efficiency - Capacity](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/capacity))
            
        
* Is the required capacity (initial and future growth) within Azure service scale limits and quotas?
  > Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should therefore take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a &#39;spill and fill&#39; model    ([Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits))
            
        
* Is the required capacity (initial and future growth) available within targeted regions?
  > While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region  ([Azure Capacity](https://aka.ms/AzureCapacity))
            
        
* Is capacity utilization monitored and used to forecast future growth?
  > Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status  ([Supported metrics with Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported))
            
        
* Is the process to provision and deprovision capacity automated?
  > Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations
            
        
    

# Data Platform Availability
    
## Service SKU
        
* Are all application platform services running in a HA configuration/SKU? 
  > Azure application platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Service Bus Premium SKU provides predictable latency and throughput to mitigate noisy neighbor scenarios, as well as the ability to automatically scale and replicate metadata to another Service Bus instance for failover purposes    ([Azure Service Bus Premium SKU](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-premium-messaging)
            
        
* Are all data and storage services running in a HA configuration/SKU?
  > Azure data platform services offer resiliency features to support application reliability, though they may only be applicable at a certain SKU. For instance, Azure SQL Database Business Critical SKUs, or Azure Storage Zone Redundant Storage (ZRS) with three synchronous replicas spread across AZs
            
        
    
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
            
        
    

# Networking &amp; Connectivity
    
## Connectivity
        
* Is a global load balancer used to distribute traffic and/or failover across regions? 
  > Azure Front Door, Azure Traffic Manager, or third-party CDN services can be used to direct inbound requests to external-facing application endpoints deployed across multiple regions. It is important to note that Traffic Manager is a DNS based load balancer, so failover must wait for DNS propagation to occur. A sufficiently low TTL (Time To Live) value should be used for DNS records, though not all ISPs may honor this. For application scenarios requiring transparent failover, Azure Front Door should be used    ([Disaster Recovery using Azure Traffic Manager](https://docs.microsoft.com/en-us/azure/networking/disaster-recovery-dns-traffic-manager))    ([Azure Frontdoor routing architecture](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-routing-architecture))
            
        
* For cross-premises connectivity (ExpressRoute or VPN) are there redundant connections from different locations?
  > At least two redundant connections should be established across two or more Azure regions and peering locations to ensure there are no single points of failure. An active/active load-shared configuration provides path diversity and promotes availability of network connection paths    ([Cross-network connectivity](https://docs.microsoft.com/azure/expressroute/cross-network-connectivity))
            
        
* Has a failure path been simulated to ensure connectivity is available over alternative paths?
  > The failure of a connection path onto other connection paths should be tested to validate connectivity and operational effectiveness. Using Site-to-Site VPN connectivity as a backup path for ExpressRoute provides an additional layer of network resiliency for cross-premises connectivity    ([Using site-to-site VPN as a backup for ExpressRoute private peering](https://docs.microsoft.com/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering))
            
        
* Have all single points of failure been eliminated from the data path (on-premises and Azure)?
  > Single-instance Network Virtual Appliances (NVAs), whether deployed in Azure or within an on-premises datacenter, introduce significant connectivity risk    ([Deploy highly available network virtual appliances](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/nva-ha)
            
        
    
## Zone-Aware Services
        
* Are ExpressRoute/VPN zone-redundant Virtual Network Gateways used?
  > Zone-redundant virtual network gateways distribute gateway instances across Availability Zones to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region    ([Zone-redundant Virtual Network Gateways](https://docs.microsoft.com/en-us/azure/vpn-gateway/about-zone-redundant-vnet-gateways))
            
        
* If used, is Azure Application Gateway v2 deployed in a zone-redundant configuration?
  > Azure Application Gateway v2 can be deployed in a zone-redundant configuration to deploy gateway instances across zones for improved reliability and availability during failure scenarios impacting a datacenter within a region  ([Zone-redundant Application Gateway v2](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-autoscaling-zone-redundant))
            
        
* Is Azure Load Balancer Standard being used to load-balance traffic across Availability Zones?
  > Azure Load Balancer Standard is zone-aware to distribute traffic across Availability Zones and can also be configured in a zone-redundant configuration to improve reliability and ensure availability during failure scenarios impacting a datacenter within a region    ([Standard Load Balancer and Availability Zones](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-standard-availability-zones))
            
        
* Are health probes configured for Azure Load Balancer(s)/Azure Application Gateway(s)?
  > Health probes allow Azure Load Balancers to assess the health of backend endpoints to prevent traffic from being sent to unhealthy instances    ([Load Balancer health probes](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview))
            
        
* Do health probes assess critical application dependencies?
  > Custom health probes should be used to assess overall application health including downstream components and dependent services, such as APIs and datastores, so that traffic is not sent to backend instances that cannot successfully process requests due to dependency failures    ([Health Endpoint Monitoring Pattern](https://docs.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring))
            
        
    

# Resiliency &amp; Recovery
    
## Approach
        
* Is an availability strategy defined? i.e. multi-geo, full/partial
  > An availability strategy should capture how the application remains available when in a failure state and should apply across all application components and the application deployment stamp as a whole such as via multi-geo scale-unit deployment approach
            
        
* Has a Business Continuity Disaster Recovery (BCDR) strategy been defined for the application and/or its key scenarios? 
  > A disaster recovery strategy should capture how the application responds to a disaster situation such as a regional outage or the loss of a critical platform service, using either a re-deployment, warm-spare active-passive, or hot-spare active-active approach
            
        
    
## Availability Targets
        
* Are availability targets such as Service Level Agreements (SLAs), Service Level Indicators (SLIs), and Service Level Objectives (SLOs) defined for the application and/or key scenarios?
  > If targets must also apply in a failure state then an n&#43;1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability
            
  - Has a composite SLA been calculated for the application and/or key scenarios using Azure SLAs?
    > A composite SLA captures the end-to-end SLA across all application components and dependencies. It is calculated using the individual SLAs of Azure services housing application components and provides an important indicator of designed availability in relation to customer expectations and targets        ([Composite SLAs](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/business-metrics#understand-service-level-agreements))
            
  - Are availability targets considered while the system is running in disaster recovery mode?
    > If targets must also apply in a failure state then an n&#43;1 model should be used to achieve greater availability and resiliency, where n is the capacity needed to deliver required availability
            
        
* Are these availability targets monitored and measured?
  > Monitoring and measuring application availability is vital to qualifying overall application health and progress towards defined targets.
            
        
    
## Recovery Targets
        
* Are recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) defined for the application and/or key scenarios?
  > Understanding customer reliability expectations is vital to reviewing the overall reliability of the application. For instance, if a customer is striving to achieve an application RTO of less than a minute then back-up based and active-passive disaster recovery strategies are unlikely to be appropriate
            
        
* Are recovery steps defined for failover and failback?
  > The steps required to failover the application to a secondary Azure region in failure situations should be codified, preferably in an automated manner, to ensure capabilities exist to effectively respond to an outage in a way that limits impact. Similar codified steps should also exist to capture the process required to failback the application to the primary region once a failover triggering issue has been addressed
            
        
* Has the failover and failback approach been tested/validated at least once?
  > The precise steps required to failover and failback the application must be tested to validate the effectiveness of the defined disaster recovery approach. Testing of the disaster recovery strategy should occur according to a reasonably regular cadence, such as annually, to ensure that operational application changes do not impact the applicability of the selected approach
            
        
    

# Scalability &amp; Performance
    
## App Performance
        
* Does the application logic handle exceptions and errors using resiliency patterns?
  > Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults    ([Error handling for resilient applications](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/app-design-error-handling))
            
        
* Does the application require long running TCP connections?
  > If an application is initiating many outbound TCP or UDP connections it may exhaust all available ports leading to SNAT port exhaustion and poor application performance. Long-running connections exacerbate this risk by occupying ports for sustained durations. Effort should be taken to ensure that the application can scale within the port limits of the chosen application hosting platform    ([Managing SNAT port exhaustion](https://docs.microsoft.com/en-us/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust))    
            
        
    
## Data Size/Growth
        
* Are target data sizes and associated growth rates calculated per scenario or service?
  > Scale limits and recovery options should be assessed in the context of target data sizes and growth rates to ensure suitable capacity exists
            
        
* Are there any mitigation plans defined in case data size exceeds limits?
  > Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits
            
        
    
## Data Latency and Throughput
        
* Are latency targets defined, tested, and validated for key scenarios? 
  > Latency targets, which are commonly defined as first byte in to last byte out, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health
            
        
* Are throughput targets defined, tested, and validated for key scenarios?
  > Throughput targets, which are commonly defined in terms of IOPS, MB/s and Block Size, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health. Available throughput typically varies based on SKU, so defined targets should be used to inform the use of appropriate SKUs
            
        
    
## Network Throughput and Latency
        
* Are there any components/scenarios that are very sensitive to network latency?
  > Components or scenarios that are sensitive to network latency may indicate a need for co-locality within a single Availability Zone or even closer using Proximity Placement Groups with Accelerated Networking enabled    ([Proximity Placement Groups](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/co-location#proximity-placement-groups))
            
        
* Have gateways (ExpressRoute or VPN) been sized accordingly to the expected cross-premises network throughput?
  > Azure Virtual Network Gateways throughput varies based on SKU. Gateways should therefore be sized according to required throughput    ([VPN Gateway SKUs](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku))
            
        
* Does the application require dedicated bandwidth?
  > Applications with stringent throughput requirements may require dedicated bandwidth to remove the risks associated with noisy neighbor scenarios
            
        
* If NVAs are used, has expected throughput been tested?
  > Autoscaling capabilities can vary between NVA solutions, but ultimately help to mitigate common bottle-neck situations
            
  - Is autoscaling enabled based on throughput
    > Autoscaling capabilities can vary between NVA solutions, but ultimately help to mitigate common bottle-neck situations
            
        
    
## Elasticity
        
* Can the application scale horizontally in response to changing load?
  > A scale-unit approach should be taken to ensure that each application component and the application as a whole can scale effectively in response to changing demand. A robust capacity model should be used to define when and how the application should scale
            
        
* Has the time to scale in/out been measured?
  > Time to scale-in and scale-out can vary between Azure services and instance sizes and should be assessed to determine if a certain amount of pre-scaling is required to handle scale requirements and expected traffic patterns, such as seasonal load variations
            
        
* Is autoscaling enabled and integrated within Azure Monitor?
  > The scaling on any single component may have an impact on downstream application components and dependencies. Autoscaling should therefore be tested regularly to help inform and validate a capacity model describing when and how application components should scale
            
  - Has autoscaling been tested under sustained load?
    > The scaling on any single component may have an impact on downstream application components and dependencies. Autoscaling should therefore be tested regularly to help inform and validate a capacity model describing when and how application components should scale
            
        
    

# Security &amp; Compliance
    
## Identity and Access
        
* Is the identity provider and associated dependencies highly available?
  > It is important to confirm that the identity provider (e.g. Azure AD, AD, or ADFS) and its dependencies (e.g. DNS and network connectivity to the identity provider) are designed in a way and provide an SLA/SLO that aligns with application availability targets
            
        
* Has role-based and/or resource-based authorization been configured within Azure AD?
  > Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability        ([Acquire and cache tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-acquire-cache-tokens))
            
  - Does the application write-back to Azure AD?
    > The Azure AD SLA includes authentication, read, write, and administrative actions.  In many cases, applications only require authentication and read access to Azure AD, which aligns with a much higher operational availability due to geographically distributed read replicas      ([Azure AD Architecture](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-architecture))
            
  - Are authentication tokens cached and encrypted for sharing across web servers?
    > Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability        ([Acquire and cache tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-acquire-cache-tokens))
            
        
* Are Azure AD emergency access accounts and processes defined for recovering from identity failures?
  > The impact of no administrative access can be mitigated by creating two or more emergency access accounts    ([Emergency Access accounts in Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-emergency-access))
            
        
    
## Network Security
        
* Are all external application endpoints secured?
  > External application endpoints should be protected against common attack vectors, such as Denial of Service (DoS) attacks like Slowloris, to prevent potential application downtime due to malicious intent. Azure native technologies such as Azure Firewall, Application Gateway/Azure Front Door WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection    ([Azure DDoS Protection](https://docs.microsoft.com/en-us/azure/virtual-network/ddos-protection-overview))
            
        
* Is communication to Azure PaaS services secured using VNet Service Endpoints or Private Link?
  > Service Endpoints and Private Link can be leveraged to restrict access to PaaS endpoints from only authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios)
            
        
* If data exfiltration concerns exist for services where Private Link is not yet supported, is filtering via Azure Firewall or an NVA being used?
  > NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported    ([Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/features))
            
        
* Are Network Security Groups (NSGs) being used?
  > If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked    ([Azure Platform Considerations for NSGs](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview#azure-platform-considerations))      ([Why use NSG flow logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview#why-use-flow-logs))
            
  - Are NSG flow logs being collected?
    >       ([Why use NSG flow logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview#why-use-flow-logs))
            
        
    
## Key Management
        
* Are keys and secrets backed-up to geo-redundant storage?
  > Encryption keys and data should be backed up separately to optimise the security of underlying data
            
  - Are certificate/key backups and data backups stored in different geo-redundant storage accounts?
    > Encryption keys and data should be backed up separately to optimise the security of underlying data
            
        
* Is Soft-Delete enabled for Key Vaults and Key Vault objects?
  > The Soft-Delete feature retains resources for a given retention period after a DELETE operation has been performed, while giving the appearance that the object is deleted. It helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted    ([Azure Key Vault Soft-Delete](https://docs.microsoft.com/en-us/azure/key-vault/general/overview-soft-delete))
            
        
* Is the process for key and certificate rotation automated and tested?
  > Key and certificate rotation is often the cause of application outages; even Azure itself has fallen victim to expired certificates in the past. It is therefore critical that the rotation of keys and certificates be scheduled and fully operationalized. The rotation process should be fully automated and tested to ensure effectiveness    ([Azure Key Vault key rotation and auditing](https://docs.microsoft.com/en-us/azure/key-vault/secrets/key-rotation-log-monitoring))
            
        
    
## Data Protection and Compliance
        
* Has monitoring for continuous compliance been implemented?
  > Azure Policy provides native governance capabilities to monitor and enforce the continuous compliance of underlying application resources
            
        
    

# Site Reliability Engineering &amp; DevOps
    
## Deployment Automation
        
* How long does it take to deploy an entire production environment?
  > The entire end-to-end deployment process should be understood and align with recovery targets
            
        
* Can the application be deployed automatically from scratch without any manual operations?
  > Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application
            
  - Is there a documented process for any portions of the deployment that require manual intervention?
    > Without detailed release process documentation, there is a much higher risk of an operator improperly configuring settings for the application
            
        
* Can N-1 or N&#43;1 versions be deployed via automated pipelines where N is current deployment version in production?
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle
            
        
* Does the application deployment process leverage blue-green deployments and/or canary releases?
  > Blue-green deployments and/or canary releases can be used to deploy updates in a controlled manner that helps to minimize disruption from unanticipated deployment issues    ([Stage your workloads](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/deployment#stage-your-workloads))
            
        
    
## Monitoring and Measurement
        
* Is there a health model for the application?
  > Critical metrics and indicators should be understood to inform that the application meets performance, availability, and recovery targets
            
  - Are key metrics, thresholds and indicators defined and deployed?
    > Critical metrics and indicators should be understood to inform that the application meets performance, availability, and recovery targets
            
        
* Is white-box monitoring used to instrument the application with semantic logs and metrics?
  > Application level metrics and logs, such as current memory consumption or request latency, should be collected from the application to inform a health model and detect/predict issues    ([Instrumenting an application with Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview))
            
        
* Is the application instrumented to measure the customer experience?
  > Effective instrumentation is vital to detecting and resolving performance anomalies that can impact customer experience and application availability        ([Monitor performance](https://docs.microsoft.com/en-us/azure/azure-monitor/app/web-monitor-performance))
            
        
* Is the application instrumented to track calls to dependent services?
  > Dependency tracking and measuring the duration/status of dependency calls is vital to measuring overall application health and should be used to inform a health model for the application        ([Dependency Tracking](https://docs.microsoft.com/en-us/azure/azure-monitor/app/asp-net-dependencies))
            
        
* Is black-box monitoring used to measure platform services and the resulting customer experience?
  > Black-box monitoring tests externally visible application behavior without knowledge of the internals of the system. This is a common approach to measuring customer-centric SLIs/SLOs/SLAs    ([Azure Monitor Reference](https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability))
            
        
* Are all platform logs for services correlated with application telemetry?
  > Telemetry correlation should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform-level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues    ([Telemetry correlation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/correlation))
            
        
* Are there known gaps in application observability that led to missed incidents and/or false positives?
  > What you cannot see, you cannot measure. What you cannot measure, you cannot improve
            
        
* Are error budgets used to track service reliability?
  > An error budget describes the maximum amount of time that the application can fail without consequence, and is typically calculated as 1-SLA. For example, if the SLA specifies that the application will function 99.99% of the time before the business has to compensate customers, the error budget is 52 minutes and 35 seconds per year. Error budgets are a device to encourage development teams to minimize real incidents and maximize innovation by taking risks within acceptable limits, given teams are free to ‘spend’ budget appropriately
            
        
* Is there an policy that dictates what will happen when the error budget has been exhausted?
  > If the application error budget has been met or exceeded and the application is operating at or below the defined SLA, a policy may stipulate that all deployments are frozen until they reduce the number of errors to a level that allows deployments to proceed
            
        
    
## Alerting
        
* Have Azure Service Health alerts been created to respond to Service level events?
  > Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories. Alerts should be configured to operationalize Service Health events    ([Azure Service Health](https://docs.microsoft.com/en-us/azure/service-health/overview))
            
        
* Have Azure Resource Health alerts been created to respond to Resource level events?
  > Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources. Alerts should be configured for specific resource groups and resource types, and should be adjusted to maximize signal to noise ratios, i.e. only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is therefore important to consider transient issues when setting an appropriate threshold for resource unavailability, such as configuring an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered
            
        
* Do all alerts require an immediate response from an on-call engineer?
  > Alerts only deliver value if they are actionable and effectively prioritized by on-call engineers through defined operational procedures
            
        
    
## Testing and Validation
        
* Is the application tested for performance, scalability and resiliency?
  > It is a common &#39;chaos monkey&#39; practice to verify application resiliency using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.), or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
            
  - Is the application tested with injected faults?
    > It is a common &#39;chaos monkey&#39; practice to verify application resiliency using artificial faults. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.), or forcing failover (database level, Front Door, etc.) is a good way to validate that the application is able to handle faults gracefully
            
        
* Are these tests automated and carried out periodically or on-demand?
  > Testing should be fully automated where possible and performed as part of the deployment lifecycle to validate the impact of all application changes
            
        
* Do critical test environments have 1:1 parity with the production environment?
  > To completely validate the suitability of application changes, all changes should be tested in an environment that is fully reflective of production, to ensure there is no potential impact from environment deltas
            
        
    

