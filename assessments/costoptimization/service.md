# Service Cost Optimization

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Compute](#Compute)
    - [Azure App Service](#Azure-App-Service)
    - [Azure Kubernetes Service (AKS)](#Azure-Kubernetes-Service-AKS)
    - [Virtual Machines](#Virtual-Machines)
  - [Data](#Data)
    - [Azure SQL Database](#Azure-SQL-Database)
    - [Azure Database For PostgreSQL](#Azure-Database-For-PostgreSQL)
    - [Azure Database For MySQL](#Azure-Database-For-MySQL)
  - [Storage](#Storage)
    - [Storage Accounts](#Storage-Accounts)
    - [Disks](#Disks)
  - [Networking](#Networking)
    - [Network Virtual Appliances (NVA)](#Network-Virtual-Appliances-NVA)
    - [Network Connectivity](#Network-Connectivity)
    - [API Management](#API-Management)
    - [IP Addresses](#IP-Addresses)
  - [Monitoring](#Monitoring)
    - [Log Analytics Workspace](#Log-Analytics-Workspace)
    - [Application Insights](#Application-Insights)
# Compute
        
## Azure App Service
### Configuration Recommendations
* Consider the cost savings of using App Service Premium v3 plan over the Premium v2 plan.
  > The App Service Premium (v3) Plan has a 20% discount versus comparable Pv2 configurations. Reserved Instance commitment (1Y, 3Y, Dev/Test) discounts are available for App Services running in the Premium v3 plan.
                            
* Consider Basic or Free tier for non-production usage.
  > For non-prod App Service Plans, if used, consider scaling them to Basic or Free Tier and scale up as needed and scale down when not in use – e.g. during Load Test exercise or based on the capabilities provided (custom domain, SSL, etc.).
                            
* Always use a scale-out and scale-in rule combination.
  > If you use only one part of the combination, autoscale will only take action in a single direction (scale out, or in) until it reaches the maximum, or minimum instance counts of defined in the profile. This is not optimal, ideally you want your resource to scale up at times of high usage to ensure availability. Similarly, at times of low usage you want your resource to scale down, so you can realize cost savings.
                            
* Understand the behavior of multiple scaling rules in a profile.
  > There are cases where you may have to set multiple rules in a profile. On scale-out, autoscale runs if 'any' rule is met. On scale-in, autoscale require 'all' rules to be met.
                            
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
* Perform a review of SKUs that could benefit from Reserved Instances for 1 or 3 years or more.
  > Purchasing reserved instances is a way to reduce Azure costs for workloads with stable usage. You have to manage utilization: if it’s too low then you are paying for resources that are not being used. One advice is to keep RI instances simple and not trying to have too much management overhead that has to be factored in as well as part of the cost.
                            
* Consider using Burstable (B) series VM sizes for VMs that are idle most of the time and have high usage for a certain period of time.
  > The B-series VMs are ideal for workloads that do not need the full performance of the CPU continuously (like web servers, proof of concepts, small databases and development build environments).
                            
* Shut down VM instances which are not in use.
  > Use the Start/Stop VMs during off-hours feature of virtual machines to minimize waste. There are many configuration options to schedule start the stop times. The feature is suitable as a low-cost automation option. Azure Advisor evaluates virtual machines based on CPU and network utilization over a time period and recommends actions like shut down or resize instances.
                            
* Use Spot VMs when appropriate.
  > Spot VMs are ideal for workloads that can be interrupted, such as highly parallel batch processing jobs. These VMs take advantage of the surplus capacity in Azure at a lower cost. They're also well suited for experimenting, development and testing of large-scale solutions.
                            
* Consider PaaS as an alternative to virtual machines.
  > When you use the PaaS model, operational and maintenance costs are included in the pricing and in some cases can be cheaper than managing VMs on your own.
                            
* Use Zone to Zone disaster recovery for virtual machines.
  > (in preview as of 11/2020) Replicate, failover and failback your business-critical virtual machines within the same region with zones. Ideal for those that have complicated networking infrastructure and want to avoid the cost and complexity of recreating it in a secondary region.
                            
# Data
        
## Azure SQL Database
### Configuration Recommendations
* Consider Reserved Capacity for Azure SQL Database.
  > Compute costs associated with Azure SQL Database can be reduced by using [Reservation Discount](https://docs.microsoft.com/azure/cost-management-billing/reservations/understand-reservation-charges). Once the total compute capacity and performance tier for Azure SQL databases in a region is determined, this information can be used to reserve the capacity. The reservation can span 1 or 3 years. Significant cost optimization can be realized with this commitment. Refer to documentation on [Save costs for resources with reserved capacity](https://docs.microsoft.com/azure/azure-sql/database/reserved-capacity-overview) for more details.
                            
* Evaluate Azure SQL Database Serverless.
  > Consider using Azure SQL Database Serverless over Provisioned Computing Tier. Serverless is a compute tier for single databases that automatically scales compute based on workload demand and bills for the amount of compute used per second. The serverless compute tier also automatically pauses databases during inactive periods when only storage is billed and automatically resumes databases when activity returns. Azure SQL Database serverless is 'not for all' scenarios, but if you have a database that is not always heavily used and if you have periods of complete inactivity, this is a very interesting solution that can you guarantee performances and that can help you on saving a lot of costs.
                            
* Evaluate DTU Usage.
  > Evaluate the DTU usage for all Databases and determine if they have been sized/provisioned correctly. For non-prod Databases, consider using Basic Tier or S0 and configure the DTUs accordingly, as applicable. The DTUs can be scaled on demand e.g. when running a load test, etc.
                            
* Optimize Queries.
  > Optimize the queries/Tables/DB using [Query Performance Insights](https://docs.microsoft.com/en-us/azure/azure-sql/database/query-performance-insight-use) and [Performance Recommendations](https://docs.microsoft.com/en-us/azure/azure-sql/database/database-advisor-find-recommendations-portal) to help reduce the resource consumption and arrive at appropriate configuration 
                            
## Azure Database For PostgreSQL
### Design Considerations
* Consider using Flexible Server SKU for non-production workloads.
  > Flexible servers provide better cost optimization controls with ability to stop/start your server and burstable compute tier that is ideal for workloads that do not need full compute capacity continuously.
                            
* The cloud native design of the Single Server service allows it to support 99.99% of availability eliminating the cost of passive hot standby.
* Hyperscale (Citus) provides dynamic scalability without the cost of manual sharding with low application re-architecture required.
  > Distributing table rows across multiple PostgreSQL servers is a key technique for scalable queries in Hyperscale (Citus). Together, multiple nodes can hold more data than a traditional database, and in many cases can use worker CPUs in parallel to execute queries potentially decreasing the database costs. Follow this [Shard data on worker nodes tutorial](https://docs.microsoft.com/en-us/azure/postgresql/tutorial-hyperscale-shard) to practice this potential savings architecture pattern.
                            
* Plan your RPO (Recovery Point Objective) according to your operation level requirement.
  > There is no additional charge for backup storage for up to 100% of your total provisioned server storage. Additional consumption of backup storage will be charged in GB/month.
                            
* Take advantage of the scaling capabilities of Azure Database for PostgreSQL to decrease consumption cost whenever possible.
  > This [how to article](https://techcommunity.microsoft.com/t5/azure-database-support-blog/how-to-auto-scale-an-azure-database-for-mysql-postgresql/ba-p/369177) from Microsoft Support covers the automation process using runbooks to scale up and down your database as needed.
                            
### Configuration Recommendations
* Consider Reserved Capacity for Azure Database for PostgreSQL Single Server and Hyperscale (Citus).
  > Compute costs associated with Azure Database For PostgreSQL [Single Server Reservation Discount](https://docs.microsoft.com/en-us/azure/postgresql/concept-reserved-pricing) and [Hyperscale (Citus) Reservation Discount](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-reserved-pricing). Once the total compute capacity and performance tier for Azure Database for PostgreSQL in a region is determined, this information can be used to reserve the capacity. The reservation can span 1 or 3 years. You can realize significant cost optimization with this commitment.
                            
* Choose the appropriate server size for your workload.
  > Configuration options: [Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers), [Flexible Server](https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage), [Hyperscale (Citus)](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-configuration-options).
                            
## Azure Database For MySQL
### Design Considerations
* Consider using Flexible Server SKU for non-production workloads.
  > Flexible servers provide better cost optimization controls with ability to stop/start your server and burstable compute tier that is ideal for workloads that do not need full compute capacity continuously.
                            
* The cloud native design of the Single Server service allows it to support 99.99% of availability eliminating the cost of passive hot standby.
* Plan your RPO (Recovery Point Objective) according to your operation level requirement.
  > There is no additional charge for backup storage for up to 100% of your total provisioned server storage. Additional consumption of backup storage will be charged in GB/month.
                            
* Take advantage of the scaling capabilities of Azure Database for MySQL to decrease consumption cost whenever possible.
  > This [how to article](https://techcommunity.microsoft.com/t5/azure-database-support-blog/how-to-auto-scale-an-azure-database-for-mysql-postgresql/ba-p/369177) from Microsoft Support covers the automation process using runbooks to scale up and down your database as needed.
                            
### Configuration Recommendations
* Consider Reserved Capacity for Azure Database for MySQL Single Server.
  > Compute costs associated with Azure Database For MySQL [Single Server Reservation Discount](https://docs.microsoft.com/en-us/azure/mysql/concept-reserved-pricing). Once the total compute capacity and performance tier for Azure Database for MySQL in a region is determined, this information can be used to reserve the capacity. The reservation can span 1 or 3 years. You can realize significant cost optimization with this commitment.
                            
* Choose the appropriate server size for your workload.
  > Configuration options: [Single Server](https://docs.microsoft.com/en-us/azure/mysql/concepts-pricing-tiers), [Flexible Server](https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-compute-storage).
                            
# Storage
        
## Storage Accounts
### Design Considerations
* Periodically dispose and clean up unused storage resources (e.g. unattached disks, old snapshots).
  > Unused storage resources can incur cost and its good idea to regularly perform cleanup to reduce cost.
                            
* Azure Blob access time tracking and access time-based lifecycle management
  > (in preview as of 11/2020) Minimize your storage cost automatically by setting up a policy based on last access time to: cost-effective backup storage options. Transition your data from a hotter access tier to a cooler access tier (hot to cool, cool to archive, or hot to archive) if there is no access for a period. Delete your data if there is no access for an extended period.
                            
### Configuration Recommendations
* Consider cost savings of reserving data capacity for block blob storage.
  > Money can be saved by reserving capacity for block blob and for Azure Data Lake Storage gen 2 data in standard storage account when customer commits to 1 or 3 years reservation.
                            
* Organize data into access tiers.
  > You can reduce cost by placing blob data into the most cost-effective access tier. Place frequently accessed data in hot tier, less frequent in cold or archive tier. Use Premium storage for workloads with high transaction volumes or ones where latency is critical.
                            
* Use lifecycle policy to move data between access tiers.
  > Lifecycle management policy periodically moves data between tiers. Policies can move data based on rules that specified by the user. For example, you might create rules that move blobs to the archive tier if that blob has not been modified in 90 days. Unused data can be also completely removed using a policy. By creating policies that adjust the access tier of your data, you can design the least expensive storage options for your need. 
                            
## Disks
### Design Considerations
* Leverage shared disk for workload such SQL server failover cluster instance (FCI), file server for general use (IW workload) and SAP ASCS/SCS.
  > You can leverage shared disks (in preview as of 11/2020) to enable cost-effective clustering instead of setting up own shared disks via S2D (Storage Spaces Direct). Sample workloads that would benefit from shared disks are: SQL Server Failover Cluster Instances (FCI), Scale-out File Server (SoFS), File Server for General Use (IW workload) and SAP ASCS/SCS.
                            
* Consider selective disk backup and restore for Azure VMs.
  > Using the selective disks backup and restore functionality, you can back up a subset of the data disks in a VM. This provides an efficient and cost-effective solution for your backup and restore needs.
                            
### Configuration Recommendations
* Consider using Premium disks (P30 &amp; above).
  > Premium Disks (P30 & above) can be reserved (1 or 3 years) at discounted price.
                            
* Utilize bursting for P20 and below disks for workloads such as batch jobs, workloads which handle traffic spikes, and for improving OS boot time.
  > Azure Disks offer variety of SKUs and sizes to satisfy different workload requirements. Some of the more recent features could help further optimize cost-performance of existing disk use cases. Firstly, you can leverage disk bursting for Premium (disks P20 and below). Example scenarios that could benefit from this feature are improving OS boot time, handling batch jobs and handling traffic spikes. 
                            
* Configure data and log files on different disks for database workloads.
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
                            
## API Management
### Configuration Recommendations
* Consider which features are needed all the time.
  > Consider switching between Basic, Standard and Premium tiers. If a workload does not need features available in higher tier then consider switching to a lower tier. As an example, a workload may need just 1GB of cache during off-peak period compared to 5GB of cache during peak period. Costs associated with such a workload can be significantly reduced by switching from Premium to Standard tier during off-peak period and back to Premium tier during peak period. This process can be automated as a job using [Set-AzApiManagement](https://docs.microsoft.com/powershell/module/az.apimanagement/set-azapimanagement?view=azps-5.4.0) cmdlet. Refer to [documentation](https://azure.microsoft.com/pricing/details/api-management/) on features available in different APIM tiers.
                            
* Configure autoscaling where appropriate.
  > Consider scaling up or down API Management instance to control costs. API Management can be [configured](https://docs.microsoft.com/azure/api-management/api-management-howto-autoscale) with Autoscale based on a either a metric or a specific count. APIM costs depend upon no. of units which determines throughput in requests per seconds (RPS). An auto-scaled APIM instance switches between scale units appropriate for RPS numbers during a specific time window. Auto-scaling helps in achieving balance between cost optimization and performance.
                            
## IP Addresses
### Configuration Recommendations
* PIPs (Public IPs) are free until used. Static PIPs are paid even when not assigned to resources.
  > There's a difference in billing for regular and static public IP addresses. There should be a process to look for orphan network interface cards (NICs) and PIPs that are not being used in production and non-production.
                            
# Monitoring
        
## Log Analytics Workspace
### Design Considerations
* Consider how long to retain data on Log Analytics.
  > Data ingested into Log Analytics workspace can be retained at no additional charge up to first 31 days. Consider general aspects to configure the [Log Analytics workspace level default retention](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#workspace-level-default-retention) and specific needs to configure data [retention by data type](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#retention-by-data-type), that can be as low as 4 days. Example: Usually, performance data doens't need to be retained longer, instead, security logs may need to be retained longer.
                            
* Consider exporting data for long term retention and/or auditing purposes.
  > Data retained for audit purposes may be exported to a cheaper storage type. Refer to [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/logs-data-export?tabs=portal) about Log Analytics workspace data export.
                            
### Configuration Recommendations
* Consider adoption of Commitment Tiers pricing model to the Log Analytics workspace.
  > The usage of Commitment Tiers enable saving as much as 30% compared to Pay-As-You-Go pricing. Commitment Tiers starts at 100 GB/day and any usage above the reservation level is billed at the Pay-As-You-Go rate. Refer to [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#changing-pricing-tier) about how to change Log Analytics pricing tier to Capacity Reservations. Use the [Log Analytics Usage and Estimated Costs page](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#understand-your-usage-and-estimate-costs) to analyze data usage and calculate possible Commitment Tiers. *Note: Azure Defender (Security Center) billing includes 500 MB/node/day allocation against the [security data types](https://docs.microsoft.com/en-us/azure/azure-monitor/reference/tables/tables-category#security). Take it into consideration when calculating Commitment Tiers*
                            
* Evaluate usage of daily cap to limit the daily ingestion for your workspace.
  > Daily cap is intended to be used as a way to manage an unexpected increase in data volume from your managed resources, or when you want to limit unplanned charges for your workspace. Use care with this configuration as it may implicate in some data not being written to Log Analytics workspace if the daily cap is reached, impacting services whose functionality may depend on up-to-date data being available in the workspace. Refer to [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#set-the-daily-cap) about how to set the Daily Cap.
                            
* Understand Log Analytics workspace usage.
  > When Log Analytics workspace usage is higher than expected, consider the [troubleshooting](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#troubleshooting-why-usage-is-higher-than-expected) guide and the [Understanding ingested data volume](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#understanding-ingested-data-volume) guide to understand the unexpected behavior.
                            
* Evaluate possible data ingestion volume reducing.
  > Refer to this [Tips for reducing data volume](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#tips-for-reducing-data-volume) documentation to help configure data ingestion properly.
                            
## Application Insights
### Design Considerations
* Consider use sampling to reduce the amount of telemetry that&#39;s sent.
  > Sampling is a feature in Application Insights and it is a recommended way to reduce telemetry traffic, data and storage costs. Refer to this [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/sampling) about sampling.
                            
* Consider turning off collection for unneeded modules.
  > On the configuration files you can enable or disable Telemetry Modules and initializers for tracking telemetry from your applications. Refer to this [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/configuration-with-applicationinsights-config) about how to manage Application Insights packages.
                            
* Consider limit tracing of AJAX calls.
  > AJAX calls can be limited to reduce costs. Refer to this [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/javascript#configuration) that explains the fields and its configurations.
                            
### Configuration Recommendations
* Evaluate usage of daily cap to limit the daily ingestion for your workspace.
  > Daily cap is intended to be used as a way to manage an unexpected increase in data volume or when you want to limit unplanned charges for your workspace. Use care with this configuration as it may implicate in some data not being writen on Log Analytics workspace if the daily cap is reached, impacting services whose functionality may depend on up-to-date data being available in the workspace. Refer to [documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/pricing#set-the-daily-cap) about how to set the Daily Cap in Application Insights. *Note: If you have a workspace-based Application Insights, the recommendation is to use workspace's daily cap to limit ingestion and costs instead of the cap in Application Insights*
                            