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
    - [Architecture](#Architecture)
# Compute
        
## Azure App Service
### Configuration Recommendations
* Are you saving costs by using the App Service Premium (V3) Plan over the Premium (PV2) Plan?
  > The App Service Premium (V3) Plan has a 20% discount versus comparable PV2 configurations. Reserved Instance commitment (1Y, 3Y, Dev/Test) discounts are avialable for App Services running in the Premium V3 plan.
                            
## Azure Kubernetes Service (AKS)
### Configuration Recommendations
* Enable [cluster autoscaler](https://docs.microsoft.com/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
  > This ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.
                            
  - Consider using [Azure Spot VMs](https://docs.microsoft.com/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions. For example, workloads such as batch processing jobs, development and testing environments, and large compute workloads may be good candidates to be scheduled on a spot node pool.
    > Using spot VMs for nodes with your AKS cluster allows you to take advantage of unutilized capacity in Azure at a significant cost savings.
                                
                            
  - Separate workloads into different node pools and consider scaling user node pools to zero.
    > Unlike System node pools that always require running nodes, User node pools allow you to scale to 0.
                                
                            
## Virtual Machines
### Configuration Recommendations
* Have you performed a recent review of SKUs that could benefit from Reserved Instances for 1 or 3 years or more?
  > Purchasing reserved instances is a simple way to reduce Azure costs. You have to manage utilization if it’s too low then you are paying for resourcing that is not being used. One advice is to keep RI instances simple and not trying to have too much management overhead that has to be factored in as well as part of the cost.
                            
* Are you using Burstable (B) series VM sizes for VMs that are idle most of the time and have high usage for a certain period of time?
  > The B-series VMs are ideal for workloads that do not need the full performance of the CPU continuously, like web servers, proof of concepts, small databases and development build environments and provide a cost savings.
                            
* Do you shut down the underutilized VM instances?
  > Use the Start/Stop VMs during off-hours feature of virtual machines to minimize waste. There are many configuration options to schedule start the stop times. The feature is suitable as a low-cost automation option. Azure Advisor evaluates virtual machines based on CPU and network utilization over a time period. Then, the recommended actions are shut down or resize instances and cost saving with both actions.
                            
* Are Spot VMs being used?
  > Spot VMs are ideal for workloads that can be interrupted, such as highly parallel batch processing jobs. These VMs take advantage of the surplus capacity in Azure at a lower cost. They're also well suited for experimental, development, and testing of large-scale solutions.
                            
* Are you using PaaS as an alternative to buying VMs?
  > When you use the PaaS model, operational and maintenance costs are included in the pricing and in some cases can be cheaper than managing VMs on your own.
                            
* Zone to Zone disaster recovery for Virtual Machines
  > (in preview as of 11/2020) Replicate, failover and failback your business-critical virtual machines within the same region with zones. Ideal for those that have complicated networking infrastructure and want to avoid the cost and complexity of recreating it in a secondary region.
                            
* Start/Stop in Azure Kubernetes Services (AKS)
  > (in preview as of 11/2020) The AKS Stop/Start cluster feature now in public preview allows AKS customers to completely pause an AKS cluster, saving time and cost. The stop/start feature keeps cluster configurations in place and customers can pick up where they left off without reconfiguring the clusters.
                            
# Storage
        
## Storage Accounts
### Configuration Recommendations
* Are you saving by reserving capacity for data for block blob storage?
  > Money can be saved by reserving capacity for block bob and for Azure Data Lake Storage gen 2 data in standard storage account when customer commits to 1- or 3-years reservation.
                            
* Are you organizing data into access tiers?
  > You can reduce cost by placing blob data into the most cost-effective access tier. Choose from 4 access tiers that are designed to optimize your cost around data use. Place frequent access data in hot tier, less frequent in cold or archive tier.  Use Premium for high TPS workloads or ones where latency is critical.
                            
* Are you using lifecycle policy to move data between access tiers?
  > Using lifecycle management policy periodically move data between tiers and that save money. Policies can move data based on rules that you specify. For example, you might create rules that move blobs to the archive tier if that blob has not been modified in 90 days. Unused data can be also completely removed using a policy. By creating policies that adjust the access tier of your data, you can design the least expensive storage options for your need. 
                            
## Disks
### Design Considerations
* Are you leveraging shared disk for workload such SQL server failover cluster instance (FCI), file server for general use (IW workload) and SAP ASCS/SCS?
  > You can leverage shared disks (in preview as of 11/2020) to enable cost-effective clustering instead of setting their own shared disks via S2D (Storage Spaces Direct). Sample workloads that would benefit from shared disks are: SQL Server Failover Cluster Instances (FCI), Scale-out File Server (SoFS), File Server for General Use (IW workload) and SAP ASCS/SCS.
                            
### Configuration Recommendations
* Are you using Premium disks (P30 &amp; above)? 
  > Premium Disk (P30 & above) can be reserved (1 or 3 years) at discounted price.
                            
* Are you utilizing bursting for P20 and below disks for workload such as batch jobs, workload which handle traffic spikes, and for improving OS boot time?
  > Azure Disks offer variety of SKUs and sizes to satisfy different workload requirements. Some of the more recent features could help further optimize cost-performance of existing Disk use cases. Firstly, you can leverage disk bursting for Premium (Disks P20 and below). Example scenarios that could benefit from this feature are improving OS boot time, handling batch jobs and handling traffic spikes. 
                            
* For database workload, are you configuring data and log files on different disks?
  > You can optimize IaaS DB workload performance by configuring their system, data and log files to be on different Disk SKUs (leveraging Premium Disks for data and Ultra Disks for logs satisfies most production scenarios). Further, you can optimize Ultra Disk cost/performance by taking advantage of the ability to configure capacity, IOPS and throughput independently; and ability to dynamically configure these attributes. Example workloads are SQL on IaaS, Cassandra DB, Maria DB, MySql and Mongo DB on IaaS. Learn more about Ultra Disks.
                            
# Networking
        
## Architecture
### Design Considerations
* Are you using a third party app (NVA) or Azure Native Service (Firewall or App Gateway)?
  - With Azure we manage the service. With NVAs have to pay for human doing the work behind the scenes. For devops, have to use vendor’s tools – integration becomes difficult.
                            
  - Running costs that are present that customers also don’t see.
                            
  - Wherever possible use 1st party services rather than 3rd party services – get rid of hidden costs.
                            
* Running cost of services (services are metered – pay for service itself and consumption on service)
  - VNET Peering Cost – customers start putting everything in 1 VNET for example to save costs but that’s preventing them from growing because they will reach a point that they can’t fit everything in one VNET.
                            
  - If you have 2 VNETs that are peered and you want to access a private endpoint – you pay only for private endpoint access and not VNET peering cost.
                            
  - Azure Firewall is also metered (pay for instance and for usage) – same for load balancers.
                            
* Is there a process to look for orphan NIC, PIP that are not being used in production and non-production?
  > PIP are free unless you don’t use them – if they aren’t assigned to anything you will pay for it.
                            
### Configuration Recommendations
* Select SKU for service so that it does the job required and that allows the customer to grow as the workload evolves.
  - **Load balancer**: 2 SKUs (basic – free and standard – fee based). We recommend standard because that’s where the investments are going (outbound rules, granular network security config, monitoring, etc). Capabilities in basic are limited.
                            
  - **App Gateway**: Basic or V2.
                            
  - **Gateways**: limit throughput, performance, etc.
                            
  - **DDOS Standard**: gives protection for their workload types and how their patterns are. Otherwise you can use the basic (i.e. for small customers).
                            