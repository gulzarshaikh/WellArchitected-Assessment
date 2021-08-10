# Service Reliability

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Compute](#Compute)
    - [Azure App Service](#Azure-App-Service)
    - [Azure Kubernetes Service (AKS)](#Azure-Kubernetes-Service-AKS)
    - [Service Fabric](#Service-Fabric)
    - [Virtual Machines](#Virtual-Machines)
    - [Azure Batch](#Azure-Batch)
  - [Data](#Data)
    - [Azure SQL Database](#Azure-SQL-Database)
    - [Azure SQL Managed Instance](#Azure-SQL-Managed-Instance)
    - [Cosmos DB](#Cosmos-DB)
    - [Azure Cache for Redis](#Azure-Cache-for-Redis)
  - [Hybrid](#Hybrid)
    - [Azure Stack Hub](#Azure-Stack-Hub)
  - [Storage](#Storage)
    - [Storage Accounts](#Storage-Accounts)
  - [Messaging](#Messaging)
    - [Event Grid](#Event-Grid)
    - [Event Hub](#Event-Hub)
    - [Service Bus](#Service-Bus)
    - [Storage Queues](#Storage-Queues)
    - [IoT Hub](#IoT-Hub)
    - [IoT Hub Device Provisioning Service](#IoT-Hub-Device-Provisioning-Service)
  - [Networking](#Networking)
    - [Azure Firewall](#Azure-Firewall)
    - [Network Virtual Appliances (NVA)](#Network-Virtual-Appliances-NVA)
    - [Network Connectivity](#Network-Connectivity)
    - [Azure Virtual Networks](#Azure-Virtual-Networks)
    - [ExpressRoute](#ExpressRoute)
    - [Application Delivery (General)](#Application-Delivery-General)
    - [Azure Application Gateway v2](#Azure-Application-Gateway-v2)
    - [Azure Front Door](#Azure-Front-Door)
    - [Azure Loadbalancer](#Azure-Loadbalancer)
    - [Traffic Manager](#Traffic-Manager)
    - [API Management](#API-Management)
# Compute
        
## Azure App Service
### Design Considerations
* Microsoft guarantees that Apps will be available 99.95% of the time. However, no SLA is provided for Apps using either the Free or Shared tiers.
  > [SLA for App Service](https://azure.microsoft.com/support/legal/sla/app-service/v1_4/)
                            
### Configuration Recommendations
* Azure App Service provides a number of configuration options that are not enabled by default. For all App Services requiring resiliency, it is highly recommended that:
  - Use Basic or higher plans with 2 or more worker instances for high availability.
                            
  - Evaluate the use of [TCP and SNAT ports](https://docs.microsoft.com/azure/app-service/troubleshoot-intermittent-outbound-connection-errors#cause) to avoid outbound connection errors
    > TCP connections are used for all outbound connections whereas SNAT ports are used when making outbound connections to public IP addresses.SNAT port exhaustion is a common failure scenario that can be predicted by load testing while monitoring ports using Azure Diagnostics. If a load test results in SNAT errors, it is necessary to either scale across more/larger workers, or implement coding practices to help preserve and re-use SNAT ports, such as connection pooling and the lazy loading of resources.It is recommended not to exceed 100 simultaneous outbound connections to a public IP Address per worker, and to avoid communicating with downstream services via public IP addresses when a private address (Private Endpoint) or Service Endpoint through vNet Integration could be used.TCP port exhaustion happens when the sum of connection from a given worker exceeds the capacity. The number of available TCP ports depend on the size of the worker. The following table lists the current limits:

    > |  |Small (B1, S1, P1, I1)|Medium (B2, S2, P2, I2)|Large (B3, S3, P3, I3)|
    > |---------|---------|---------|---------|
    > |TCP ports|1920|3968|8064|

    > Applications with lots of longstanding connections require ports to be left open for long periods of time, which can lead to TCP Connection exhaustion. TCP Connection limits are fixed based on instance size, so it is necessary to scale up to a larger worker size to increase the allotment of TCP connections, or implement code level mitigations to govern connection usage. Similar to SNAT port exhaustion, Azure Diagnostics can be used to identify if a problem exists with TCP port limits.
                                
                            
  - Enable [AutoHeal](https://azure.github.io/AppService/2018/09/10/Announcing-the-New-Auto-Healing-Experience-in-App-Service-Diagnostics.html) to automatically recycle unhealthy workers.
    > This feature is currently only available to Windows Plans.
                                
                            
  - Enable [Health Check](https://aka.ms/appservicehealthcheck) to identify non-responsive workers.
    > Any health check is better than none at all, however, the logic behind endpoint tests should assess all critical downstream dependencies to ensure overall health. It is also recommended practice to track application health and cache status in real time as this removes unnecessary delays before action can be taken.
                                
                            
  - Enable [AutoScale](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-get-started?toc=/azure/app-service/toc.json) to ensure adequate resources are available to service requests.
    > The default limit of App Service workers is 30. If the App Service routinely uses 15 or more instances, consider opening a support ticket to increase the maximum number of workers to 2x the instance count required to serve normal peak load.
                                
                            
  - Enable [Local Cache](https://docs.microsoft.com/azure/app-service/overview-local-cache) to reduce dependencies on cluster file servers.
    > Enabling local cache is not always appropriate because it can lead to slower worker startup times. However, when coupled with Deployment Slots, it can improve resiliency by removing dependencies on file servers and also reduces storage-related recycle events. However, Local cache should not be used with a single worker instance or when shared storage is required.
                                
                            
  - Enable [Diagnostic Logging](https://docs.microsoft.com/Azure/app-service/troubleshoot-diagnostic-logs) to provide insight into application behavior.
    > Diagnostic logging provides the ability to ingest rich application and platform level logs into either Log Analytics, Azure Storage, or a third party tool via Event Hub.
                                
                            
  - Enable [Application Insights Alerts](https://docs.microsoft.com/Azure/azure-monitor/app/azure-web-apps) to be made aware of fault conditions.
    > Application performance monitoring with Application Insights provides deep insights into application performance. For Windows Plans a 'codeless deployment' approach is possible to quickly get insights without changing any code.
                                
                            
  - Review [Azure App Service diagnostics](https://docs.microsoft.com/azure/app-service/overview-diagnostics) to ensure common problems are addressed.
    > It is a good practice to regularly review service-related diagnostics and recommendations and take action as appropriate.
                                
                            
  - Evaluate [per-app scaling](https://docs.microsoft.com/azure/app-service/manage-scale-per-app) for High-density hosting on Azure App Service.
    > Per-app scaling can be enabled at the App Service plan level to allow for scaling an app independently from the App Service plan that hosts it. This way, an App Service plan can be scaled to 10 instances, but an app can be set to use only five. Apps are allocated to available App Service plan using a best effort approach for an even distribution across instances. While an even distribution is not guaranteed, the platform will make sure that two instances of the same app will not be hosted on the same App Service plan instance.
                                
                            
* For App Service Environments, ensure ASE is deployed within in [highly available configuration](https://docs.microsoft.com/azure/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment) across Availability Zones.
  > Configuring ASE to use Availability Zones by deploying ASE across specific zones ensures applications can continue to operate even in the event of a data center level failure. This provides excellent redundancy without requiring multiple deployments in different Azure regions.
                            
* For App Service Environments, ensure the [ASE Network](https://docs.microsoft.com/azure/app-service/environment/network-info) is configured correctly.
  > One common ASE pitfall occurs when ASE is deployed into a subnet with an IP Address space that is too small to support future expansion. In such cases, ASE can be left unable to scale without redeploying the entire environment into a larger subnet. It is highly recommended that adequate IP addresses be used to support either the maximum number of workers or the largest number considered workloads will need. A single ASE cluster can scale to 201 instance, which would require a /24 subnet.
                            
* For App Service Environments, consider configuring [Upgrade Preference](https://docs.microsoft.com/azure/app-service/environment/using-an-ase#upgrade-preference) if multiple environments are used.
  > If lower environments are used for staging or testing, consideration should be given to configuring these environments to receive updates sooner than the production environment. This will help to identify any conflicts or problems with an update and provides a window to mitigate issues before they reach the production environment.If multiple load balanced (zonal) production deployments are used, upgrade preference can also be used to protect the broader environment against issues from platform upgrades.
                            
* For App Service Environments, plan for scaling out the ASE cluster
  > Scaling ASE instances vertically or horizontally currently takes 30-60 minutes as new private instances need to be provisioned. It is highly recommended that effort be invested up-front to plan for scaling during spikes in load or transient failure scenarios.
                            
* When deploying application code or configuration, it is highly recommended that:
  - Use [Deployment Slots](https://docs.microsoft.com/azure/app-service/deploy-staging-slots) for resilient code deployments.
    > Deployment Slots allow for code to be deployed to instances that are warmed-up before serving production traffic.[Azure Friday](https://www.youtube.com/watch?v=MP8fXgxq6xo)[blog post](https://ruslany.net/2019/06/azure-app-service-deployment-slots-tips-and-tricks/)
                                
                            
  - Avoid Unnecessary Worker restarts
    > There are a number of events that can lead App Service workers to restart, such as content deployment, App Settings changes, and VNet integration configuration changes. It is best practice to make changes in a deployment slot other than the slot currently configured to accept production traffic. After workers are recycled and warmed up, a "swap" can be performed without unnecessary down time.
                                
                            
  - Use [&#34;Run From Package&#34;](https://docs.microsoft.com/azure/app-service/deploy-run-package) to avoid deployment conflicts
    > Run from Package provides several advantages:Eliminates file lock conflicts between deployment and runtime.Ensures only full-deployed apps are running at any time.May reduce cold-start times, particularly for JavaScript functions with large npm package trees.
                                
                            
### Supporting Source Artifacts
* Query to identify App Service Plans with **only 1 instance**:
```
Resources
| where type == "microsoft.web/serverfarms" and properties.computeMode == 'Dedicated'
| where sku.capacity == 1
```
 
                            
* [The Ultimate Guide to Running Healthy Apps in the Cloud](https://azure.github.io/AppService/2020/05/15/Robust-Apps-for-the-cloud.html)
## Azure Kubernetes Service (AKS)
### Configuration Recommendations
* Utilize the [AKS Uptime SLA](https://docs.microsoft.com/azure/aks/uptime-sla) for production grade clusters. The AKS Uptime SLA guarantees:
  - 99.95% availability of the Kubernetes API server endpoint for AKS Clusters that use Azure Availability Zones, or
                            
  - 99.9% availability for AKS Clusters that not use Azure Availability Zones.
                            
* Subscribe to the AKS Roadmap and Release Notes on GitHub
  > Make sure that you're subscribed to the [public AKS Roadmap Release Notes](https://github.com/azure/aks) on GitHub to stay up-to-date on upcoming changes, improvements and most importantly Kubernetes version releases and the deprecation of old releases.
                            
  - Regularly update to the latest version of Kubernetes.
    > AKS supports three minor versions of Kubernetes. This means that when a new minor patch version is introduced, the oldest minor version and patch releases supported are retired. Minor updates to Kubernetes happen on a periodic basis. It is important to have a governance process to check and upgrade as needed to not fall out of support. For more information, see [Supported Kubernetes versions AKS](https://docs.microsoft.com/azure/aks/supported-kubernetes-versions).
                                
                            
  - Regularly process node security and kernel updates and reboots
    > AKS supports [upgrading the images](https://docs.microsoft.com/azure/aks/node-image-upgrade) on a node to be up to date with the newest OS and runtime updates without updating the version of Kubernetes. AKS provides one new image per week with the latest updates, including Linux or Windows patches. For Linux-only deployments you can also use [kured](https://docs.microsoft.com/azure/aks/node-updates-kured).
                                
                            
* Use [Availability Zones](https://docs.microsoft.com/azure/aks/availability-zones) to maximize resilience within an Azure region by distributing AKS agent nodes across physically separate data centers.
  - Where co-locality requirements exist, either a regular VMSS-based AKS deployment into a single zone or [proximity placement groups](https://docs.microsoft.com/azure/aks/reduce-latency-ppg) can be used to minimize inter-node latency.
                            
* Node Pool Design
  - Utilize Virtual Machine Scale Set (VMSS) VM set type for AKS node pools.
                            
  - Keep the System node pool isolated from application workloads. System node pools require a VM SKU of at least 2 vCPUs and 4GB memory. See [System and user node pools](https://docs.microsoft.com/azure/aks/use-system-pools#system-and-user-node-pools) for detailed requirements.
                            
  - Use dedicated node pools for Infrastructure tools that require high resource utilization (eg - Istio) or have a special scale or load behavior.
                            
  - Separate applications to dedicated node pools based on specific requirements (eg - GPU, high memory VMs, [scale-to-zero](https://docs.microsoft.com/azure/aks/scale-cluster#scale-user-node-pools-to-0), Spot VMs etc.). Avoid large numbers of node pools to reduce additional management overhead.
                            
  - Use [taints and tolerations](https://docs.microsoft.com/azure/aks/operator-best-practices-advanced-scheduler#provide-dedicated-nodes-using-taints-and-tolerations) to provide dedicated nodes and limit resource intensive applications.
                            
  - Consider the use of [Virtual Nodes](https://docs.microsoft.com/azure/aks/virtual-nodes-cli) ([vKubelet](https://github.com/virtual-kubelet/virtual-kubelet)) with ACI for rapid, massive and infinite scale.
                            
* Use a template based deployment using ARM, Terraform, Ansible and others only. Make sure that all deployments are repeatable and traceable and stored in a sourcecode repo. Can be combined with GitOps.
* Modifying resources in the [node resource group (ie - &#39;MC_&#39;)](https://docs.microsoft.com/azure/aks/faq#why-are-two-resource-groups-created-with-aks) is not recommended and should only be done at [cluster creation time](https://docs.microsoft.com/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group), or with assistance from Azure Support.
* Scalability
  - Enable [cluster autoscaler](https://docs.microsoft.com/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
    > This ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.
                                
                            
  - Consider using [Azure Spot VMs](https://docs.microsoft.com/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions. For example, workloads such as batch processing jobs, development and testing environments, and large compute workloads may be good candidates to be scheduled on a spot node pool.
    > Using spot VMs for nodes with your AKS cluster allows you to take advantage of unutilized capacity in Azure at a significant cost savings.
                                
                            
  - Utilize the [Horizontal pod autoscaler](https://docs.microsoft.com/azure/aks/concepts-scale#horizontal-pod-autoscaler) to adjust the number of pods in a deployment depending on CPU utilization or other select metrics.
                            
  - Separate workloads into different node pools and consider scaling user node pools to zero.
    > Unlike System node pools that always require running nodes, User node pools allow you to scale to 0.
                                
                            
* Security Guidelines
  - Use [Managed Identities](https://docs.microsoft.com/azure/aks/use-managed-identity) to avoid having to manage and rotate service principles.
                            
  - Utilize [AAD integration](https://docs.microsoft.com/azure/aks/managed-aad) to take advantage of centralized account management and passwords, application access management, and identity protection.
                            
  - Use Kubernetes RBAC with AAD for [least privilege](https://docs.microsoft.com/azure/aks/azure-ad-rbac) and minimize granting administrator privileges to protect configuration and secrets access.
                            
  - Limit access to [Kubernetes cluster configuration](https://docs.microsoft.com/azure/aks/control-kubeconfig-access) file with Azure role-based access control.
                            
  - Limit access to [actions that containers can perform](https://docs.microsoft.com/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources). Provide the least number of permissions, and avoid the use of root / privileged escalation.
                            
  - Evaluate the use of the built-in [AppArmor security module](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-security#app-armor) to limit actions that containers can perform such as read, write, or execute, or system functions such as mounting filesystems.
                            
  - Evaluate the use of the [seccomp (secure computing)](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-security#secure-computing). seccomp works at the process level and allows you to limit the process calls that containers can perform.
                            
  - Use [Pod Identities](https://docs.microsoft.com/azure/aks/operator-best-practices-identity#use-pod-identities) and [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure#usage) with Azure Key Vault to protect secrets, certificates, and connection strings.
                            
  - Use [Azure Security Center](https://docs.microsoft.com/azure/security-center/defender-for-kubernetes-introduction) to provide AKS recommendations.
                            
  - Secure clusters and pods with Azure Policy
    > [Azure Policy](https://docs.microsoft.com/azure/aks/use-pod-security-on-azure-policy) can help to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. It can also control what functions pods are granted and if anything is running against company policy. This access is defined through built-in policies provided by the [Azure Policy Add-on for AKS](https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes). By providing additional control over the security aspects of your pod's specification, like root privileges, enables stricter security adherence and visibility into what is deployed in your cluster. If a pod does not meet conditions specified in the policy, Azure Policy can disallow the pod to start or flag a violation.
                                
                            
* Ensure proper selection of network plugin based on network requirements and cluster sizing.
  > Azure CNI is required for specific scenarios like for example Windows-based node pools, specific networking requirements and Kubernetes Network Policies. See [Kubenet vs. Azure CNI](https://docs.microsoft.com/azure/aks/concepts-network#compare-network-models) for more information.
                            
* Use [Azure Network Policies](https://docs.microsoft.com/azure/aks/use-network-policies) or Calico to control traffic between pods. **Requires CNI Network Plug-in.**
* Utilize a central monitoring tool (eg. - [Azure Monitor and App Insights](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview)) to centrally collect metrics, logs, and diagnostics for troubleshooting purposes.
  - Enable and review [Kubernetes master node logs](https://docs.microsoft.com/azure/aks/view-master-logs).
                            
  - Configure scraping of Prometheus metrics with Azure Monitor for containers
    > Azure Monitor for containers provides a seamless onboarding experience to collect Prometheus metrics. See [Configure scraping of Prometheus metrics with Azure Monitor for containers](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-prometheus-integration) for more.
                                
                            
* Define [Pod resource requests and limits](https://docs.microsoft.com/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits) in application deployment manifests.
* Adopt a [multi-region strategy](https://docs.microsoft.com/azure/aks/operator-best-practices-multi-region#plan-for-multiregion-deployment) by deploying AKS clusters deployed across different Azure regions to maximize availability and provide business continuity.
  - Internet facing workloads should leverage [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview), [Azure Traffic Manager](https://docs.microsoft.com/azure/aks/operator-best-practices-multi-region#use-azure-traffic-manager-to-route-traffic), or a third-party CDN to route traffic globally across AKS clusters.
                            
* Store container images within Azure Container Registry and enable [geo-replication](https://docs.microsoft.com/azure/aks/operator-best-practices-multi-region#enable-geo-replication-for-container-images) to replicate container images across leveraged AKS regions.
  - Enable [Azure Defender for container registries](https://docs.microsoft.com/azure/security-center/defender-for-container-registries-introduction) to enable vulnerability scanning for container images.
                            
  - Authenticate with Azure AD to Azure Container Registry
    > AKS and Azure AD enables authentication with Azure Container Registry without the use of K8s/imagePullSecrets secrets. See [Authenticate with Azure Container Registry from Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/cluster-container-registry-integration) for more.
                                
                            
### Supporting Source Artifacts
* Query to identify AKS clusters that are not deployed across **Availability Zones**:
```
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where isnull(zones)
```
 
                            
* Query to identify AKS clusters that are deployed using **Availability Sets**:
```
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where properties.agentPoolProfiles[0].type != 'VirtualMachineScaleSets'
| project name, location, resourceGroup, subscriptionId, properties.agentPoolProfiles[0].type
```
 
                            
* Query to identify which networking plugin (CNI or Kubenet) is being used by AKS clusters:
```
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| project name, location, resourceGroup, subscriptionId, properties.networkProfile.networkPlugin
```
 
                            
* Query to identify AKS clusters that are not deployed using a **Managed Identity**:
```
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where isnull(identity)
```
 
                            
* Query to identify AKS clusters that are **NOT using RBAC**:
```
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where properties.enableRBAC == false
```
 
                            
## Service Fabric
### Design Considerations
* Azure Service Fabric does not provide its own SLA. The availability of Service Fabric clusters is based on the underlying Virtual Machine and Storage resources used.
* Virtual Machine Scale Sets also do not have an SLA, since the SLA for Virtual Machines applies here. If the Virtual Machine Scale Set includes Virtual Machines in at least 2 Fault Domains, the availability of the underlying Virtual Machines SLA for two or more instances applies. If the scale set contains a single Virtual Machine, the availability for a Single Instance Virtual Machine applies.
  > [Service Fabric](https://azure.microsoft.com/support/legal/sla/service-fabric/v1_0/)[Virtual Machine Scale Set](https://azure.microsoft.com/support/legal/sla/virtual-machine-scale-sets/v1_1/)
                            
### Configuration Recommendations
* Review the [Service Fabric production readiness checklist](https://docs.microsoft.com/azure/service-fabric/service-fabric-production-readiness-checklist)
* Use durability level Silver (5 VMs) or higher for production scenarios.
  > This will ensure the Azure infrastructure communicates with the Service Fabric controller on scheduling reboots, etc.
                            
* For critical workloads, consider using Availability Zones for your Service Fabric clusters.
  > This means deploying a primary NodeType (and by extension a VM ScaleSet) to each AZ. This will ensure that the Service Fabric system services are spread across zones.
                            
* To expose services on the Service Fabric cluster, use a reverse proxy such as the Service Fabric reverse proxy or Traefik. When exposing APIs hosted on the cluster, consider using Azure API Management.
  > API Management can [integrate](https://docs.microsoft.com/azure/service-fabric/service-fabric-api-management-overview) with Service Fabric directly.
                            
* For production scenarios, use the Standard tier load balancer. The Basic SKU is free, but does not have an SLA.
* Keep the different node types and gateway services on different subnets.
* Apply Network Security Groups (NSG) to restrict traffic flow between subnets/node types. Ensure that the [correct ports](https://docs.microsoft.com/azure/service-fabric/service-fabric-best-practices-networking#cluster-networking) are opened for managing the cluster.
  > For example, you may have an API Management instance (one subnet), a frontend subnet (exposing a website directly) and a backend subnet (accessible only to frontend), each implemented on a different VM Scale Set.
                            
* When using secrets (connection strings, passwords) in SF services, either retrieve them directly from Key Vault at runtime or use the [Service Fabric Secrets Store](https://docs.microsoft.com/azure/service-fabric/service-fabric-application-secret-store)
* When using the Service Fabric Secret Store to distribute secrets, use a separate data encipherment certificate to encrypt the values.
  > This certificate is deployed to the VM scaleset nodes to decrypt the secret values. When using this approach, ensure that secrets are inserted and encrypted at release time. Using this approach means that changing the secrets requires a deployment. Make sure your key-rotation process is fully automated to do this without downtime.
                            
* Do not use self-signed certificates for production scenarios. Either provision a certificate through your PKI or use a public certificate authority.
* Deploy certificates by adding them to Azure Keyvault and referencing the URI in your deployment.
* Have a process in place for monitoring the expiration date of certificates.
  > For example, Key Vault offers a feature that sends an email when x% of the certificate's lifespan has elapsed.
                            
* Enable Azure Active Directory integration for your cluster to ensure users can access Service Fabric Explorer using their AAD credentials. Do not distribute the cluster certificate among users to access Explorer. 
* Exclude the Service Fabric processes from Windows Defender to improve performance.
  > By default, Windows Defender antivirus is installed on Windows Server 2016 and 2019. To reduce any performance impact and resource consumption overhead incurred by Windows Defender, and if your security policies allow you to exclude processes and paths for open-source software, you can [exclude](https://docs.microsoft.com/azure/service-fabric/service-fabric-best-practices-security#windows-defender) the Service Fabric executables from Defender scans.
                            
## Virtual Machines
### Design Considerations
* Microsoft provides the following [SLAs for virtual machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/):
  - 95% SLA for single instance virtual machines using Standard HDD Managed Disks for OS and Data disks
                            
  - 99.5% SLA for single instance virtual machines using Standard SSD Managed Disks for OS and Data disks
                            
  - 99.9% SLA for single instance virtual machines using Premium storage for all OS and Data disks
                            
  - 99.95% SLA for all virtual machines that have two or more instances in the same Availability Set or Dedicated Host Group
                            
  - 99.99% SLA for all virtual machines that have two or more instances deployed across two or more Availability Zones in the same region
                            
### Configuration Recommendations
* For all virtual machines requiring resiliency, it is highly recommended that:
  - [Managed Disks](https://docs.microsoft.com/azure/virtual-machines/windows/managed-disks-overview#benefits-of-managed-disks) should be used for all virtual machine OS and Data disks to ensure resilience across underlying storage stamps within a datacenter.
                            
  - Singleton workloads should use Premium Managed Disks to enhance resiliency and obtain a 99.9% SLA as well as dedicated performance characteristics.
                            
  - Non-Singleton workloads should consider two or more replica instances with Managed disks (Standard or Premium) that are deployed within an [Availability Set](https://docs.microsoft.com/azure/virtual-machines/manage-availability) to obtain a 99.95% SLA or across [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) to obtain a 99.99% SLA.
                            
  - Where appropriate virtual machines should be deployed across [Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-overview#availability-zones) to maximize resilience within a specific Azure region.
    > Availability Zones offer unique physical locations within an Azure region, where each zone is made up of one or more datacenters equipped with independent power, cooling, and networking. See [Datacenter Fault Tolerance](https://docs.microsoft.com/azure/virtual-machines/windows/manage-availability#use-availability-zones-to-protect-from-datacenter-level-failures) and [High availability and disaster recovery for IaaS apps](https://docs.microsoft.com/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery) for more.
                                
                            
  - Consider using [proximity placement groups](https://azure.microsoft.com/blog/introducing-proximity-placement-groups/) (PPGs) with Availability Zones (AZ) to have redundant in-zone VMs.
    > It is not possible to create an Availability Set (AS) inside an Availability Zone (AZ) and it is also not possible to control the distribution of VMs within a single availability zone across different fault domains (FD) and update domains (UD). This means that all VMs within a single availability zone might share a common power source and network switch, and can all be rebooted or affected by an outage or maintenance task at the same time. If you create VMs across different AZs, your VMs are effectively distributed across different FDs and UDs. If you want to achieve redundant in-zone VMs and cross-zone VMs, you should place the in-zone VMs in proximity placement groups within availability sets to ensure they won't all be rebooted at once. Go to [Combine ASs and AZs with PPGs](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios#combine-availability-sets-and-availability-zones-with-proximity-placement-groups) for detailed instructions.
                                
                            
* Azure Metadata Service Scheduled Events should be used to proactively respond to maintenance events (i.e. reboots) and limit disruption to virtual machines.
  > Scheduled Events is an [Azure Metadata Service](https://docs.microsoft.com/azure/virtual-machines/windows/scheduled-events) that gives your application time to prepare for virtual machine (VM) maintenance. It provides information about upcoming maintenance events (for example, reboot) so that your application can prepare for them and limit disruption.
                            
* [Azure Backup](https://docs.microsoft.com/azure/backup/backup-azure-vms-introduction) should be used to back-up virtual machines in a Recovery Services Vault, to protect against accidental data loss.
  - Enable Soft Delete for the Recovery Services vault to protect against accidental or malicious deletion of backup data, ensuring the ability to recover.
    > With [Azure Backup Soft Delete](https://docs.microsoft.com/azure/backup/backup-azure-security-feature-cloud), even if a malicious actor deletes a backup (or backup data is accidentally deleted), the backup data is retained for 14 additional days, allowing the recovery of that backup item with no data loss. The additional 14 days of retention for backup data in the soft delete state don't incur any cost to you.
                                
                            
* Enable diagnostic logging for all virtual machines to ensure health metrics, boot diagnostics and infrastructure logs are routed to Log Analytics or an alternative log aggregation technology.
  > Platform logs provide detailed diagnostic and auditing information for Azure resources and the Azure platform they depend on. See [Overview of Azure platform logs](https://docs.microsoft.com/azure/azure-monitor/platform/platform-logs-overview) for more.
                            
* Establish virtual machine Resource Health alerts to notify key stakeholders when resource health events occur.
  > An appropriate threshold for resource unavailability must be set to minimize signal to noise ratios so that transient faults do not generate an alert. For example, configuring a virtual machine alert with an unavailability threshold of 1 minute before an alert is triggered. See [Resource Health Alerts](https://docs.microsoft.com/azure/service-health/resource-health-alert-arm-template-guide) for more.
                            
* To ensure application scalability while navigating within disk sizing thresholds, it is highly recommended that applications be installed on data disks rather than the OS disk.
### Supporting Source Artifacts
* To identify resiliency risks to existing compute resources and support continuous compliance for new resources within a customer tenant, it is recommended that Azure Policy and Azure Resource Graph be used to Audit the use of non-resilient deployment configurations.
* Query to **identify standalone single instance VMs that are not protected by a minimum SLA of at least 99.5%**. It will return all VM instances that are not deployed within an Availability Set or across Availability Zones and are not using either Standard SSD or Premium SSD for both OS and Data disks.
  - This query can easily be altered to identify all single instance VMs including those using Premium Storage which are protected by a minimum SLA of at least 99.5%; simply remove the trailing where condition.
```
Resources
| where
    type =~ 'Microsoft.Compute/virtualMachines'
        and isnull(properties.availabilitySet.id)
    or type =~ 'Microsoft.Compute/virtualMachineScaleSets'
        and sku.capacity <= 1
        or properties.platformFaultDomainCount <= 1
| where 
    tags != '{"Skip":""}'
| where 
    isnull(zones)
| where
	properties.storageProfile.osDisk.managedDisk.storageAccountType !in ('Premium_LRS'
	or properties.storageProfile.dataDisks.managedDisk.storageAccountType != 'Premium_LRS'
	    and array_length(properties.storageProfile.dataDisks) != 0
```
 
                                
                            
* The following query expands on the identification of standalone instances by **identifying any Availability Sets containing single instance VMs**, which are exposed to the same risks as standalone single instances outside of an Availability Set.
```
Resources
| where 
    type =~ 'Microsoft.Compute/availabilitySets'
| where 
    tags != '{"Skip":""}'
| where 
	array_length(properties.virtualMachines) <= 1
| where
	properties.platformFaultDomainCount <= 1
```
 
                            
* Azure policy definition to **audit standalone single instance VMs that are not protected by a SLA**. It will flag an audit event for all Virtual Machine instances that are not deployed within an Availability Set or across Availability Zones and are not using Premium Storage for both OS and Data disks. It also encompasses both Virtual Machine and Virtual Machine Scale Set resources.
  > [Audit VM/VMSS Standalone Instances](../src/compute/policydefinition_Audit-VMStandaloneInstances.json)
                            
* Azure policy definition to **audit Availability Sets containing single instance VMs that are not protected by a SLA**. It will flag an audit event for all Availability Sets that does not contain multiple instances.
  > [Audit Availability Sets With Single Instances](../src/compute/policydefinition_Audit-AvailabilitySetSingleInstances.json)
                            
## Azure Batch
### Design Considerations
* Using multiple Batch accounts in various regions lets your application continue running if a Batch account in one region becomes unavailable. If your application needs to be highly available, having multiple accounts is especially important.
* Use templates and/or scripts to automate the deployment of the application in a region.
* Keep application binaries and reference data up-to-date in all regions.
  > Staying up-to-date will ensure the region can be brought online quickly without having to wait for the upload and deployment of files.
                            
* Use fewer jobs and more tasks.
  > Using a job to run a single task is inefficient. For example, it's more efficient to use a single job containing 1000 tasks rather than creating 100 jobs that contain 10 tasks each. Running 1000 jobs, each with a single task, would be the least efficient, slowest, and most expensive approach to take.
                            
* Build durable tasks
  > Tasks should be designed to withstand failure and accommodate retry. This is especially important for long running tasks. To do this, ensure tasks generate the same, single result even if they are run more than once. One way to achieve this is to make your tasks "goal seeking". Another way is to make sure your tasks are idempotent (tasks will have the same outcome no matter how many times they are run).
                            
### Configuration Recommendations
* Pre-create all required accounts in each region, such as the Batch account and storage account.
  > There is often no charge for having accounts created, and charges accrue only when the account is used or when data is stored.
                            
* Make sure the appropriate quotas are set on all accounts ahead of time, so you can allocate the required number of cores using the Batch account.
# Data
        
## Azure SQL Database
### Design Considerations
* Azure SQL Database is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions. Azure SQL Database is always running on the latest stable version of the SQL Server database engine and patched OS with 99.99% availability. PaaS capabilities that are built into Azure SQL Database enable you to focus on the domain-specific database administration and optimization activities that are critical for your business. 
* Azure SQL Database is having built-in regional high availability and turnkey geo-replication to any Azure region. It includes intelligence to support self-driving features such as performance tuning, threat monitoring, and vulnerability assessments and provides fully automated patching and updating of the code base.
* Azure SQL Database Business Critical or Premium tiers configured as Zone Redundant Deployments have an availability guarantee of at least 99.995%.
* Azure SQL Database Business Critical or Premium tiers not configured for Zone Redundant Deployments, General Purpose, Standard, or Basic tiers, or Hyperscale tier with two or more replicas have an availability guarantee of at least 99.99%.
* Azure SQL Database Hyperscale tier with one replica has an availability guarantee of at least 99.95% and 99.9% for zero replicas.
* Azure SQL Database Business Critical tier configured with geo-replication has a guarantee of Recovery point objective (RPO) of 5 sec for 100% of deployed hours.
* Azure SQL Database Business Critical tier configured with geo-replication has a guarantee of Recovery time objective (RTO) of 30 sec for 100% of deployed hours.
* Use point-in-time restore to recover from human error. Point-in-time restore returns your database to an earlier point in time to recover data from changes done inadvertently. For more information, read the [PITR documentation](https://docs.microsoft.com/azure/azure-sql/database/recovery-using-backups#point-in-time-restore).
* Use geo-restore to recover from a service outage. You can restore a database on any SQL Database server or an instance database on any managed instance in any Azure region from the most recent geo-replicated backups. Geo-restore uses a geo-replicated backup as its source. You can request geo-restore even if the database or datacenter is inaccessible due to an outage. Geo-restore restores a database from a geo-redundant backup. For more information, see [Recover an Azure SQL database using automated database backups](https://docs.microsoft.com/azure/sql-database/sql-database-recovery-using-backups)
* Use sharding Sharding is a technique of distributing data and processing across many identically structured databases, provides an alternative to traditional scale-up approaches both in terms of cost and elasticity. Consider using sharding to partition the database horizontally. Sharding can provide fault isolation. For more information, see [Scaling out with Azure SQL Database](https://docs.microsoft.com/azure/sql-database/sql-database-elastic-scale-introduction).
* Define an application performance SLA and monitor it with alerts. Detecting quickly when your application performance inadvertently degrades below an acceptable level is important to maintain high resiliency. Use the monitoring solution defined above to set alerts on key query performance metrics to you can take action when the performance breaks the SLA. Go to [Monitor Your Database](https://docs.microsoft.com/azure/azure-sql/database/monitor-tune-overview) for more information.
### Configuration Recommendations
* Configure HA/DR that best feed your needs from following options: Azure SQL DB offers the following capabilities for recovering from an outage, it is advised to implement one or combination of one or more depending on Business RTO/RPO requirements:
  - Use Active Geo-Replication: Use Active Geo-Replication to create a readable secondary in a different region. If your primary database fails, perform a manual failover to the secondary database. Until you fail over, the secondary database remains read-only. [Active geo-replication](https://docs.microsoft.com/azure/azure-sql/database/active-geo-replication-overview) enables you to create readable replicas and manually failover to any replica in case of a datacenter outage or application upgrade. Up to 4 secondaries are supported in the same or different regions, and the secondaries can also be used for read-only access queries. The failover must be initiated manually by the application or the user. After failover, the new primary has a different connection end point.
                            
  - Use Auto Failover Groups: A failover group can include one or multiple databases, typically used by the same application. Additionally, you can use the readable secondary databases to offload read-only query workloads. Because auto-failover groups involve multiple databases, these databases must be configured on the primary server. Auto-failover groups support replication of all databases in the group to only one secondary server or instance in a different region. Learn more about [AutoFailover Groups](https://docs.microsoft.com/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell) and [DR design](https://docs.microsoft.com/azure/azure-sql/database/designing-cloud-solutions-for-disaster-recovery).
                            
  - Use Zone-Redundant database: By default, the cluster of nodes for the premium availability model is created in the same datacenter. With the introduction of Azure Availability Zones, SQL Database can place different replicas of the Business Critical database to different availability zones in the same region. To eliminate a single point of failure, the control ring is also duplicated across multiple zones as three gateway rings (GW). The routing to a specific gateway ring is controlled by [Azure Traffic Manager](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview) (ATM). Because the zone redundant configuration in the Premium or Business Critical service tiers does not create additional database redundancy, you can enable it at no extra cost. Learn more on Zone-redundant databases [here](https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla)
                            
* Monitor your Azure SQL DB in near-real time to detect reliability incidents. Use one of the available solutions to monitor SQL DB to detect potential reliability incidents early and make your databases more reliable. Choosing a near real-time monitoring solution is key to quickly react to incidents. See [Azure SQL Analytics](https://docs.microsoft.com/azure/azure-monitor/insights/azure-sql#analyze-data-and-create-alerts) for more information.
* Backup your keys: If you are not [using encryption keys in Azure key vault to protect your data](https://docs.microsoft.com/azure/sql-database/sql-database-always-encrypted-azure-key-vault), backup your keys!
* Implement Retry Logic: Although Azure SQL Database is resilient on the transitive infrastructure failures, these failures might affect your connectivity. When a transient error occurs while working with SQL Database, make sure your code must be able to retry the call. Follow the link for detailed instruction on how to [Implement retry logic](https://docs.microsoft.com/azure/azure-sql/database/troubleshoot-common-connectivity-issues).
## Azure SQL Managed Instance
### Design Considerations
* Use point-in-time restore to recover from human error. Point-in-time restore returns your database to an earlier point in time to recover data from changes done inadvertently. For more information, read the [PITR documentation for managed instance](https://docs.microsoft.com/azure/azure-sql/database/recovery-using-backups#point-in-time-restore)
* Use geo-restore to recover from a service outage. Geo-restore restores a database from a geo-redundant backup into a managed instance in a different region. For more information, see [Recover a database using Geo-restore documentation](https://docs.microsoft.com/azure/azure-sql/database/auto-failover-group-overview).
* Define an application performance SLA and monitor it with alerts. Detecting quickly when your application performance inadvertently degrades below an acceptable level is important to maintain high resiliency. Use the monitoring solution defined above to set alerts on key query performance metrics to you can take action when the performance breaks the SLA.
* Consider the time required for certain operations. Make sure you separate time to thoroughly test the amount of time required to scale up and down (change the size) your existing managed instance, and to create a new managed instance. This will ensure that you understand completely how these time consuming operations will affect your RTO and RPO.
### Configuration Recommendations
* Use Business Critical tier. This tier provides higher resiliency to failures and faster failover times due to the underlying HA architecture, among other benefits. For more information, see [SQL Managed Instance High availability](https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla).
* Configure a secondary instance and an Auto-failover group to enable failover to another region. If an outage impacts one or more of the databases in the managed instance, you can manually or automatically failover all the databases inside the instance to a secondary region. For more information, read the [Auto-failover groups documentation for managed instance](https://docs.microsoft.com/azure/azure-sql/database/auto-failover-group-overview)
* Monitor your SQL MI instance in near-real time to detect reliability incidents. Use one of the available solutions to monitor your SQL MI to detect potential reliability incidents early and make your databases more reliable. Choosing a near real-time monitoring solution is key to quickly react to incidents. For more information, check out the [Azure SQL Managed Instance monitoring options](http://aka.ms/mi-monitoring).
* Implement Retry Logic: Although Azure SQL MI is resilient on the transitive infrastructure failures, these failures might affect your connectivity. When a transient error occurs while working with SQL MI, make sure your code must be able to retry the call. Follow the link for detailed instruction on how to [Implement retry logic](https://docs.microsoft.com/azure/azure-sql/database/troubleshoot-common-connectivity-issues).
## Cosmos DB
### Design Considerations
* 99.99% SLAs for throughput, consistency, availability and latency for Database Accounts scoped to a single Azure region configured with any of the five Consistency Levels or Database Accounts spanning to multiple Azure regions, configured with any of the four relaxed Consistency Levels.
* 99.999% SLA for read availability for Database Accounts spanning two or more Azure region.
* 99.999% SLA for both read and write availability with the configuration of multiple Azure regions as writable endpoints.
  > [Cosmos DB Service Level Agreements](https://azure.microsoft.com/support/legal/sla/cosmos-db/v1_3/)
                            
### Configuration Recommendations
* It is strongly recommended that you configure the Azure Cosmos accounts used for production workloads to enable [automatic failover](https://docs.microsoft.com/azure/cosmos-db/high-availability#multi-region-accounts-with-a-single-write-region-write-region-outage). 
* Session is default consistency level, and it is the most widely used [consistency level](https://docs.microsoft.com/azure/cosmos-db/consistency-levels). It is the recommended consistency level to start with as it receives data later but in the same order as the writes.
* Use [Azure Monitor](https://docs.microsoft.com/azure/cosmos-db/monitor-cosmos-db) to see the provisioned autoscale max RU/s (Autoscale Max Throughput) and the RU/s the system is currently scaled to (Provisioned Throughput).
* Understand your traffic pattern in order to pick the right option for [provisioned throughput types](https://docs.microsoft.com/azure/cosmos-db/how-to-choose-offer).
* For new applications, if you don’t know your traffic pattern yet, start at the entry point RU/s to avoid over-provisioning in the beginning.
* For existing applications:
  - Use Azure Monitor metrics to determine if your traffic pattern is suitable for autoscale.
                            
  - Find the normalized request unit consumption metric of your database or container. Normalized utilization is a measure of how much you are currently using your standard (manual) provisioned throughput.
                            
  - The closer the number is to 100%, the more you are fully using your provisioned RU/s.
                            
* Of all hours in a month, if you set provisioned RU/s T and use the full amount for 66% of the hours or more, it&#39;s estimated you&#39;ll save with standard (manual) provisioned RU/s. If you set autoscale max RU/s Tmax and use the full amount Tmax for 66% of the hours or less, it&#39;s estimated you&#39;ll save with autoscale.
* If multi-master option is enabled on Cosmos DB, it is important to understand [Conflict Types and Resolution Policies](https://docs.microsoft.com/azure/cosmos-db/conflict-resolution-policies).
* [Selecting a partition key](https://docs.microsoft.com/azure/cosmos-db/partitioning-overview#choose-partitionkey) is a simple, but very important design choice:
  - You cannot change partition key after it&#39;s been created with the collection.
                            
  - Your partition key should be a property that has a value which does not change. If a property is your partition key, you can&#39;t update that property&#39;s value.
                            
  - Make sure picking a partition key which has a high cardinality. The property should have a wide range of possible values.
                            
  - Your partition key should spread RU consumption and data storage evenly across all logical partitions. This ensures even RU consumption and storage distribution across your physical partitions.
                            
  - Make sure you are running read queries with the partitioned column as it will reduce RU consumption and latency.
                            
* For query-intensive workloads, use Windows 64-bit instead of Linux or Windows 32-bit host processing.
* If client is consuming more than 50,000 RU/s, there could be bottleneck due to machine capping out on CPU or network utilization. If you reach this point, it is recommended to scale out client applications across multiple servers.
* Call [OpenAsync](https://docs.microsoft.com/dotnet/api/microsoft.azure.documents.client.documentclient.openasync?view=azure-dotnet) to avoid startup latency on first request.
* In order to avoid network latency, collocate client in same region as Cosmos DB.
* Increase the number of threads /tasks.
* To reduce latency and CPU jitter, it is recommended to enable accelerated networking on client virtual machines both [Windows](https://docs.microsoft.com/azure/virtual-network/create-vm-accelerated-networking-powershell) and [Linux](https://docs.microsoft.com/azure/virtual-network/create-vm-accelerated-networking-cli).
* Implement [retry logic](https://docs.microsoft.com/azure/architecture/best-practices/retry-service-specific#cosmos-db) in your client.
### Supporting Source Artifacts
* In order to check if multi location is not selected you can use the following query:
```
Resources
|where  type =~ 'Microsoft.DocumentDb/databaseAccounts'
|where array_length( properties.locations) <=1
```
 
                            
* To check for cosmosdb instances where automatic failover is not enabled:
```
Resources
|where  type =~ 'Microsoft.DocumentDb/databaseAccounts'
|where properties.enableAutomaticFailover!=True
```
 
                            
* Query to see the list of multi-region writes:
```
resources
| where type == "microsoft.documentdb/databaseaccounts"
 and properties.enableMultipleWriteLocations == "true"
```
 
                            
* To see the consistency levels for your cosmos db accounts you can use the query below:
```
Resources
| project name, type, location, consistencyLevel = properties.consistencyPolicy.defaultConsistencyLevel 
| where type == "microsoft.documentdb/databaseaccounts" 
| order by name asc
```
 
                            
* [High Availability in Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/high-availability)
* [Auto-Scale FAQ](https://docs.microsoft.com/azure/cosmos-db/autoscale-faq)
* [Performance Tips for Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/performance-tips)
## Azure Cache for Redis
### Design Considerations
* 99.9% SLA for the cache endpoints and internet gateway will have connectivity
* SLA only covers Standard and Premium tier caches. Basic tier is not covered.
  > [Azure Cache for Redis Service Level Agreements](https://azure.microsoft.com/support/legal/sla/cache/v1_0)
                            
  - Redis (REmote DIctionary Server) is an in memory cache for key value pairs and has High Availablity (HA) by default (except Basic tier). There are three tiers for Azure Cache for Redis: Basic, Standard and Premium.
                            
### Configuration Recommendations
* Basic - (Not recommended for production workloads) Single node, multiple sizes, ideal for development/test and non-critical workloads. The basic tier has no SLA.
* Standard - A replicated cache in a two node Primary/Secondary configuration managed by Microsoft, with a high availability SLA.
* Premium - Includes all standard-tier features and including the following:
  - Faster hardware/performance compared to Basic or Standard-tier
                            
  - Larger cache size (up to 120GB)
                            
  - [Data persistence](https://redis.io/topics/persistence): RDB (Redis Database File) and AOF (Append Only File)
                            
  - VNET support
                            
  - [Clustering](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-how-to-premium-clustering)
                            
  - Geo-Replication - a secondary cache is in another region and replicates data from the primary for disaster recovery. To failover to the secondary, the caches need to be unlinked manually and then the secondary is availabile for writes. The application writing to Redis will need to be updated with the secondary&#39;s cache connection string.
                            
  - Availability Zones (preview) - Deploy the cache and replicas across availability zones. Note: By default, each deployment will have one replica per shard. Persistence, clustering, and geo-replication are all disabled at this time with deployments that have more than one replica. Your nodes will be distributed evenly across all zones. You should have a replica count &gt;= number of zones.
                            
  - Import/Export
                            
* Schedule Updates - Schedule the days and times that Redis Server updates will be applied to the cache. This does not include Azure updates or updates to the VM operating System.
* Monitor the cache and/or set alerts for exceptions, high CPU, high memory usage, server load and evicted keys for insights when to scale the cache. If the cache needs to be scaled, understanding when to scale is important because it will increase CPU during the scaling event to migrate data.
* Deploying the cache inside of a VNET gives the customer more control over the traffic that is able to connect to the cache. Make sure that the subnet has sufficient address space available to deploy the cache nodes and shards (cluster).
* Configure Data Persistence to save a copy of the cache to Azure Storage or use Geo-Replication depending on the business requirement.
  - Data Persistence - if the master and replica reboot, the data will automatically be loaded from the storage account
                            
  - Geo-Replication - the secondary cache needs to be unlinked from the primary. The secondary will now become the primary and be able to receive &#39;writes&#39;.
                            
* Use one static or singleton implementation of the connection multiplexer to Redis and follow the [best practices guide](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-best-practices).
* Review the [How to administer Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-administration#reboot) to understand how data loss can occur with cache reboots and how to test the application for resiliency.
### Supporting Source Artifacts
* Query to identify Redis Instances that are not on the premium tier:
```
Resources 
| where type == 'microsoft.cache/redis'
| where properties.sku.name != 'Premium'
```
 
                            
# Hybrid
        
## Azure Stack Hub
### Design Considerations
* Microsoft does not provide an SLA for Azure Stack Hub because Microsoft does not have control over customer datacenter reliability, people, and processes.
* Azure Stack Hub currently only supports a single Scale Unit (SU) within in a single Region, which can consist of between 4 and 16 servers that use Hyper-V failover clustering; each region serves as an independent Azure Stack Hub &#34;stamp&#34; with separate portal and API endpoints.
  > Azure Stack Hub does therefore **not support Availability Zones** as it currently consists only of a single "region" (aka a single physical location). High availability to cope with outages of a single location should be implemented by using two Azure Stack Hub instances deployed into different physical locations.
                            
* Azure Stack Hub supports **Premium Storage** to ensure compatibility, however, provisioning premium storage accounts or disks does not guarantee that storage objects will be allocated onto SSD or NVMe drives.
* Azure Stack Hub supports only a subset of [VPN Gateway SKUs](https://docs.microsoft.com/azure-stack/user/azure-stack-vpn-gateway-about-vpn-gateways#estimated-aggregate-throughput-by-sku) available in Azure with a limited bandwidth of 100 or 200 Mbps.
  > Only one site-to-site (S2S) VPN connection can be created between two Azure Stack Hub deployments. This is due to a limitation in the platform that only allows a single VPN connection to the same IP address. Multiple S2S VPN connections with higher throughput can be established using 3rd-party NVAs.
                            
* Apply general Azure configuration recommendations for all Azure Stack Hub services.
### Configuration Recommendations
* Treat Azure Stack Hub as a scale unit and deploy multiple instances to remove Azure Stack Hub as a single point of failure for encompassed workloads.
  - Deploy workloads in either an active-active or active-passive configuration across Azure Stack Hub stamps and/or Azure.
                            
# Storage
        
## Storage Accounts
### Design Considerations
* Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
* Storage account names must be unique within Azure. No two storage accounts can have the same name.
* The current [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/) (v1.5, June 2019) specifies a 99.9% guarantee for LRS, ZRS and GRS accounts and a 99.99% guarantee for RA-GRS (provided that requests to RA-GRS switch to secondary endpoints if there is no success on the primary endpoint) to successfully process requests to **read data**. And at least 99.9% to successfully process requests to **write data**. SLAs for other storage tiers might differ. Go to [Azure Storage redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy) to see which redundancy option is best for a specific scenario.
* General-purpose v1 storage accounts provide access to all Azure Storage services, but may not have the latest features or the lowest per gigabyte pricing. It is recommended to use general-purpose v2 storage accounts in most cases. Reasons to still use v1 are:
   * Applications require the classic deployment model.
   * Applications are transaction-intensive or use significant geo-replication bandwidth, but don&#39;t require large capacity.
   * The use of a Storage Service REST API that is earlier than 2014-02-14 or a client library with a version lower than 4.x is required and an application upgrade is not possible.

    See [Storage account overview](https://docs.microsoft.com/azure/storage/common/storage-account-overview) for more.
### Configuration Recommendations
* Turn on soft delete for blob data
  > [Soft delete for Azure Storage blobs](https://docs.microsoft.com/azure/storage/blobs/storage-blob-soft-delete) enables you to recover blob data after it has been deleted.
                            
* Use Azure AD to authorize access to blob data
  > Azure AD provides superior security and ease of use over Shared Key for authorizing requests to Blob storage. It is recommended to use Azure AD authorization with your blob and queue applications when possible to minimize potential security vulnerabilities inherent in Shared Key. For more information, see [Authorize access to Azure blobs and queues using Azure Active Directory](https://docs.microsoft.com/azure/storage/common/storage-auth-aad).
                            
  - Keep in mind the principal of least privilege when assigning permissions to an Azure AD security principal via Azure RBAC
    > When assigning a role to a user, group, or application, grant that security principal only those permissions that are necessary for them to perform their tasks. Limiting access to resources helps prevent both unintentional and malicious misuse of your data.
                                
                            
  - Use Managed Identities to access blob and queue data
    > Azure Blob and Queue storage support Azure AD authentication with [managed identities for Azure resources](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview). Managed identities for Azure resources can authorize access to blob and queue data using Azure AD credentials from applications running in Azure virtual machines (VMs), function apps, virtual machine scale sets, and other services. By using managed identities for Azure resources together with Azure AD authentication, you can avoid storing credentials with your applications that run in the cloud as well as issues with expiring service principals. See [Authorize access to blob and queue data with managed identities for Azure resources](https://docs.microsoft.com/azure/storage/common/storage-auth-aad-msi) for more information.
                                
                            
* Use blob versioning or immutable blobs to store business-critical data
  > Consider using [Blob versioning](https://docs.microsoft.com/azure/storage/blobs/versioning-overview) to automatically maintain previous versions of an object or the use of legal holds and time-based retention policies to store blob data in a WORM (Write Once, Read Many) state. Blobs stored immutably can be read, but cannot be modified or deleted for the duration of the retention interval. For more information, see [Store business-critical blob data with immutable storage](https://docs.microsoft.com/azure/storage/blobs/storage-blob-immutable-storage).
                            
* Enable the Secure transfer required option on all of your storage accounts
  > When you enable the Secure transfer required option, all requests made against the storage account must take place over secure connections. Any requests made over HTTP will fail. For more information, see [Require secure transfer in Azure Storage](https://docs.microsoft.com/azure/storage/common/storage-require-secure-transfer).
                            
  - Limit shared access signature (SAS) tokens to HTTPS connections only
    > Requiring HTTPS when a client uses a SAS token to access blob data helps to minimize the risk of eavesdropping. For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-sas-overview).
                                
                            
  - Avoid/prevent using Shared Key authorization to access Storage Accounts
    > It is recommended to use Azure AD to authorize requests to Azure Storage and possible to [prevent Shared Key Authorization](https://docs.microsoft.com/azure/storage/common/shared-key-authorization-prevent). For scenarios that require Shared Key authorization, always prefer SAS tokens over distributing the Shared Key.
                                
                            
  - Regenerate your account keys periodically
    > Rotating the account keys periodically reduces the risk of exposing your data to malicious actors.
                                
                            
  - Have a revocation plan in place for any SAS that you issue to clients
    > If a SAS is compromised, you will want to revoke that SAS as soon as possible. To revoke a user delegation SAS, revoke the user delegation key to quickly invalidate all signatures associated with that key. To revoke a service SAS that is associated with a stored access policy, you can delete the stored access policy, rename the policy, or change its expiry time to a time that is in the past.
                                
                            
  - Use near-term expiration times on an ad hoc SAS, service SAS or account SAS
    > If a SAS is compromised, it's valid only for a short time. This practice is especially important if you cannot reference a stored access policy. Near-term expiration times also limit the amount of data that can be written to a blob by limiting the time available to upload to it. Clients should renew the SAS well before the expiration, in order to allow time for retries if the service providing the SAS is unavailable.
                                
                            
* Restrict default Internet access for Storage Accounts
  > By default network access to Storage Accounts is not restricted and open to all traffic coming from the Internet. Access to storage accounts should be granted to specific [Azure Virtual Networks only](https://docs.microsoft.com/azure/storage/common/storage-network-security) whenever possible or use [private endpoints](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) to allow clients on a virtual network (VNet) to securely access data over a [Private Link](https://docs.microsoft.com/azure/private-link/private-link-overview). See [Use private endpoints for Azure Storage](https://docs.microsoft.com/azure/storage/common/storage-private-endpoints) for more. Exception can be made for Storage Accounts that need to be accessible via the Internet.
                            
  - Enable firewall rules
    > Configure firewall rules to limit access to your storage account to requests that originate from specified IP addresses or ranges, or from a list of subnets in an Azure Virtual Network (VNet). For more information about configuring firewall rules, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security).
                                
                            
  - Limit network access to specific networks
    > [Limiting network access](https://docs.microsoft.com/azure/storage/common/storage-network-security) to networks hosting clients requiring access reduces the exposure of your resources to network attacks either by using the built-in [Firewall and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security) functionality or by using [private endpoints](https://docs.microsoft.com/azure/storage/common/storage-private-endpoints).
                                
                            
  - Allow trusted Microsoft services to access the storage account
    > Turning on firewall rules for storage accounts blocks incoming requests for data by default, unless the requests originate from a service operating within an Azure Virtual Network (VNet) or from allowed public IP addresses. Requests that are blocked include those from other Azure services, from the Azure portal, from logging and metrics services, and so on. You can permit requests from other Azure services by adding an exception to allow trusted Microsoft services to access the storage account. For more information about adding an exception for trusted Microsoft services, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security).
                                
                            
# Messaging
        
## Event Grid
### Design Considerations
* Azure EventGrid provides a 99.99% uptime SLA
### Configuration Recommendations
* In case of a multi-region Azure solution, deploy an Event Grid instance per region.
* In high-throughput scenarios, use batched events. This means that the service will deliver a json array with multiple events to the subscribers, instead of an array with one event. The consuming application must be able to process these arrays.
* Event batches cannot exceed 1MB in size. This means that if the message payload is large, only one or a few messages will fit in the batch. This means that the consuming service will need to process more event batches. If your event has a large payload, consider storing it elsewhere (e.g. blob storage) and passing a reference in the event. When integrating with third-party services through the CloudEvents schema, it is recommended [not to exceed 64kb events](https://github.com/cloudevents/spec/blob/v1.0/spec.md#size-limits).
* Batch size selection depends on the payload size and the message volume. This should be a configurable parameter and optimizing this should be done during load-testing. 
* If EventGrid delivers to an endpoint that holds custom code, ensure that the message is accepted with an HTTP 200-204 response only when it can be successfully processed. 
* Monitor EventGrid for failed event publishing (Publish Failed metric). Additionally, the &#39;Unmatched&#39; metric will show messages that are published, but not matched to any subscription. Depending on your application architecture, the latter may be intentional.
* Monitor EventGrid for failed event delivery. The &#39;Delivery Failed&#39; metric will increase every time a message cannot be delivered to an event handler (timeout or a non 200-204 HTTP status code). Additionally, if an event must not be lost, set up a Dead-Letter-Queue (DLQ) storage account. This is where events that cannot be delivered after the maximum retry count will be placed. Optionally, implement a notification system on the DLQ storage account, e.g. by handling a &#39;new file&#39; event through Event Grid.
### Supporting Source Artifacts
* Determine Input Schema type for all available Event Grid Domains:
```
Resources 
| where type == 'microsoft.eventgrid/domains'
| project name, resourceGroup, location, subscriptionId, properties['inputSchema']
```
 
                            
* Identify Public Network Access status for all available Event Grid Domains:
```
Resources 
| where type == 'microsoft.eventgrid/domains' 
| project name, resourceGroup, location, subscriptionId, properties['publicNetworkAccess']
```
 
                            
* Identify Firewall Rules for all public Event Grid Domains:
```
Resources 
| where type == 'microsoft.eventgrid/domains' and properties['publicNetworkAccess'] == 'Enabled'
| project name, resourceGroup, location, subscriptionId, properties['inboundIpRules']
```
 
                            
* Retrieve Resource ID of existent private endpoints for Event Grid Domains:
```
Resources 
| where type == 'microsoft.eventgrid/domains' and notnull(properties['privateEndpointConnections']) 
| mvexpand properties['privateEndpointConnections'] 
| project-rename privateEndpointConnections = properties_privateEndpointConnections 
| project name, resourceGroup, location, subscriptionId, privateEndpointConnections['properties']['privateEndpoint']['id']
```
 
                            
* Determine Input Schema type for all available Event Grid Topics:
```
Resources 
| where type == 'microsoft.eventgrid/topics'
| project name, resourceGroup, location, subscriptionId, properties['inputSchema']
```
 
                            
* Identify Public Network Access status for all available Event Grid Topics:
```
Resources 
| where type == 'microsoft.eventgrid/topics' 
| project name, resourceGroup, location, subscriptionId, properties['publicNetworkAccess']
```
 
                            
* Identify Firewall Rules for all public Event Grid Topics:
```
Resources 
| where type == 'microsoft.eventgrid/topics' and properties['publicNetworkAccess'] == 'Enabled'
| project name, resourceGroup, location, subscriptionId, properties['inboundIpRules']
```
 
                            
* Retrieve Resource ID of existent private endpoints for Event Grid Topics:
```
Resources 
| where type == 'microsoft.eventgrid/topics' and notnull(properties['privateEndpointConnections']) 
| mvexpand properties['privateEndpointConnections'] 
| project-rename privateEndpointConnections = properties_privateEndpointConnections 
| project name, resourceGroup, location, subscriptionId, privateEndpointConnections['properties']['privateEndpoint']['id']
```
 
                            
## Event Hub
### Design Considerations
* Azure Event Hubs has a [published SLA](https://azure.microsoft.com/support/legal/sla/event-hubs) of 99.95% for the Basic and Standard Tiers, and 99.99% for the Dedicated Tier.
### Configuration Recommendations
* The number of partitions reflect the degree of downstream parallelism you can achieve. For maximum throughput, use the maximum number of partitions (32) when creating the Event Hub. This will allow you to scale up to 32 concurrent processing entities and will offer the highest send/receive availability.
* In high-throughput scenarios, use batched events. This means that the service will deliver a json array with multiple events to the subscribers, instead of an array with one event. The consuming application must be able to process these arrays.
* As part of your solution-wide availability and disaster recovery strategy, consider enabling the EventHub geo disaster-recovery option. This will allow the creation of a secondary namespace in a different region. Note that only the active namespace receives messages at any time and that messages and events themselves are not replicated to the secondary region.
  > Note: The RTO for the regional failover is 'up to 30 minutes'. Confirm this aligns with the requirements of the customer and fits in the broader availability strategy. If a higher RTO is required, consider implementing a client-side failover pattern too.
                            
* When developing new applications, use EventProcessorClient (.Net and Java) or EventHubConsumerClient (Python and Javascript) as the client SDK. EventProcessorHost has been deprecated.
* Every consumer can read events from 1 to 32 partitions. To achieve maximum scale on the side of the consuming application, every consumer should read from a single partition. 
* Do not publish events to a specific partition. If ordering of events is essential, implement this downstream or use a different messaging service instead.
* Create SendOnly and ListenOnly policies for the event publisher and consumer, respectively.
* When publishing events frequently, use the AMQP protocol when possible. AMQP has higher network costs when initializing the session, however HTTPS requires additional TLS overhead for every request. AMQP has higher performance for frequent publishers.
* When a solution has a large number of independent event publishers, consider using Event Publishers for fine-grained access control. Note that is automatically sets the partition key to the publisher name, so this should only be used if the events originate from all publishers evenly. 
* When using the Capture feature, carefully consider the configuration of the time window and file size, especially with low event volumes. Data Lake will charge small for a minimal file size for storage (gen1) or minimal transaction size (gen2). This means that if you set the time window so low that the file has not reached minimum size, you will incur a lot of extra cost.
* Ensure each consuming application uses a separate consumer group and only one active receiver per consumer group is in place. 
* When using the SDK to send events to Event Hubs, ensure the exceptions thrown by the [retry policy](https://docs.microsoft.com/azure/architecture/best-practices/retry-service-specific#event-hubs) (EventHubsException or OperationCancelledException) are properly caught. When using HTTPS, ensure a proper retry pattern is implemented.
### Supporting Source Artifacts
* Find Event Hub namespaces with &#39;Basic&#39; SKU:
```
Resources 
| where type == 'microsoft.eventhub/namespaces'
| where sku.name == 'Basic'
| project resourceGroup, name, sku.name
```
 
                            
## Service Bus
### Design Considerations
* For Service Bus Queues and Topics, Microsoft guarantees that at least 99.9% of the time, properly configured applications will be able to send or receive messages or perform other operations on a deployed Queue or Topic. [SLA Documentation](https://azure.microsoft.com/support/legal/sla/service-bus)
* However, when deploying Service Bus with Geo-disaster recovery and in availability zones, the SLO increases dramatically, but does not change the financially backed SLA of 99.9% availability.
* [Partitioned Queues and Topics](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-partitioning)
* [Express Entities](https://docs.microsoft.com/dotnet/api/microsoft.servicebus.messaging.queuedescription.enableexpress)
* In addition to the documentation on [Service Bus Premium and Standard messaging tiers](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-premium-messaging), these features are only available on the Premium SKU.
  - Dedicated resources
                            
  - Virtual network integration: Limits the networks that can connect to the Service Bus instance. Requires Service Endpoints to be enabled on the subnet. There are Trusted Microsoft services that are not supported when Virtual Networks are implemented (i.e., integration with Event Grid) https://docs.microsoft.com/azure/service-bus-messaging/service-bus-service-endpoints
                            
  - Private endpoints
                            
  - IP Filtering/Firewall: Restrict connections to only defined IPv4 addresses or IPv4 address ranges
                            
  - [Availability zones](https://docs.microsoft.com/azure/availability-zones/az-overview): Provides enhanced availability by spreading replicas across availability zones within one region at no additional cost
                            
  - Event Grid Integration: [Available event types](https://docs.microsoft.com/azure/event-grid/event-schema-service-bus)
                            
  - Scale Messaging Units
                            
  - [Geo-Disaster Recovery](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-geo-dr) (paired namespace)
                            
  - BYOK (Bring Your Own Key): Azure Service Bus encrypts data at rest and automatically decrypts it when accessed, but customers can also bring their own customer-managed key.
                            
### Configuration Recommendations
* If you need mission critical messaging with queues/topics, Service Bus Premium is recommended with Geo-Disaster Recovery. Choosing the pattern is dependent on the business requirements and the recovery time objective (RTO).
* Geo-Disaster
  - [Active/Active](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#active-replication)
                            
  - [Active/Passive](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#passive-replication)
                            
  - [Paired Namespace (Active/Passive)](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-geo-dr)
                            
  - NOTE: the secondary region should preferably be an [Azure paired region](https://docs.microsoft.com/azure/best-practices-availability-paired-regions).
                            
* Make the namespace zone redundant (only available with Premium)
* Review the [Best Practices for performance improvements using Service Bus Messaging](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-performance-improvements).
* Connect to Service Bus with the AMQP protocol and utilize Service Endpoints or Private Endpoints when possible. This keeps traffic on the Azure Backbone. Note: the default connection protocol for Microsoft.Azure.ServiceBus and Windows.Azure.ServiceBus namespaces is AMQP.
* Ensure that Service Bus messaging exceptions are handled properly.
  > [Service Bus Messaging Exceptions](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-messaging-exceptions)
                            
### Supporting Source Artifacts
* Query to identify Service Bus Instances that are not on the premium tier:
```
Resources
| where
	type == 'microsoft.servicebus/namespaces'
| where
	sku.tier != 'Premium'
```
 
                            
* Query to identify premium Service Bus Instances that are not zone redundant:
```
Resources
| where
	type == 'microsoft.servicebus/namespaces'
| where
	sku.tier == 'Premium'
	and properties.zoneRedundant == 'false'
```
 
                            
* Query to identify premium Service Bus Instances that are not using private endpoints:
```
Resources
| where
	type == 'microsoft.servicebus/namespaces'
| where
	sku.tier == 'Premium'
	and isempty(properties.privateEndpointConnections)
```
 
                            
## Storage Queues
### Design Considerations
* Azure Storage Queues follow the SLA statements of the general [Storage Account service](https://azure.microsoft.com/support/legal/sla/storage/v1_5/). Currently (v1.5) this specifies a 99.9% guarantee for LRS, ZRS and GRS accounts and a 99.99% guarantee for RA-GRS (provided that requests to RA-GRS switch to secondary endpoints if there is no success on the primary endpoint)
### Configuration Recommendations
* Since Storage Queues are part of the Azure Storage service, please refer to the general storage guidance, in addition to the configuration recommendations mentioned below.
* Using geo-zone-redundant storage (GZRS) or read-access geo-zone-redundant storage (RA-GZRS) will provide 16 nines or durability and will protect against failover if an entire datacenter becomes unavailable. See [Azure Storage redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy) for more information.
* For an SLA increase from three to four nines, use geo-redundant storage with read access and configure the client application to fail over to secondary read endpoints if the primary endpoints fail to respond. This consideration should be part of the overall reliability strategy of your solution.
* Refer to the &#39;Storage&#39; guidance for specifics on data recovery for storage accounts
* Ensure that for all clients accessing the storage account, a proper [retry policy](https://docs.microsoft.com/azure/architecture/best-practices/retry-service-specific#azure-storage) is implemented.
### Supporting Source Artifacts
* Query to identify storage accounts using V1 storage accounts:
```
Resources
| where
	type == 'microsoft.storage/storageaccounts'
	and kind == 'Storage'
```
 
                            
* Query to identify storage accounts using locally redundant storage (LRS):
```
Resources
| where
	type == 'microsoft.storage/storageaccounts'
	and sku.name =~ 'Standard_LRS'
```
 
                            
## IoT Hub
### Design Considerations
* Azure IoT Hub has a [published SLA](https://azure.microsoft.com/support/legal/sla/iot-hub) of 99.9% for the Basic and Standard tiers, there is no SLA for the Free tier.
### Configuration Recommendations
* The number of Device-to-cloud partitions for the Event Hub-compatible endpoint reflect the degree of downstream parallelism you can achieve. For maximum throughput, use the maximum number of partitions (32) when creating the IoT Hub - if you are planning to use the built-in endpoint. This will allow you to scale up to 32 concurrent processing entities and will offer the highest send/receive availability. This number cannot be changed after creation.
* In high-throughput scenarios, use batched events. This means that the service will deliver an array with multiple events to the consumers, instead of an array with one event. The consuming application must be able to process these arrays.
* As part of your solution-wide availability and disaster recovery strategy, consider using the IoT Hub [cross-region Disaster Recovery option](https://docs.microsoft.com/azure/iot-hub/iot-hub-ha-dr#cross-region-dr). This will move the IoT Hub endpoint to the paired Azure region. Note that only the device registry gets replicated. Events themselves are not replicated to the secondary region.
  > Note: The RTO for the customer-initiated failover is 'between 10 minutes to a couple of hours'. For a Microsoft-initiated failover the RTO is '2-26 hours'. Confirm this aligns with the requirements of the customer and fits in the broader availability strategy. If a higher RTO is required, consider implementing a client-side failover pattern, too.
                            
* When sending events frequently, use the AMQP or MQTT protocol when possible. AMQP and MQTT have higher network costs when initializing the session, however HTTPS requires additional TLS overhead for every request. AMQP and MQTT have higher performance for frequent publishers.
* When using an SDK to send events to IoT Hubs, ensure the exceptions thrown by the [retry policy](https://docs.microsoft.com/azure/architecture/best-practices/retry-service-specific#iot-hub) (EventHubsException or OperationCancelledException) are properly caught. When using HTTPS, ensure a proper retry pattern is implemented.
* When using message routing feature in IoT Hub, latency of the message delivery increases. On average this [should not exceed 500 ms](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-messages-d2c#latency), but be aware that there is no guarantee for the delivery latency. If you require the minimum possible latency, consider to not use routing and read the events from the built-in endpoint.
* If you are using [X.509 certificates](https://docs.microsoft.com/azure/iot-hub/iot-hub-security-x509-get-started#get-x509-ca-certificates) for the device connection, it is recommended to use only certificates validated by a root CA in production environment. Make sure you have processes in place to update the certificate before they expire.
* Adding more than one IoT Hub per region does not offer additional resiliency as chances are, that all hubs might still run on the same underlying cluster. For scaling reasons it is usually sufficient to increase the tier and/or allocated IoT Hub units.
* If the RTOs offered by either customer- or Microsoft-initiated failover (see above) are not sufficient, it is recommended to provision a second IoT Hub in another region and have routing logic on the device. This can be further enhanced with a &#39;Concierge Service&#39;. See [here](https://docs.microsoft.com/azure/iot-hub/iot-hub-ha-dr#achieve-cross-region-ha) for more details.
* To avoid telemetry interruption due to throttling / fully used quota, consider adding a [custom auto-scaling solution](https://docs.microsoft.com/azure/iot-hub/iot-hub-scaling#auto-scale).
* When reading device telemetry from the built-in Event Hub-compatible endpoint, refer to the recommendation regarding [Event Hub consumers](#Event-Hub) in this document.
## IoT Hub Device Provisioning Service
### Design Considerations
* Azure IoT Hub Device Provisioning Service has a [published SLA](https://azure.microsoft.com/support/legal/sla/iot-hub) of 99.9%.
# Networking
        
## Azure Firewall
### Design Considerations
* When deployed to a single Availability Zone, Azure Firewall provides a [99.95% SLA](https://azure.microsoft.com/support/legal/sla/azure-firewall/v1_1/).
* When deployed to two or more Availability Zones, Azure Firewall provides a [99.99% SLA](https://azure.microsoft.com/support/legal/sla/azure-firewall/v1_1/)
* Use Azure Firewall to govern:
  - Azure outbound traffic to the internet
                            
  - Non-HTTP/S inbound connections
                            
  - East-west traffic filtering (if required by customer)
                            
* Use Firewall Manager with Azure Virtual WAN to deploy and manage Azure Firewalls across Azure Virtual WAN Hubs, or in Hub VNets.
### Configuration Recommendations
* Create a global Azure Firewall policy to govern security posture across the global network environment and assign it to all Azure Firewalls.
  > Allow for granular policies to meet requirements of specific regions by delegating incremental Firewall Policies to local security teams via RBAC.
                            
* Configure supported 3rd party SaaS security providers within Firewall Manager if the customer wishes to use such solutions to protect outbound connections.
## Network Virtual Appliances (NVA)
### Configuration Recommendations
* If 3rd party NVAs are required for east-west and/or south-north traffic protection/filtering:
  - For VWAN network topologies, deploy the NVAs to a separate VNet (i.e. NVA VNet) and connect it to the regional Virtual WAN Hub as well as to the &#34;Landing Zones&#34; that require access to NVAs as described in this [article](https://docs.microsoft.com/azure/virtual-wan/virtual-wan-route-table-portal).
                            
  - For non-Virtual WAN network topologies, deploy the 3rd party NVAs in the central Hub VNet.
                            
* If 3rd party NVAs are required for inbound HTTP/S connections, they should be deployed within a &#34;Landing Zone&#34; or &#34;solution-level&#34; Virtual Network, together with the applications that they are protecting and exposing to the internet.
## Network Connectivity
### Design Considerations
* Azure native network security services such as Azure Firewall, Application Gateway, and Azure Front Door are fully managed services, meaning that customers do not incur the operational and management costs associated with infrastructure deployments, which can become complex at scale.
* Azure PaaS services are typically accessed over public endpoints, however, the Azure platform provides capabilities to secure such endpoints or even make them entirely private.
* Azure provides three models for private network connectivity: VNet injection, VNet Service Endpoints and Private Link:
  - VNet injection applies to services that are deployed specifically for you, such as AKS nodes, SQL Managed Instance, Virtual Machines. These resources connect directly to your virtual network.
                            
  - [Virtual Network (VNet) service endpoints](https://docs.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview) provide secure and direct connectivity to Azure services over an optimized route over the Azure backbone network.
    > Service Endpoints enable private IP addresses in the VNet to reach the endpoint of an Azure service without needing a public IP address on the VNet.
                                
                            
  - [Private Link](https://docs.microsoft.com/azure/private-link/private-endpoint-overview#private-link-resource) provides dedicated access using private IP addresses to Azure PaaS instances, or custom services behind an Azure Load Balancer Standard.
                            
  - Use Private Link, where available, for shared Azure PaaS services. Private Link is generally available for several services and is in public preview for numerous ones.
                            
  - Access Azure PaaS services from on-premises via ExpressRoute private peering.
    > Use either virtual network injection for dedicated Azure services or Azure Private Link for available shared Azure services. To access Azure PaaS services from on-premises when virtual network injection or Private Link isn't available, use ExpressRoute with Microsoft peering. This method avoids transiting over the public internet.
                                
                            
  - Use virtual network service endpoints to secure access to Azure PaaS services from within your virtual network, but only when Private Link isn&#39;t available and there are no data exfiltration concerns.
                            
  - Service Endpoints do not allow a PaaS service to be accessed from on-premises networks. Private Endpoints do.
                            
  - To address data exfiltration concerns with service endpoints, use NVA filtering or use virtual network service endpoint policies for Azure Storage.
                            
* 3rd party NVAs may also be used, should the customer prefer to use NVAs or for situations where native services do not satisfy specific customer requirements.
### Configuration Recommendations
* Don&#39;t enable virtual network service endpoints by default on all subnets.
* Don&#39;t use virtual network service endpoints when there are data exfiltration concerns, unless you use NVA filtering.
* We don&#39;t recommend that you implement forced tunneling to enable communication from Azure to Azure resources.
## Azure Virtual Networks
### Design Considerations
* Overlapping IP address spaces across on-premises and Azure regions will create major contention challenges.
* While Virtual Network address space can be added after creation, this process will require an outage if the Virtual Network is already connected to another Virtual Network via peering, since the Virtual Network peering will have to be deleted and re-created.
  > (Note: Modification of address space on peered vnets was announced at Ignite in sept 2020, but no timelines provided. Check the status before discussing with customer.)
                            
* Azure reserves 5 IP addresses within each subnet which should be factored in when sizing Virtual Networks and encompassed subnets.
* Some Azure services do require [dedicated subnets](https://docs.microsoft.com/azure/virtual-network/virtual-network-for-azure-services#services-that-can-be-deployed-into-a-virtual-network), such as Azure Firewall, Azure Bastion or Virtual Network Gateway.
* Subnets can be delegated to certain services to create instances of that service within the subnet.
### Configuration Recommendations
* Use Azure DDoS Standard Protection Plans to protect all public endpoints hosted within customer Virtual Networks.
* Do not replicate on-premises DMZ concepts and architectures into Azure.
  > Customers can get similar security capabilities in Azure as on-premises, but the implementation and architecture will need to be adapted to the cloud.
                            
* Azure PaaS services that have been injected into a Virtual Network still perform management plane operations using public IP addresses. Ensure that this communication is locked down within the Virtual Network using UDRs and NSGs.
* Access Azure PaaS services from on-premises via ExpressRoute Private Peering, using either VNet injection for dedicated Azure services or Azure Private Link for available shared Azure services.
  - To access Azure PaaS services from on-premises networks when VNet injection or Private Link are not available, use ExpressRoute with Microsoft Peering when there are no data exfiltration concerns. This would avoid transit over the public internet.
                            
* Use VNet Service Endpoints to secure access to Azure PaaS services from within a customer VNet, but only when Private Link is not available and when there are no data exfiltration concerns. To address data exfiltration concerns with Service Endpoints:
  - Use NVA filtering.
                            
  - Use VNet Service Endpoint Policies for Azure Storage.
                            
* Do not enable VNet Service Endpoints by default on all subnets.
* Do not use VNet Service Endpoints when there are data exfiltration concerns, unless NVA filtering is used.
* It is strongly recommended to not implement forced tunneling to enable communication from Azure to Azure resources.
* It is vital that enterprise customers plan for IP addressing in Azure to ensure there is no overlapping IP address space across considered on-premises locations and Azure regions.
  - Plan for non-overlapping IP address spaces across Azure regions and on-premises locations well in advance.
                            
  - Use IP addresses from the address allocation for private internets (RFC 1918).
                            
  - For environments with limited private IP addresses (RFC 1918) availability, consider using IPv6.
                            
  - Do not create unnecessarily large Virtual Networks (for example: /16) to ensure there is no unnecessary wastage of IP address space.
                            
  - Do not create Virtual Networks without planning the required address space in advance, since adding address space will cause an outage once a Virtual Network is connected via Virtual Network Peering.
                            
  - Do not use public IP addresses for Virtual Networks, especially if the public IP addresses do not belong to the customer.
                            
## ExpressRoute
### Design Considerations
* Azure ExpressRoute provides dedicated private connectivity to Microsoft services such as Azure and Office 365 from on-premises locations.
* Private Link can be used to establish connectivity to PaaS services over ExpressRoute with Private Peering.
* When multiple virtual networks are connected to the same ExpressRoute circuit, they will become part of the same routing domain and all virtual networks will share the bandwidth.
* ExpressRoute Global Reach (where available) allows customers to connect on-premises locations together using ExpressRoute circuits to transit traffic over the Microsoft backbone network.
* ExpressRoute Global Reach is available in many ExpressRoute peering [locations](https://docs.microsoft.com/azure/expressroute/expressroute-global-reach#availability).
* ExpressRoute Direct allows to create multiple ExpressRoute circuits at no additional cost, up to the ExpressRoute Direct port capacity (10G or 100G and allows you to connect directly to Microsoft&#39;s ExpressRoute routers).
  - For the 100 Gbps SKU, the minimum circuit bandwidth is 5 Gbps.
                            
  - For the 10 Gbps SKU, the minimum circuit bandwidth is 1 Gbps.
                            
### Configuration Recommendations
* Use ExpressRoute as the primary connectivity channel for connecting on-premises network to Microsoft Azure.
  - VPNs can be used as a source of backup connectivity to enhance connectivity resiliency.
                            
* Use dual ExpressRoute circuits from different peering locations when connecting an on-premises location to Virtual Networks in Azure. This setup will ensure redundant paths to Azure, removing single points of failure between on-premises and Azure.
* When multiple ExpressRoute circuits are used, [optimize routing](https://docs.microsoft.com/azure/expressroute/expressroute-optimize-routing) by using BGP local preference and AS Path prepending.
* Ensure the right SKU is used for the ExpressRoute/VPN Gateways based on bandwidth and performance requirements.
* Deploy a Zone Redundant ExpressRoute Gateway in the supported Azure regions.
* For scenarios that require bandwidth higher than 10Gbps or dedicated 10/100 Gbps ports, use ExpressRoute Direct.
* When very low latency is required, or throughput from on-premises to Azure must be greater than 10 Gbps, enable FastPath to bypass the ExpressRoute Gateway from the data path.
* Use VPN Gateways to connect branches or remote locations to Azure.
  - For higher resiliency, deploy Zone-Redundant Gateways (where available).
                            
* Use ExpressRoute Global Reach to connect large offices /regional headquarters/datacenter that are connected to Azure via ExpressRoute.
* When traffic isolation or dedicated bandwidth is required, such as for separating production and non-production environments, different ExpressRoute circuits should be used to ensure isolated routing domains and to mitigate noisy neighbour risks.
* Proactively monitor ExpressRoute circuits using Network Performance Monitor.
* Do not explicitly use ExpressRoute circuits from a single peering location as it creates a single point of failure, making the customer likely susceptible to peering location outages.
## Application Delivery (General)
### Design Considerations
* Azure Load Balancer (internal and public) provides high availability for application delivery at a regional level. (Standard tier only)
* Azure Application Gateway allows the secure delivery of HTTP/S applications at a regional level.
* Azure Front Door allows the secure, delivery of highly available HTTP/S applications across Azure regions.
* Azure Traffic manager allows the delivery of applications through DNS redirection, including traffic using protocols other than HTTP/S).
### Configuration Recommendations
* Application delivery for both internal and external facing applications should be part of the application. It should not be centrally managed within an organization.
* For secure delivery of HTTP/S applications, ensure Web Application Firewall (WAF) protection/policies are enabled. This can be done in either Application Gateway or Front Door.
* Use a 3rd party Network Virtual Appliance (NVA) if Application Gateway v2 cannot be used for the security of HTTP/S applications.
* Application Gateway v2 or 3rd party NVAs used for inbound HTTP/S connections, should be deployed  in the Virtual Network together with the applications that they are securing. It should not be managed centrally within the organization and shared with other workloads.
* All public IP addresses in a the solution should be protected with a DDoS Standard protection plan.
* Global HTTP/S applications that span Azure regions should be delivered and protected using Azure Front Door with Web Application Firewall (WAF) policies.
* When using Azure Front Door and Application Gateway to protect HTTP/S applications, use WAF policies in Front Door and lock down Application Gateway to receive traffic only from Azure Front Door.
  > While this is the general recommendation, certain scenarios might force a customer to implement rules specifically on AppGateway: For example, if ModSec CRS 2.2.9, CRS 3.0 or CRS 3.1 rules are required, this can only be implemented on AppGatway. Conversely, rate-limiting and geo-filtering are available only on Azure Front Door, not on AppGateway. Instructions on how to lock down traffic can be found [here](https://docs.microsoft.com/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door)
                            
* Global applications that span protocols other than HTTP/S should be delivered using Azure Traffic Manager. Traffic manager does not forward traffic, but only performs DNS redirection. This means that the connection from the client is established directly to the target using any protocol.
* When doing global loadbalancing for HTTP/S applications, Front Door is preferred over Traffic Manager. This is because, amongst others:
  - Azure Front Door optimizes the number of TCP connections to the backend when forwarding traffic
                            
  - Changes to the routing configuration, e.g. based on backend health, are instantaneous. With Traffic Manager, traffic will point to the original backend until a new DNS lookup is performed, plus potential time for DNS propagation.
                            
  - Front Door supports caching on global edge nodes, negating the need for a separate CDN service
                            
  - Front Door supports Web Application Firewall rules, negating the need for a separate WAF service
                            
* Enable health probes for backends.
  > Health probes are http(s) endpoints that are queried by the load balancer (Azure Front Door, Traffic Manager, AppGateway) service to determine if the backend is healthy enough to handle requests.
                            
* Create a separate health endpoint on the backend to be used by the health probe, that can aggregate the state of the critical services and dependencies needed to serve requests.
  > More information on creating such an endpoint can be found [here](https://docs.microsoft.com/azure/architecture/patterns/health-endpoint-monitoring).
                            
## Azure Application Gateway v2
### Configuration Recommendations
* In new deployments, use Application Gateway v2 unless there is a compelling reason to use v1.
* Deploy at least two AppGateway v2 instances to increase availability
* Deploy the instances in a [zone-aware configuration](https://docs.microsoft.com/azure/application-gateway/application-gateway-autoscaling-zone-redundant), where available.
* Use Application Gateway with Web Application Firewall (WAF) within an application Virtual Network for protecting inbound HTTP/S traffic from the internet.
* When using Azure Front Door and Application Gateway to protect HTTP/S applications, use WAF policies in Front Door and lock down Application Gateway to receive traffic only from Azure Front Door.
  > While this is the general recommendation, certain scenarios might force a customer to implement rules specifically on AppGateway: For example, if ModSec CRS 2.2.9, CRS 3.0 or CRS 3.1 rules are required, this can only be implemented on AppGatway. Conversely, rate-limiting and geo-filtering are available only on Azure Front Door, not on AppGateway.
                            
## Azure Front Door
### Configuration Recommendations
* Use Azure Front Door WAF policies to provide global protection across Azure regions for inbound HTTP/S connections to a &#34;Landing Zone&#34;.
* When using Azure Front Door and Application Gateway to protect HTTP/S applications, use WAF policies in Front Door and lock down Application Gateway to receive traffic only from Azure Front Door.
  > While this is the general recommendation, certain scenarios might force a customer to implement rules specifically on AppGateway: For example, if ModSec CRS 2.2.9, CRS 3.0 or CRS 3.1 rules are required, this can only be implemented on AppGatway. Conversely, rate-limiting and geo-filtering are available only on Azure Front Door, not on AppGateway. Instructions on how to lock down traffic can be found [here](https://docs.microsoft.com/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door)
                            
* Create a rule to block access to the health endpoint from the Internet
* Front Door currently does not support SSL passthrough, this means Front Door must hold the certificate to terminate the encrypted inbound connection. Ensure that the connection to the back-end is re-encrypted.
## Azure Loadbalancer
### Configuration Recommendations
* For production workloads, use the Standard SKU. Basic loadbalancers do not have an SLA. Additionally, the Standard SKU [supports Availability Zones](https://docs.microsoft.com/azure/load-balancer/load-balancer-standard-availability-zones).
## Traffic Manager
### Configuration Recommendations
* When a backend becomes unavailable, Traffic Manager will not fail over to another region immediately. There will be a time interval where clients cannot be served. The length of this interval depends on
  - The time settings of the health probe (probe interval and the number and the number of unhealthy responses allowed)
                            
  - The TTL of the DNS record. By default this is 5 minutes. If this time interval is too long, consider adjusting the health probe timing or DNS record TTL. If the resulting interval is still too large for the scenario at hand, consider switching to Azure Front Door for global loadbalancing.
                            
## API Management
### Configuration Recommendations
* [Secure the communication](https://docs.microsoft.com/azure/api-management/api-management-faq#how-can-i-secure-the-connection-between-the-api-management-gateway-and-my-back-end-services) between API Management and your backend.
* When exposing APIs to third parties, ensure that
  - Each party has its own credential
                            
  - Quotas and rate limits have been set
                            