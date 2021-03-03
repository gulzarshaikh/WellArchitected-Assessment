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
    - [Data](#Data)
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


  _Starting with a prescribed, proven architecture may help with alleviating some basic performance issues. It is suggested to check out the Azure Architecture Center and Cloud Design Patterns to determine if the application's architecture is similar._
* When designing the application, which of the following design considerations were considered? (Latency between layers, Request time, Payload sizes, High Availability)


  _When designing a new application or reviewing and existing one, there are three concepts to think about: 1) reducing latency; 2) reducing total request time; and, 3) reducing overall payload sizes. Implementing any combination of these concepts can dramatically improve overall application performance._
* When designing the application, were you able to choose the data source during the design phase?


  _Your application will most likely require more than one type of datastore depending on business requirements. Choosing the right mix and correct implementation is extremely important for optimizing application performance._
    - What datasources are you using?


      _Your application will most likely require more than one type of datastore depending on business requirements. Choosing the right mix and correct implementation is extremely important for optimizing application performance._

* Would you consider the application design to be a microservice architecture?


  _As compared to a monolithic architecture--an application that is tightly coupled with synchronous communication and often a single datastore--microservices leverage concepts such as asynchronous communication, service discovery, various resiliency strategies, and each service has its own datastore._
    - Are your microservices using independent datastores or sharing the same datastore (e.g. a single database server that has multiple databases/tables is still considered a single datastore)?


      _One of the fundamental concepts of a microservice is that it uses its own datastore. Not only does this help with resiliency, but can also improve performance by reducing load on a single source, thus eliminating bottlenecks due to long-running queries._

    - Are the datastores&#39; access restricted only to their respective service or can multiple microservices access the datastores directly?



### Transactional
            
* Can you measure the efficiency of the connections that are created to external services and datastores?


  _It is important to be able to determine the total time for a round-robin between your application and its data source. This enables you to establish a baseline in which to measure against future changes along with calculating the cumulative effect of a single request to a service. It may help to leverage connection pooling or a connection multiplexer in order to reduce the need to create and close connections each time you need to communicate with a service. This helps to reduce the CPU overhead on the server that maintains all of those connections. When communicating with a service using an HttpClient or similar type of object, always create this object once and reuse it for subsequent requests. Ways to instantiate an object once can use the Singleton pattern of Dependency Injection or storing the object in a static variable._
* Is the application stateless?


  _If the application is stateful, meaning that data or state will be stored locally in the instance of the application, it may increase performance by enabling session affinity. When session affinity is enabled, subsequent requests to the application will be directed to the same server that processed the initial request. If session affinity is not enabled, subsequent requests would be directed to the next available server depending on the load balancing rules, and the subsequent server would be required to reload all applicable data._
    - If the application was to fail or recycle, could the data be refreshed for the user with minimal effort and/or time?



* Is the application code written using asynchronous patterns?


  _When calling a service, this is a request that will take time to complete (return). The time for the caller to receive a response could range from milliseconds to minutes and during that time the thread is held by the process until the response comes back (or an exception happens). This means that, while the thread was waiting for a response, it was blocked from processing any other requests. Using an asynchronous pattern, the thread is released and available to process other requests while the initial request is still being processed in the background._
* Does your application batch requests?


  _Creating a lot of individual requests has a tremendous amount of overhead for the producer and consumer of those requests. This will also increase bandwidth as certain elements of data are included in each request. If an API supports batching, you can batch all of the requests (the batch size varies by API and payload size) into a single request. The server will receive the one batched request and process all of the contained, individual requests. This better leverages the server's resources so that the requests can be processed much faster._
* Does your application have any long-running tasks or workflow scenarios?


  _You can offload a long-running task or a multi-step workflow process to a separate, dedicated workers instead of using the application's resources to handle it. To handle this scenario, you can add tasks (messages) to a queue and have a dedicated worker listening to the queue to pick up a message and process it._
    - Where possible, have tasks been configured to execute in parallel?


      _There are many ways to handle long-running tasks. The common way is to use parallel execution threads and leverage WaitAll or WaitAny process waits. However, using these methods introduce blocking on threads and can have large, detrimental performance hits on applications, especially distributed applications. Additionally, the blocks can prevent the execution of other tasks that may not have a dependency on the data at the current code position. Instead, it is better to follow asynchronous models and leverage message queuing for long-running tasks. In this pattern, tasks publish and subscribe to data on the queue and tasks can execute as soon as the data is made available._

    - Are long-running tasks and workflows leveraging durable functions?



