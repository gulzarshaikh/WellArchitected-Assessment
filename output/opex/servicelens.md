# Service-specific operational guidance

This list contains design considerations and recommended configuration options, specific to individual Azure services.
# Compute
        
## Azure Kubernetes Service (AKS)
### Design Considerations
* For customers subscribing to the Azure Kubernetes Service (AKS) Uptime SLA, Microsoft guarantees 1) 99.95% availability of the Kubernetes API server endpoint for AKS Clusters that use Azure Availability Zones, and 2) 99.9% availability for AKS Clusters that not use Azure Availability Zones. For customers that do not wish to subscribe to the AKS uptime SLA, Microsoft provides a service level objective (SLO) of 99.5%.
* The SLA for agent (worker) nodes within an AKS cluster is covered by the standard [Virtual Machine SLA](#virtual-machines) which is dependent on the chosen deployment configuration and whether an Availability Set or Availability Zones are used.
  > [AKS Service Level Agreements](https://azure.microsoft.com/support/legal/sla/kubernetes-service/v1_1/)[AKS Uptime SLA Offering](https://docs.microsoft.com/en-us/azure/aks/uptime-sla)
                            
### Configuration Recommendations
* For all AKS clusters requiring resiliency, it is highly recommended that:
  - Use [Availability Zones](https://docs.microsoft.com/azure/aks/availability-zones) to maximize resilience within a region by distributing AKS agent nodes across physically separate data centers.
                            
  - Where co-locality requirements exist, an Availability Set deployment can be used to minimize inter-node latency.
                            
* Virtual Machine Scale Set deployment configurations should be used to unlock cluster autoscaling and the use of multiple node pools.
  - Enable cluster [autoscaling](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler) to adjust the number of agent nodes in response to resource constraints.
                            
* Use [Managed Identities](https://docs.microsoft.com/azure/aks/use-managed-identity) to avoid having to manage and rotate service principles.
* Adopt a [multi-region strategy](https://docs.microsoft.com/en-gb/azure/aks/operator-best-practices-multi-region#plan-for-multiregion-deployment) by deploying AKS clusters deployed across different Azure regions to maximize availability and provide business continuity.
  - Internet facing workloads should leverage Azure Front Door, [Azure Traffic Manager](https://docs.microsoft.com/en-gb/azure/aks/operator-best-practices-multi-region#use-azure-traffic-manager-to-route-traffic), or a third-party CDN to route traffic globally across AKS clusters.
                            
* Store container images within Azure Container Registry and enable [geo-replication](https://docs.microsoft.com/azure/aks/operator-best-practices-multi-region#enable-geo-replication-for-container-images) to replicate container images across leveraged AKS regions. 
## Azure App Service
### Design Considerations
* Microsoft guarantees that Apps will be available 99.95% of the time. However, no SLA is provided for Apps using either the Free or Shared tiers.
  > [SLA for App Service](https://azure.microsoft.com/en-us/support/legal/sla/app-service/v1_4/)
                            
### Configuration Recommendations
* Azure App Service provides a number of configuration options that are not enabled by default. For all App Services requiring resiliency, it is highly recommended that:
  - Use Basic or higher plans with 2 or more worker instances for high availability.
                            
  - Evaluate the use of [TCP and SNAT ports](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-intermittent-outbound-connection-errors#cause) to avoid outbound connection errors
    > TCP connections are used for all outbound connections whereas SNAT ports are used when making outbound connections to public IP addresses.SNAT port exhaustion is a common failure scenario that can be predicted by load testing while monitoring ports using Azure Diagnostics. If a load test results in SNAT errors, it is necessary to either scale across more/larger workers, or implement coding practices to help preserve and re-use SNAT ports, such as connection pooling and the lazy loading of resources.It is recommended not to exceed 100 simultaneous outbound connections to a public IP Address per worker, and to avoid communicating with downstream services via public IP addresses when a private address (Private Endpoint) or Service Endpoint through vNet Integration could be used.TCP port exhaustion happens when the sum of connection from a given worker exceeds the capacity. The number of available TCP ports depend on the size of the worker. The following table lists the current limits:|  |Small (B1, S1, P1, I1)|Medium (B2, S2, P2, I2)|Large (B3, S3, P3, I3)||---------|---------|---------|---------||TCP ports|1920|3968|8064|Applications with lots of longstanding connections require ports to be left open for long periods of time, which can lead to TCP Connection exhaustion. TCP Connection limits are fixed based on instance size, so it is necessary to scale up to a larger worker size to increase the allotment of TCP connections, or implement code level mitigations to govern connection usage. Similar to SNAT port exhaustion, Azure Diagnostics can be used to identify if a problem exists with TCP port limits.
                                
                            
  - Enable [AutoHeal](https://azure.github.io/AppService/2018/09/10/Announcing-the-New-Auto-Healing-Experience-in-App-Service-Diagnostics.html) to automatically recycle unhealthy workers.
    > This feature is currently only available to Windows Plans.
                                
                            
  - Enable [Health Check](https://aka.ms/appservicehealthcheck) to identify non-responsive workers.
    > Any health check is better than none at all, however, the logic behind endpoint tests should assess all critical downstream dependencies to ensure overall health. It is also recommended practice to track application health and cache status in real time as this removes unnecessary delays before  action can be taken.
                                
                            
  - Enable [AutoScale](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/autoscale-get-started?toc=/azure/app-service/toc.json) to ensure adequate resources are available to service requests.
    > The default limit of App Service workers is 30.  If the App Service routinely uses 15 or more instances, consider opening a support ticket to increase the maximum number of workers to 2x the instance count required to serve normal peak load.
                                
                            
  - Enable [Local Cache](https://docs.microsoft.com/en-us/azure/app-service/overview-local-cache) to reduce dependencies on cluster file servers.
    > Enabling local cache is not always appropriate because it can lead to slower worker startup times. However, when coupled with Deployment Slots, it can improve resiliency by removing dependencies on file servers and also reduces storage-related recycle events. However, Local cache should not be used with a single worker instance or when shared storage is required.
                                
                            
  - Enable [Diagnostic Logging](https://docs.microsoft.com/en-us/Azure/app-service/troubleshoot-diagnostic-logs) to provide insight into application behavior.
    > Diagnostic logging provides the ability to ingest rich application and platform level logs into either Log Analytics, Azure Storage, or a third party tool via Event Hub.
                                
                            
  - Enable [Application Insights Alerts](https://docs.microsoft.com/en-us/Azure/azure-monitor/app/azure-web-apps) to be made aware of fault conditions.
    > Application performance monitoring with Application Insights provides deep insights into application performance. For Windows Plans a &#39;codeless deployment&#39; approach is possible to quickly get insights without changing any code.
                                
                            
  - Review [Azure App Service diagnostics](https://docs.microsoft.com/en-us/azure/app-service/overview-diagnostics) to ensure common problems are addressed.
    > It is a good practice to regularly review service-related diagnostics and recommendations and take action as appropriate.
                                
                            
* For App Service Environments, ensure ASE is deployed within in [highly available configuration](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment) across Availability Zones.
  > Configuring ASE to use Availability Zones by deploying ASE across specific zones ensures applications can continue to operate even in the event of a data center level failure. This provides excellent redundancy without requiring multiple deployments in different Azure regions.
                            
* For App Service Environments, ensure the [ASE Network](https://docs.microsoft.com/en-us/azure/app-service/environment/network-info) is configured correctly.
  > One common ASE pitfall occurs when ASE is deployed into a subnet with an IP Address space that is too small to support future expansion. In such cases, ASE can be left unable to scale without redeploying the entire environment into a larger subnet. It is highly recomended that adequate IP addresses be used to support either the maximum number of workers or the largest number considered workloads will need. A single ASE cluster can scale to 201 instance, which would require a /24 subnet.
                            
* For App Service Environments, consider configuring [Upgrade Preference](https://docs.microsoft.com/en-us/azure/app-service/environment/using-an-ase#upgrade-preference) if multiple environments are used.
  > If lower environments are used for staging or testing, consideration should be given to configuring these environments to receive updates sooner than the production environment. This will help to identify any conflicts or problems with an update and provides a window to mitigate issues before they reach the production environment.If multiple load balanced (zonal) production deployments are used, upgrade preference can also be used to protect the broader environment against issues from platform upgrades.
                            
* For App Service Environments, plan for scaling out the ASE cluster
  > Scaling ASE instances vertically or horizontally currently takes 30-60 minutes as new private instances need to be provisioned. It is highly recomended that effort be invested up-front to plan for scaling during spikes in load or transient failure scenarios.
                            
* When deploying application code or configuration, it is highly recommended that:
  - Use [Deployment Slots](https://docs.microsoft.com/en-us/azure/app-service/deploy-staging-slots) for resilient code deployments.
    > Deployment Slots allow for code to be deployed to instances that are warmed-up before serving production traffic.[Azure Friday](https://www.youtube.com/watch?v=MP8fXgxq6xo)[blog post](https://ruslany.net/2019/06/azure-app-service-deployment-slots-tips-and-tricks/)
                                
                            
  - Avoid Unnecessary Worker restarts
    > There are a number of events that can lead App Service workers to restart, such as content deployment, App Settings changes, and VNet intergration configuration changes. It is best practice to make changes in a deployment slot other than the slot currently configured to accept production traffic. After workers are recycled and warmed up, a &#34;swap&#34; can be performed without unnecessary down time.
                                
                            
  - Use [&#34;Run From Package&#34;](https://docs.microsoft.com/en-us/azure/app-service/deploy-run-package) to avoid deployment conflicts
    > Run from Package provides several advantages:Eliminates file lock conflicts between deployment and runtime.Ensures only full-deployed apps are running at any time.May reduce cold-start times, particularly for JavaScript functions with large npm package trees.
                                
                            
## Service Fabric
### Design Considerations
* Azure Service Fabric does not provide its own SLA. The availability of Service Fabric clusters is based on the underlying Virtual Machine and Storage resources used.
* Virtual Machine Scale Sets also do not have an SLA, since the SLA for Virtual Machines applies here. If the Virtual Machine Scale Set includes Virtual Machines in at least 2 Fault Domains, the availability of the underlying Virtual Machines SLA for two or more instances applies. If the scale set contains a single Virtual Machine, the availability for a Single Instance Virtual Machine applies.
  > [Service Fabric](https://azure.microsoft.com/en-us/support/legal/sla/service-fabric/v1_0/)[Virtual Machine Scale Set](https://azure.microsoft.com/en-us/support/legal/sla/virtual-machine-scale-sets/v1_1/)
                            