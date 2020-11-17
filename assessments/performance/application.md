# Application Performance Efficiency

# Navigation Menu
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
    - [Design Patterns](#Design-Patterns)
    - [Transactional](#Transactional)
    - [Disaster Planning](#Disaster-Planning)
  - [Capacity Planning](#Capacity-Planning)
    - [Usage Prediction](#Usage-Prediction)
    - [Service SKU](#Service-SKU)
    - [Disaster Recovery](#Disaster-Recovery)
    - [Data](#Data)
  - [Performance Testing](#Performance-Testing)
    - [Resource Planning](#Resource-Planning)
    - [Tooling](#Tooling)
    - [Test Coverage](#Test-Coverage)
    - [Benchmarking](#Benchmarking)
    - [Performance Planning](#Performance-Planning)
    - [Service SKU](#Service-SKU)
    - [Load Capacity](#Load-Capacity)
    - [Design Efficiency](#Design-Efficiency)
    - [DevOps](#DevOps)
  - [Monitoring](#Monitoring)
    - [Logging](#Logging)
    - [Performance Targets](#Performance-Targets)
    - [Dependencies](#Dependencies)
    - [Modelling](#Modelling)
  - [Troubleshooting](#Troubleshooting)
    - [Data](#Data)
    - [Process](#Process)
    - [Network](#Network)



# Application Assessment Checklist
## Application Design
    
### Design Patterns
            
* Was your application architected based on prescribed architecture from the Azure Architecture Center or a Cloud Design Pattern?


* When designing the application were latency, request time, and payload size primary design considerations?


* When designing the application, were you able to choose the data source during the design phase?


* Would you consider the application design to be a microservice architecture?


### Transactional
            
* Can you measure the efficiency of the connections that are created to external services and datastores?


* Is the application stateless?


* Is the application code written using asynchronous patterns?


* Does your application batch requests?


* Does your application have any long running tasks or workflow scenarios?


* Does your application have retry logic in response to a failure?


### Disaster Planning
            
* Is you application deployed to multiple regions?


* Is your app deployed to multiple Availability Zones?


## Capacity Planning
    
### Usage Prediction
            
* Will your application be exposed to yearly or monthly major peak loads?


### Service SKU
            
* Do you know your scale limits and what is most likely to be your bottleneck?


* Is the required peak capacity aligned with the subscription quotas and limits?


### Disaster Recovery
            
* If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?


### Data
            
* Do you know the growth rate of your data?


* Has caching and queuing been considered to handle varying load?


## Performance Testing
    
### Resource Planning
            
* Does your team recognize the importance of performance testing?


* Have you identified the required human and environment resources needed to created performance tests?


### Tooling
            
* When executing performance tests, are you conducting full, production scale end-to-end testing?


* Are you currently using tools for conducting performance testing?


### Test Coverage
            
* Is your application currently covered 80% or more with performance tests?


* Do your performance tests cover all layers (frontend, services, and database) of the application?


* Is more than 80% of the application responsible for responding to a single user request?


### Benchmarking
            
* Have you identified goals of baselines for application performance?


* If you have set goals, are they specific to device and/or connectivity type?


* Do you have goals defined for establishing an initial connection to a service?


* Do you have goals defined for a complete page load?


* Do you have goals defined for an API (service) endpoint complete response?


* Do you have goals defined for server response times?


* Do you have goals for latency between systems/microservices?


* Do you have goals for database queries?


### Performance Planning
            
* Are you able to predict application usage?


* If usage is predictable, is it based on a specific time of day, day of week, or season (e.g. holiday shopping season)?


* Do you understand the typical load for your application?


### Service SKU
            
* Have you identified all services being utilized in Azure (and on-premises) that need to be measured?


* Are you confident that the correct SKUs and configurations have been applied to the services in order to support your anticipated loads?


* Based on the current expected application and environment usage, do the purchased SKUs and the current configuration(s) support expected usage?


* For disaster recovery and failover, should a region become inoperable, does the paired region support the same SKUs and configurations as the primary region?


* Should a region fail, have you tested the amount of time it would take for users to fail over the the paired region?


* Should a region fail, can the paired region handle the additional load?


* Given your determination of acceptable operational margin and response under increased levels of load, have you configured the environments to scale out to sustain performance efficiency?


* Have you correctly configured the environments to scale back in for the purpose of saving costs when load is under certain performance thresholds?


### Load Capacity
            
* Are you familiar with the differences between performance testing, load testing, and stress testing?


* As compared to general performance testing, are you currently conducting load testing?


* As compared to general performance testing, are you currently conducting stress testing?


* Have you completed a stress test on the application?


* Have you determined an acceptable operational margin between your peak utilization and the application's maximum load?


* Do you have a record of metrics for performance tests under standard loads?


* Given your determination of acceptable operational margin and response under standard levels of load, has the environment been configured adequately?


* Does your application response well under sustained increases in levels of load?


### Design Efficiency
            
* Are you using page caching?


* Are you using data caching?


* Are you using any CDNs?


* Are you using SSL offloading?


* Are you using authentication/token verification offloading?


* Are you using database replicas and data partitioning?


* Do you known when you have reached acceptable efficiency?


### DevOps
            
* Do you have performance validation stages in your deploy and build pipelines?


## Monitoring
    
### Logging
            
* Do you have detailed instrumentation throughout the application's code?


* Are application logs collected from all application environments?


* Are application events correlated across all application components?


* Are log messages captured in a structured format?


* Are you currently using a log aggregation technology to collect logs and metrics from Azure resources?


* Are you collection Azure Activity Logs within the log aggregation tool?


* Is resource-level monitoring available for critical internal dependencies?


* Are logs and metrics available for critical internal dependencies?


* Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?


* Are application-level events automatically correlated with performance metrics to quantify the current application state?


* Is the transaction flow data used to generate application/service maps?


* Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?


### Performance Targets
            
* Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?


* Is the end-to-end performance of critical system flows monitored?


### Dependencies
            
* Are critical external dependencies monitored?


### Modelling
            
* Is a health model used to qualify what 'healthy' and 'unhealthy' states represent for the application?


* Are critical system flows used to inform the health model?


* Can the health model determine if the application is performing at expected performance targets?


* Are long-term trends analyzed to predict performance issues before they occur?


## Troubleshooting
    
### Data
            
* Does the application require heavy database utilization?


### Process
            
* Does the application currently exhibit high CPU and/or memory utilization?


* Does the application response times increase while not using all the CPU or memory allocated to the system regardless of the load?


* Do you profile the application code with any profiling tools?


### Network
            
* Do you profile the network with any traffic capturing tools?