* How does your application have retry logic in response to a failure?


  _When your application encounters an exception or given component (service) of your application fails, the application needs to handle the failure/exception gracefully and log the exception in order to mitigate the problem in the future._
### Disaster Planning
            
* Is you application deployed to multiple regions?


  _Leveraging multiple regions is not only important for disaster recovery and high-availability. Multi-region deployment is also ideal for performance improvements as your application scales. Additionally, user requests can be directed to their closest region which reduces latency between the user and your service._
    - Were regions chosen based on location and proximity to your users or based on resource types that were available?


      _Not only is it important to utilize regions close to your audience, but it is equally important to choose regions that offer the SKUs that will support your future growth. Not all regions share the same parity when it comes to product SKUs. Plan your growth, then choose regions that will support those plans._

    - Are the regions paired?


      _Paired regions have built-in support for high-availability of certain resources. Not all resources support paired regions, but those that do ensure that your application remains operational. The operational level may be reduced (e.g. read-only of certain resources), but still operational nonetheless. Make sure your multi-region application is deployed to paired regions and that your operational level is understood in the case that (a) service(s) in your primary region are in a failed state._

    - Have you ensured that both (all) regions in use have the same performance and scale SKUs that are currently leveraged in the primary region?


      _When planning for scale and efficiency, it is important that regions are not only paired, but homogenous in their service offerings. Additionally, you should make sure that, if one region fails, the second region can scale appropriately to sufficiently handle the influx of additional user requests._

* Is your app deployed to multiple Availability Zones?


  _Many regions have availability zones with them. This is to prevent against inoperability of your application in the case of a partial region failure. While this configuration is utilized for high-availability, you should also be aware of the impact it may have on your application should a service encounter an issue within one zone.  Furthermore, if an individual zone fails, but your application is deployed to multiple zones within the same region, it can prevent your application from having to communicate with a service in your secondary region. Both scenarios are important when considering performance efficiency and latency of requests._
## Capacity Planning
    
### Usage Prediction
            
* Will your application be exposed to yearly or monthly heavy, peak loads?


  _Major events like Black Friday, Singles Day, End-of-month reporting or marketing pushes can create abnormal load on your application and require additional resources. Understanding the upticks in demand can help you proactively scale so that customers/users experience little to no performance degradation._
    - Are you able to reasonably predict when these peaks will occur?



    - Are you able to accurately predict the amount of load your application will experience during these peaks?



### Service SKU
            
* Do you know your scale limits and what is most likely to be your bottleneck?


  _An application is made up of many different components, services, and frameworks within both infrastructure and application code. The design and choices in each area will incur unique limits and scale options. Knowing how your application behaves under different kinds of load allows you to be better prepared. It can also help you recognize which individual services to scale, if necessary, versus scaling your entire infrastructure. This can help increase performance efficiency without sacrificing costs._
* Is the required peak capacity aligned with the subscription quotas and limits?


  _Limitless scale requires dedicated design and one of the important design considerations is the limits and quotas of Azure subscriptions. Some services are almost limitless, others require more planning. Some services have 'soft' limits that can be increased by contacting support._
### Disaster Recovery
            
* If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?


  _Quotas and limits typically apply at the region level and, therefore, the needed capacity should also be planned for the secondary region._
### Data
            
* Do you know the growth rate of your data?


  _Your solution might work great in the first week or month, but what happens when data just keeps increasing? Will the solution slow down, or will it even break at a particular threshold? Planning for data growth, data retention, and archiving is essential in capacity planning. Without adequately planning capacity for your datastores, performance will be negatively affected._
## Performance Testing
    
### Resource Planning
            
* How does your team perceive the importance of performance testing?


  _It is critical that your team understands the importance of performance testing. Additionally, the team should be committed to providing the necessary time and resources for adequately executing performance testing proven practices._
