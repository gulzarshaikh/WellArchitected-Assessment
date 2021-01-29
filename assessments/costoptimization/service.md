# Service Cost Optimization

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Compute](#Compute)
    - [Azure App Service](#Azure-App-Service)
    - [Azure Kubernetes Service (AKS)](#Azure-Kubernetes-Service-AKS)
    - [Virtual Machines](#Virtual-Machines)
  - [Storage](#Storage)
    - [Storage Accounts](#Storage-Accounts)
    - [Disks](#Disks)
  - [Networking](#Networking)
    - [Network Virtual Appliances (NVA)](#Network-Virtual-Appliances-NVA)
    - [Network Connectivity](#Network-Connectivity)
    - [IP Addresses](#IP-Addresses)
# Compute
        
## Azure App Service
### Configuration Recommendations
* Are you saving costs by using the App Service Premium (v3) Plan over the Premium (Pv2) Plan?
  > The App Service Premium (v3) Plan has a 20% discount versus comparable Pv2 configurations. Reserved Instance commitment (1Y, 3Y, Dev/Test) discounts are available for App Services running in the Premium v3 plan.
                            
## Azure Kubernetes Service (AKS)
### Configuration Recommendations
* Scalability
  - Enable [cluster autoscaler](https://docs.microsoft.com/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
    > This ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.
                                
                            
  - Consider using [Azure Spot VMs](https://docs.microsoft.com/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions. For example, workloads such as batch processing jobs, development and testing environments, and large compute workloads may be good candidates to be scheduled on a spot node pool.
    > Using spot VMs for nodes with your AKS cluster allows you to take advantage of unutilized capacity in Azure at a significant cost savings.
                                
                            
  - Utilize the [Horizontal pod autoscaler](https://docs.microsoft.com/azure/aks/concepts-scale#horizontal-pod-autoscaler) to adjust the number of pods in a deployment depending on CPU utilization or other select metrics.
                            
  - Separate workloads into different node pools and consider scaling user node pools to zero.
    > Unlike System node pools that always require running nodes, User node pools allow you to scale to 0.
                                
                            
* Use the Start/Stop feature in Azure Kubernetes Services (AKS).
  > (in preview as of 11/2020) The AKS Stop/Start cluster feature now in public preview allows AKS customers to completely pause an AKS cluster, saving time and cost. The stop/start feature keeps cluster configurations in place and customers can pick up where they left off without reconfiguring the clusters.
                            
## Virtual Machines
### Configuration Recommendations
* Have you performed a recent review of SKUs that could benefit from Reserved Instances for 1 or 3 years or more?
  > Purchasing reserved instances is a way to reduce Azure costs for workloads with stable usage. You have to manage utilization: if it’s too low then you are paying for resources that are not being used. One advice is to keep RI instances simple and not trying to have too much management overhead that has to be factored in as well as part of the cost.
                            
* Are you using Burstable (B) series VM sizes for VMs that are idle most of the time and have high usage for a certain period of time?
  > The B-series VMs are ideal for workloads that do not need the full performance of the CPU continuously (like web servers, proof of concepts, small databases and development build environments).
                            
* Do you shut down the VM instances which are not in use?
  > Use the Start/Stop VMs during off-hours feature of virtual machines to minimize waste. There are many configuration options to schedule start the stop times. The feature is suitable as a low-cost automation option. Azure Advisor evaluates virtual machines based on CPU and network utilization over a time period and recommends actions like shut down or resize instances.
                            
* Are Spot VMs being used?
  > Spot VMs are ideal for workloads that can be interrupted, such as highly parallel batch processing jobs. These VMs take advantage of the surplus capacity in Azure at a lower cost. They're also well suited for experimenting, development and testing of large-scale solutions.
                            
* Are you using PaaS as an alternative to virtual machines?
  > When you use the PaaS model, operational and maintenance costs are included in the pricing and in some cases can be cheaper than managing VMs on your own.
                            
* Use Zone to Zone disaster recovery for virtual machines.
  > (in preview as of 11/2020) Replicate, failover and failback your business-critical virtual machines within the same region with zones. Ideal for those that have complicated networking infrastructure and want to avoid the cost and complexity of recreating it in a secondary region.
                            
# Storage
        
## Storage Accounts
### Design Considerations
* Are you periodically disposing or cleaning up unused storage resources (e.g. unattached disks, old snapshots)?
  > Unused storage resources can incur cost and its good idea to regularly perform cleanup to reduce cost.
                            
* Azure Blob access time tracking and access time-based lifecycle management
  > (in preview as of 11/2020) Minimize your storage cost automatically by setting up a policy based on last access time to: cost-effective backup storage options. Transition your data from a hotter access tier to a cooler access tier (hot to cool, cool to archive, or hot to archive) if there is no access for a period. Delete your data if there is no access for an extended period.
                            
### Configuration Recommendations
* Are you saving by reserving capacity for data for block blob storage?
  > Money can be saved by reserving capacity for block blob and for Azure Data Lake Storage gen 2 data in standard storage account when customer commits to 1 or 3 years reservation.
                            
* Are you organizing data into access tiers?
  > You can reduce cost by placing blob data into the most cost-effective access tier. Place frequently accessed data in hot tier, less frequent in cold or archive tier. Use Premium storage for workloads with high transaction volumes or ones where latency is critical.
                            
* Are you using lifecycle policy to move data between access tiers?
  > Lifecycle management policy periodically moves data between tiers. Policies can move data based on rules that specified by the user. For example, you might create rules that move blobs to the archive tier if that blob has not been modified in 90 days. Unused data can be also completely removed using a policy. By creating policies that adjust the access tier of your data, you can design the least expensive storage options for your need. 
                            
## Disks
### Design Considerations
* Are you leveraging shared disk for workload such SQL server failover cluster instance (FCI), file server for general use (IW workload) and SAP ASCS/SCS?
  > You can leverage shared disks (in preview as of 11/2020) to enable cost-effective clustering instead of setting up own shared disks via S2D (Storage Spaces Direct). Sample workloads that would benefit from shared disks are: SQL Server Failover Cluster Instances (FCI), Scale-out File Server (SoFS), File Server for General Use (IW workload) and SAP ASCS/SCS.
                            
* Are you using selective disk backup and restore for Azure VMs?
  > Using the selective disks backup and restore functionality, you can back up a subset of the data disks in a VM. This provides an efficient and cost-effective solution for your backup and restore needs.
                            
### Configuration Recommendations
* Are you using Premium disks (P30 &amp; above)?
  > Premium Disks (P30 & above) can be reserved (1 or 3 years) at discounted price.
                            
* Are you utilizing bursting for P20 and below disks for workload such as batch jobs, workload which handle traffic spikes, and for improving OS boot time?
  > Azure Disks offer variety of SKUs and sizes to satisfy different workload requirements. Some of the more recent features could help further optimize cost-performance of existing disk use cases. Firstly, you can leverage disk bursting for Premium (disks P20 and below). Example scenarios that could benefit from this feature are improving OS boot time, handling batch jobs and handling traffic spikes. 
                            
* For database workloads, are you configuring data and log files on different disks?
  > You can optimize IaaS DB workload performance by configuring system, data and log files to be on different disk SKUs (leveraging Premium Disks for data and Ultra Disks for logs satisfies most production scenarios). Further, Ultra Disk cost/performance can be optimized by taking advantage of the ability to configure capacity, IOPS and throughput independently; and ability to dynamically configure these attributes. Example workloads are SQL on IaaS, Cassandra DB, Maria DB, MySql and Mongo DB on IaaS.
                            
# Networking
        
## Network Virtual Appliances (NVA)
### Design Considerations
* There&#39;s a difference between using a third party app (NVA) an Azure native service (Firewall or Application Gateway).
  - With managed PaaS services such as Azure Firewall or Application Gateway, Microsoft handles the management of the service and the underlying infrastructure. Using NVAs, which usually have to be deployed on VMs (IaaS), the customer has to handle the management operations (such as patching and updating) of that VM and the appliance on top. Managing 3rd party services also usually mean using specific vendor tools - integration can become difficult.
                            
  - Some of the costs for networking services are not obvious for customers.
                            
## Network Connectivity
### Design Considerations
* Running cost of services (services are metered – pay for service itself and consumption on service)
  - VNet Peering Cost – consider the consequences of putting all resources in a single VNet to save costs, because it also prevents the infrastructure from growing. The VNet can eventually reach a point where new resources don&#39;t fit anymore.
                            
  - For 2 VNets that are peered and private endpoint is used – only the private endpoint access is billed and not VNet peering cost.
                            
  - Azure Firewall is also metered (pay for instance and for usage) – the same applies to load balancers.
                            
### Configuration Recommendations
* Select SKU for service so that it does the job required and that allows the customer to grow as the workload evolves.
  - **Load balancer**: 2 SKUs (Basic – free and Standard – paid). We recommend Standard because it has richer capabilities (outbound rules, granular network security config, monitoring, etc.), provides SLA and can be deployed in Availability Zones. Capabilities in Basic are limited.
                            
  - **App Gateway**: Basic or V2.
                            
  - **Gateways**: limit throughput, performance, etc.
                            
  - **DDoS Standard**: Depending on the workload and usage patterns, Standard can provide useful protection. Otherwise you can use the Basic (i.e. for small customers).
                            
## IP Addresses
### Configuration Recommendations
* PIPs (Public IPs) are free until used. Static PIPs are paid even when not assigned to resources.
  > There's a difference in billing for regular and static public IP addresses. There should be a process to look for orphan network interface cards (NICs) and PIPs that are not being used in production and non-production.
                            