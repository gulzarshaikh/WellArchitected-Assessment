# Data
## Azure Cache for Redis

### Design Considerations

#### Service Level Agreements

* 99.9% SLA for the cache endpoints and internet gateway will have connectivity

* SLA only covers Standard and Premium tier caches. Basic tier is not covered.

[Azure Cache for Redis Service Level Agreements](https://azure.microsoft.com/en-us/support/legal/sla/cache/v1_0)

### Configuration Recommendations

- Redis (REmote DIctionary Server) is an in memory cache for key value pairs and has High Availablity (HA) by default (except Basic tier). There are three tiers for Azure Cache for Redis: Basic, Standard and Premium.

* Basic - (Not recommended for production workloads) Single node, multiple sizes, ideal for development/test and non-critical workloads. The basic tier has no SLA.
* Standard - A replicated cache in a two node Primary/Secondary configuration managed by Microsoft, with a high availability SLA.
* Premium - Includes all standard-tier features and including the following:
    - Faster hardware/performance compared to Basic or Standard-tier
    - Larger cache size (up to 120GB)
    - [Data persistence](https://redis.io/topics/persistence): RDB (Redis Database File) and AOF (Append Only File)
    - VNET support
    - [Clustering](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-premium-clustering)
    - Geo-Replication - a secondary cache is in another region and replicates data from the primary for disaster recovery. To failover to the secondary, the caches need to be unlinked manually and then the secondary is availabile for writes. The application writing to Redis will need to be updated with the secondary's cache connection string.
    - Availability Zones (preview) - Deploy the cache and replicas across availability zones. Note: By default, each deployment will have one replica per shard. Persistence, clustering, and geo-replication are all disabled at this time with deployments that have more than one replica. Your nodes will be distributed evenly across all zones. You should have a replica count >= number of zones.
    - Import/Export

* Schedule Updates - Schedule the days and times that Redis Server updates will be applied to the cache. This does not include Azure updates or updates to the VM operating System. 

* Monitor the cache and/or set alerts for exceptions, high CPU, high memory usage, server load and evicted keys for insights when to scale the cache. If the cache needs to be scaled, understanding when to scale is important because it will increase CPU during the scaling event to migrate data.

* Deploying the cache inside of a VNET gives the customer more control over the traffic that is able to connect to the cache. Make sure that the subnet has sufficient address space available to deploy the cache nodes and shards (cluster).

* Configure Data Persistence to save a copy of the cache to Azure Storage or use Geo-Replication depending on the business requirement.
    - Data Persistence - if the master and replica reboot, the data will automatically be loaded from the storage account
    - Geo-Replication - the secondary cache needs to be unlinked from the primary. The secondary will now become the primary and be able to receive 'writes'.

* Use one static or singleton implementation of the connection multiplexer to Redis and follow the [best practices guide](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices).

* Review the [How to administer Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-administration#reboot) to understand how data loss can occur with cache reboots and how to test the application for resiliency.

### Supporting Source Artefacts

#### Azure Resource Graph

* Query to identify Redis Instances that are not on the premium tier:

```kql
Resources 
| where type == 'microsoft.cache/redis'
| where properties.sku.name != 'Premium'
```

# the end