* Have you identified the required human and environment resources needed to create performance tests?


  _Successfully implementing meaningful performance tests requires a number of resources. If is not just a single developer or QA Analyst running some tests on their local machine. Instead, performance tests need a test environment (also known as a test bed) that tests can be executed against without interfering with production environments and data. Performance testing requires input and commitment from developers, architects, database administrators, and network administrators. In short, solid performance testing is a team responsibility.<br /><br />Additionally, to run scaled tests, a machine with enough resources (e.g. memory, processors, network connections, etc.) needs to be made available. While this machine can be located within a data center or on-premises, it is often advantageous to perform performance testing from instances located from multiple geographies. This better simulates what an end-user can expect._
### Tooling
            
* Are you currently using tools for conducting performance testing?


  _There are various performance testing tools available for DevOps. Some tools like JMeter only perform testing against endpoints and tests HTTP statuses. Other tools like K6 and Selenium can perform tests that also check data quality and variations. Application Insights, while not necessarily designed to test server load, can test the performance of an application within the user's browser. When determining what testing tools you will implement, it is always important to remember what type of performance testing you are attempting to execute._
* What types of performance testing are you currently executing (or looking to execute) against your application?


  _Most people think of load testing as the only form of performance testing. However, there are different types of performance testing--load testing, stress testing, API testing, client-side/browser testing, etc. It is important that you understand and are able to articulate the different types of tests, along with their pro's and con's. With a solid understanding shared amongst your team members, you can identify a path forward to leveraging existing tests or the creation of new tests._
### Test Coverage
            
* How much of your application is currently tested for performance?


  _Performance testing can be initiated within the client's browser, full integration testing (e.g. testing the response of multiple endpoints required to comprise the data of a single page), or testing the performance of a single API endpoint. As stated under the previous question, having a clear vision of the areas you are attempting to test will help identify the tools you will need._
* Considering the three major application layers of frontend, services, and database, what parts of the application are being tested for performance?


* How much of the application is involved in serving an immediate, single request?


  _When understanding load and demands on the application, it is necessary to understand how the application is architected--whether monolithic, n-Tier, or microservice-based--and then understand how load is distributed across the application. This is crucial for focusing on the testing of individual components and identifying bottlenecks._
### Benchmarking
            
* Have you identified goals or baselines for application performance?


  _There are many types of goals when determining baselines for application performance. Perhaps baselines center around a certain number of visitors within a given time period, the time it takes to render a page, type  required for executing a stored procedure, or a desired number of transactions if your site conducts some type of e-commerce. It is important to identify and maintain a shared understanding of these baselines so that you can architect a system that meets them.<br /><br />Baselines can vary based on types of connections or platforms that a user may leverage for accessing the application. It may be important to establish baselines that address the diversity of connections, platforms, and other elements (like time of day, or weekday versus weekend)._
* Are your goals based on device and/or connectivity type, or are they considered the same across the board?


  _It is important to identify how users are connecting to your application. Are they primarily connecting via a wired connection, wireless, or by using a mobile device? Additionally, you should seek to understand the targeted device types, whether that a mobile device, a tablet or laptop/desktop PC. All of these factors play a major role in performance as it relates to data transmission (e.g. sending data to and receiving data from a remote service) and processing (e.g. displaying that data to a user via a graph, table, etc.). For example, if the site has a large amount of widgets, it may be advantageous to create an experience that is optimized for mobile devices since these devices tend to have smaller processors and less memory._
* Do you have goals defined for establishing an initial connection to a service?


  _It would be helpful to determine a goal that is based upon from when the connection reaches the server, to when the service spins/cycles up, to providing a response. By establishing this baseline, you and your customer can determine if adequate resources have been assigned to the machine. These resources can included, but are not limited to processors, RAM, and disk IOPS. Finally, creating rules for &quot;Always-On&quot; or properly configuring idle time-outs (e.g. IIS, containers, etc.) will be especially helpful for optimizing response times._
* Do you have goals defined for a complete page load?


  _What are your goals for a completed page load? When formulating this metric, it is important to note the varying thresholds that can be deemed acceptable. Some companies--whose primary audience is internal and are salary-based--may base their thresholds on the user's mental capacity to sit at the application screen. Other customers that have service-related users (i.e. users who are paid for performance) may base their thresholds on the ability to keep the user working as fast as possible (mental state is not the primary motivator) because increased productivity typically increases revenue.<br /><br />Typically, most industry standards target page load times to 1-2 seconds, while 3-5 seconds is &quot;acceptable,&quot; and more than 5 is unacceptable. If applications are being hosted in Azure App Services, there are a number of tactics that can increase page performance._
* What are your goals for a completed page load?


* How often are you achieving your page load goals?


* Do you have goals defined for an API (service) endpoint complete response?


  _Data-centric applications are comprised of pulling data from various API endpoints. For a single page, this could mean many server requests. The page is only as fast as the slowest endpoint. It is important for you to test the performance of your APIs to quickly identify bottlenecks in the application that impede user experience. As an example, if a dashboard page requires data from ten API endpoints and one of those endpoints requires 6.0 seconds to return data while the remaining endpoints only a few hundred milliseconds, this is a good indicator that the single endpoint needs to be inspected and targeted for optimization._
* What are your goals for a complete response from a given API?


* How often are you achieving your API response goals?


* Do you have goals defined for server response times?


  _Similar to previous questions regarding the initial connection to a service, you will also want to understand how long it takes for the server to receive, process, and then return data. This round-trip can also help ensure that enough hardware resources have been assigned to the environment. Additionally, it is possible to identify &quot;noisy neighbors&quot;--applications running on the same disk (typically in a virtualized environment) or sharing the same network--that are consuming available resources. Finally, another bottleneck in many environments is traffic on a network that is being shared with a data store (e.g. SQL). If an application server and its database server share the same network as general traffic, then the overall performance of the application can be greatly affected._
* What are your goals for a full server response?


* How often are you achieving your server response goals?


* Do you have goals for latency between systems/microservices?


  _Performance should not only be monitored within the application itself, but response times between service tiers should also be noted. While this is important for n-Tier applications, it is especially crucial for microservices. Most microservices leverage some type of pub-sub architecture where communication is asynchronous. However, validation for sending and receiving messages should still take place. In these instances, understanding the routing and latency between services is imperative to improving performance._
* What are your goals for a complete response from a given microservice?


* How often are you achieving your API response goals?


* Do you have goals for database queries?


  _Ensuring the data operations are optimized is a key component to any performance assessment. It is important to understand what data is being queried and when. The data life-cycle, if abused, can adversely affect the performance of any application (or microservice). Confirm that a database administrator (a data architect is preferred) is part of the assessment as they will have the necessary tools for monitoring and optimizing a database and its queries._
* What are your goals for an individual database query execution and response?


* How often are you achieving your goals for database query execution?


### Performance Planning
            
* Are you able to predict general application usage?


  _It is important to understand application and environment usage. The customer may have an understanding of certain seasons or incidents that increase user load (e.g. a weather service being hit by users facing a storm, an e-commerce site during the holiday season)._
* If typical usage is predictable, are your predictions based on time of day, day of week, or season (e.g. holiday shopping season)?


  _Dig deeper and document predictable periods. By doing so, you can leverage resources like Azure Automation and Autoscale to proactively scale the application and its underlying environment._
* Do you understand why your application responds to its typical load in the ways that it does?


  _Identifying a typical load helps you determine realistic expectations for performance testing. A &quot;typical load&quot; can be measured in individual users, web requests, user sessions, or transactions. When documenting typical loads, also ensure that all predictable periods have typical loads documented._
### Service SKU
            
* Have you identified all services being utilized in Azure (and on-prem) that need to be measured?


  _Your assessment may already be complete, but it helps to identify some currently utilized systems to being measuring load capacity. Once these environments have been identified, created benchmarks should include these systems._
* Are you confident that the correct SKUs and configurations have been applied to the services in order to support your anticipated loads?


  _Understand which SKUs you have purchased and ensure that they are the correct size. Additionally, ensure you understand the configuration of those SKUs (e.g. auto-scale settings for Application Gateways and App Services)._
* Based on the previous the previous group of questions (expected application and environment usage), do the purchased SKUs and the current configuration support expected usage?


  _Once the purchased SKUs have been identified, determine if they purchased resources have the capabilities of supporting anticipated load. For example, if you expect the load to require 30 instances of an App Service, yet you are currently leveraging a Standard App Service Plan SKU (maximum of 10 instances supported), then you will need to upgrade your App Service Plan in order to accommodate the anticipated load._
* For disaster recovery and failover, should a region become inoperable, does the paired region support the same SKU levels and configurations as the primary region?


  _If your paired region does not support the same SKU levels, then either an alternative pair of regions need to be chosen of the application needs to be re-architected for the necessary load. This ensures that if a single region should fail, the operating region is capable of supporting the anticipated, combined load._
* Should a region fail, have you tested the amount of time it would take for users to fail over to the paired region?


  _You should be fully aware of how long it would take for your customers to be re-routed from a failed region. Typically, a planned, test failover can help determine how long would be required to fully scale to support the redirected load. Based on the recovery time (e.g. time required to scale), you can adequately plan for unforeseen outages._
* Should a region fail, can the paired region handle the additional load?


  _Proper Disaster Recovery planning ensures that the end-user experiences very little, if any, degradation in service. This includes you planning for a percentage of maximum utilization in each region in the case that a single region fails and all load is placed on the remaining available region(s). This means that you should architect a solution that has enough margin to handle some immediate redirection of requests while providing enough runway to scale efficiently._
* Should a region fail, how long would it take for the secondary region to scale in order to handle the additional load?


* Given your determination of acceptable operational margin and response under increased levels of load, have you configured the environment to scale out to sustain performance efficiency?


  _Determine if the environment is rightly configured to scale in order to handle increased loads. (e.g. Does the environment scale effectively at certain times of day or at specific performance counters?) If you have identified specific times in which load increases (e.g. holidays, marketing drives, etc.), then the environment can be configured to proactively scale prior to the actual increase in load._
* Have you correctly configured the environment to scale back in for the purpose of saving costs when load is under certain performance thresholds?


  _Ensure that a rule has been configured to scale the environment back down once load settles below set thresholds. This will ensure that you are not over provisioning and unnecessarily increasing operational costs._
### Load Capacity
            
* Considering the three types of testing--performance, load, and stress--which have you performed on your application?


  _In general, the concept of &quot;performance testing&quot; includes three smaller, definitive categories--performance testing, load testing, and stress testing. Most customers, however, equate load testing to performance testing. It is important to understand the differences and being able to articulate them._
* Have you completed a stress test on the application?


  _A stress test determines the maximum number of users an application can handle at a given time before the application begins to deteriorate. It is important to determine the maximum to understand what kind of load the current environment can adequately support without buckling._
* Have you determined an acceptable operational margin between your peak utilization and the applications maximum load?


  _What is the maximum taxation you wish to place on resources? Factors such as memory, CPU, and disk IOPS should all be considered. Once a stress test has been performed resulting in the maximum supported load and an operational margin has been chosen, it is best to determine an operational threshold. Then, environment scaling (automatic or manual) can be performed once the threshold has been reached._
* What are the metrics of a performance test under standard loads?


  _A true performance test measures how the application performs under a standard load. It is critical to understand how your application operates--including CPU utilization and memory consumption--under a standard load. First, this will help you plan accordingly as you anticipate future user growth. Second, this gives you a baseline for performance regression testing._
* Given your determination of acceptable operational margin and response under standard levels of load, has the environment been configured adequately?


  _Determine if the environment is rightly configured to handle &quot;standard&quot; loads. (e.g. Are the correct SKUs selected based on desired margins?) Over allocation can unnecessarily increase costs and maintenance; under allocation can result in poor user experience._
* How well does the application respond under fluctuating increased levels of loads?


  _Typically, there is a stair step model to determining load capacity. The stair step model considers various levels of users for various time periods. Running a load test helps to determine how well the application scales as load increases on the application._
### Design Efficiency
            
* Are you using any caching mechanisms?


  _Use caching whenever possible, whether it is client-side caching, view caching, or data caching. Caching can also be configured on the browser, the server, or on an appliance in-between (e.g. Azure Frontdoor). Incorporating caching can help reduce latency and server taxation by eliminating repetitive class to microservices, APIs, and data stores._
* Of the following static and page caching mechanisms, which are you currently using?<br />- Browser<br />- Azure CDN<br />- Azure Front Door<br />- Other


  _There are various types of caching mechanisms that can be configured with a web page and its components. Such examples include expiry dates, tags, modification dates, content, or other variances like IP addresses or encoding types._
* Which of the following are you using for data caching?<br />- Azure Redis Cache<br />- IIS Caching Server<br />- SQL Caching Server<br />- Disk<br />- Other solution


  _Azure Cache for Redis is a preferred solution for data caching as it improves performance by storing data in memory instead of on disk like SQL Server. Certain development frameworks like .NET also have mechanisms for caching data at the server level._
* Are you using any CDNs?


  _CDNs store static files in locations that are typically geographically closer to the user than the data center. This increases overall application performance as latency for delivery and downloading these artifacts is reduced._
* Are you using SSL offloading?


  _SSL offloading places the SSL certificate at an appliance that sits in front of the web server, instead of on the web server itself. This is beneficial for two reasons. First, the verification of the SSL certificate is conducted by the appliance instead of the web server, which reduces the taxation on the server. Second, SSL offloading increases operational efficiency as it can often eliminate the need to manage certificates across microservices._
* Are you using authentication/token verification offloading?


  _Like SSL offloading, authentication/token verification offloading on an appliance can reduce taxation on the server. Additionally, authentication verification offloading can greatly reduce development complication as developers no longer need to worry with the complications of SAML or OAuth tokens and, instead, can focus specifically on the business logic._
* Are you using database replicas and data partitioning?


  _Database replicas and data partitioning can improve application performance by providing multiple copies of the data and/or reducing the taxation of database operations. Both mechanisms involve conversations and planning between developers and database administrators._
* How do you know when you have reached acceptable efficiency?


  _There is almost no limit to how much an application can be performance-tuned. How do you know when you have tuned an application enough? It really comes down to the 80/20 rule--generally, 80% of the application can be optimized by focusing on just 20%. While you can continue optimizing certain elements of the application, after optimizing the initial 20%, a company typically sees a diminishing return on any further optimization. The question the customer must answer is how much of the remaining 80% of the application is worth optimizing for the business. In other words, how much will optimizing the remaining 80% help the business reach its goals (e.g. customer acquisition/retention, sales, etc.)? The business must determine their own realistic definition of &quot;acceptable.&quot;_
### DevOps
            
* Do you have performance validation stages in your deploy and build pipelines?


  _Do you have performance testing integrated with your CI/CD pipelines? Testing in your pipelines can ensure that performance regressions and adverse affects of new development can be caught as early as possible._
### Data
            
* Has caching and queuing been considered to handle varying load?


  _Caching and queuing offers ways to handle heavy load in read and write scenarios, respectively. However, their usage must be carefully considered as this may mean that data is not fresh and writes to not happen instantly. This could create a scenario of eventual consistency and stale data._
## Monitoring
    
### Logging
            
* Do you have detailed instrumentation in the application code?


  _Instrumentation of your code allows precise detection of underperforming pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code. Application Performance Monitoring (APM) tools, such as Application Insights, should be used to manage the performance and availability of the application, along with aggregating application level logs and events for subsequent interpretation._
* Are application logs collected from different application environments?


  _Application logs and events should be collected across all major environments to support the end-to-end application lifecycle. Furthermore, corresponding log entries across the application should capture a correlation ID for their respective transactions._
* Are application events correlated across all application components?


  _Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made, you can see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a given transaction that has flowed through the system.<br /><br />Log events coming from different application components or different component tiers of the application should be correlated to build end-to-end transaction flows. For instance, this is often achieved by using consistent correlation IDs transferred between components within a transaction._
* Are log messages captured in a structured format?


  _Application events should be captured as a structured data type with machine-readable data points rather than unstructured string types. Structured data can easily be indexed and searched, and reporting can be greatly simplified._
* Which log aggregation technology is used to collect logs and metrics from Azure resources?


  _Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as 3rd-party appliances such as firewalls and Anti-Malware solutions used in the application. For instance, if Azure Event Hub is used, the Diagnostics Settings should be configured to push logs and metrics to the data sink._
* Are you collecting Azure Activity Logs within the log aggregation tool?


  _Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. Such information is extremely useful for the interpretation and troubleshooting of issues as it provides transparency around configuration changes that can be mapped to adverse performance events._
* Is resource-level monitoring enforced throughout the application?


  _All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Azure Policy should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service._
* Are logs and metrics available for critical internal dependencies?


  _To be able to build a robust application health model, it is vital that visibility into the operational state of critical, internal dependencies, such as a shared network virtual appliance (NVA) or Express Route connection, be achieved._
* Are application- and resource-level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?


  _To build a robust application health model, it is vital that application- and resource-level data be correlated and evaluated together to optimize the detection of issues and the troubleshooting of those detected issues._
* Are application level events automatically correlated with performance metrics to quantify the current application state?


  _The overall performance can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults._
* Is the transaction flow data used to generate application/service maps?


  _An Application Map can help you identify performance bottlenecks of failure hotspots across components of a distributed application._
* Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?


  _Clear retention times should be defined to allow for suitable, historic analysis, but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis._
### Performance Targets
            
* Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?


  _Application-level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates or processing steps, etc._
* Is the end-to-end performance of critical system flows monitored?


  _It should be possible to correlate application log events across critical system flows, such as user logins, to fully assess the health of key scenarios in the context of targets and non-functional requirements (NFRs)._
### Dependencies
            
* Are critical external dependencies monitored?


  _Critical, external dependencies, such as an API service, should be monitored to ensure operational visibility of performance. For instance, a probe could be used to measure the latency of an external API._
### Modelling
            
* Is a health model used to qualify what 'healthy' and 'unhealthy' states represent for the application?


  _A holistic application health model should be used to quantify what &quot;healthy&quot; and &quot;unhealthy&quot; states represent across all application components. It is highly recommended that a &quot;traffic light&quot; model be used to indicate green/healthy state when key, non-functional requirements and targets are fully satisfied and resources are optimally utilized (e.g. 95% of requests are processed in <= 500ms with AKS node utilization at x%, etc.)._
* Are critical system flows used to inform the health model?


  _The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow._
* Can the health model determine if the application is performing at expected performance targets?


  _The health model should have the ability to evaluate application performance as a part of the application's overall health state._
* Are long-term trends analyzed to predict performance issues before they occur?


  _Analytics can and should be performed across long-term operational data to help inform on the history of application performance and detect if there have been any regressions. For instance, if the average response times have been slowly increasing over time and getting closer to maximum target._
## Troubleshooting
    
### Data
            
* Does the application spend a lot of time in the database?


  _Applications that spend a lot of execution time in the database layers can benefit from a database tuning analysis. This analysis will only focus on the data tier components and may require special resources such as DBA's to tune queries, indexes, execution plans, and more._
### Process
            
* Does the application have high CPU or memory utilization?


  _If the application has very high CPU or memory utilization, then consider scaling the application either horizontal or vertical. Scaling horizontal to more compute resources will spread the load across more machines. This will, however, increase the network complexity as there will be more machines to support the system. Scaling the application vertical to a larger machine this is optimized for higher CPU or memory workloads may also be considered. Profiling the application code can be useful to find code structures that may be sub-optimal and replace them with better-optimized code. These decisions are a balance of several factors that can include cost, system complexity, and time to implement._
* Have you identified the length of time it takes before CPU or memory increases?


* How long does it take for system resources to return to &quot;normal?&quot;


* Does the application response times increase while not using all the CPU or memory allocated to the system regardless of the load?


  _When the system response times increase without any increase in the CPU or memory, this is an indicator that there is a resource that is time-blocked. This can mean many things such as thread sleep, connection wait, message queueing, etc. The list can go on. The bottom line is there is something that is consuming time but not compute resources. Try to locate these issues with tracing data that can deliver time spans for each layer of the application architecture that is correlated to an application transaction._
* Have you identified the length of time it takes before response times increase?


* How long does it take for response times to return to &quot;normal?&quot;


* Do you profile the application code with any profiling tools?


  _Application profiling will involve tooling like Visual Studio Performance Profile, AQTime, dotTrace, and others. These tools will give you in-depth analysis of individual code paths._
### Network
            
* Do you profile the network with any traffic capturing tools?


  _Network capture tooling can capture the network traffic and dive deeper into the interactions at the network layer that may affect your application due to network configuration and/or other network traffic issues._