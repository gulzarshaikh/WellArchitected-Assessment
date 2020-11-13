# Application Performance Efficiency

# Navigation Menu
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
  - [Capacity Planning](#Capacity-Planning)
  - [Performance Testing](#Performance-Testing)
    - [Understanding Testing](#Understanding-Testing)
    - [Testing Types and Tooling](#Testing-Types-and-Tooling)
    - [Identify Goals and Baselines for Performance](#Identify-Goals-and-Baselines-for-Performance)
    - [Expected Application and Environment Usage](#Expected-Application-and-Environment-Usage)
    - [Azure Service Limits](#Azure-Service-Limits)
    - [Performance Across Regions](#Performance-Across-Regions)
    - [Understanding Application Behavior Under Load](#Understanding-Application-Behavior-Under-Load)
    - [Performance Improvements](#Performance-Improvements)
    - [Performance Pipeline](#Performance-Pipeline)
  - [Monitoring](#Monitoring)
    - [Application-level Monitoring](#Application-level-Monitoring)
    - [Resource/Infrastructure-level Monitoring](#Resource/Infrastructure-level-Monitoring)
    - [Data Interpretation & Health Modelling](#Data-Interpretation-&-Health-Modelling)
  - [Troubleshooting](#Troubleshooting)


# Application Assessment Checklist
## Application Design

- Was your application architected based on prescribed architecture from the Azure Architecture Center or a Cloud Design Pattern? 
  > If the customer has started with an prescribed architecture, it may help in initiating the discovery process with some common understanding. If not, it may help to determine the possibility of refactoring customer's application.
  >
  >**Links:**
  >
  >- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
  >- [Cloud Design Patterns](https://docs.microsoft.com/en-us/azure/architecture/patterns/)


- When designing a new application or reviewing an existing one, there are three concepts to think about:
  - Reduce latency
  - Reduce request time
  - Reduce payload sizes

- [Choosing the right data store](https://docs.microsoft.com/azure/architecture/guide/technology-choices/data-store-overview)
  >Your application will most likely require more than one type of data store depending on your requirements and choosing the right mix is important for the application resiliency.

- Should you design this with a microservice architecture?
  >Microservices give you a lot of benefits, but the increased complexities of building and maintaining multiple applications *could* outweigh the benefits of using a microservice architecture. [Microservices Architecture](https://docs.microsoft.com/azure/architecture/microservices)

- Are you creating connections to services and data stores efficiently?
  >Using connection pooling or a connection multiplexer will reduce the need to create and close connections each time you need to talk to the service. This reduces the CPU overhead on the server that needs to maintain all of those connections. When talking to a service using an HttpClient or similar type of object, always create this object **once** and reuse it for subsequent requests. Ways to instantiate an object once can use the Singleton pattern with Dependency Injection or storing the object in a static variable.

- Is the application stateful or stateless?
  >If the application is stateful, meaning that data or state will be stored locally in the instance of the application, it may increase performance by enabling session affinity. When session affinity is enabled, subsequent requests to the application will be directed to the same server that processed the first request. If session affinity is not enabled, subsequent requests would be directed to the next available server depending on the load balancing rules.

- Is the application code written using an Asynchronous Pattern?
  >When calling a service, this is a request that will take time to complete (return). The time for the caller to receive a response could range from milliseconds to minutes and during that time the thread is held by the process until the response comes back (or an exception happens). This means that the time while the thread was waiting for a response it was not processing any other requests. Using an asynchronous pattern, the thread is released and available to process other requests while waiting for a response.

- Do you need to send a lot of requests in a short period of time?
  >Creating a lot of individual requests has an overhead to create the request and receive the response. If the API supports batching, you can batch all of the requests (the batch size varies by API and payload size) into one request. The server will receive the one batched request and process all of the individual requests. This is taking advantage of the server's resources to process the requests faster.

- Do you have a long running task or workflow scenario?
  >You can offload a long running task or a multi-step workflow process to a separate dedicated worker instead of using the application resources to handle it. To handle this scenario, you can add tasks (messages) to a queue (refer to the [messaging resiliency checklist](https://github.com/Azure/WellArchitected-ReliabilityAssessment/blob/main/docs/Service-Resiliency.md#Messaging) for choosing a technology) and have a dedicated worker listening to the queue to pick up a message and process it.

- How does your application handle exceptions and retries?
  >When your application encounters an exception, it needs to handle it gracefully and log the exception in order to mitigate the problem in the future. Review the [exception handling guidance](https://docs.microsoft.com/dotnet/standard/exceptions/best-practices-for-exceptions), [retry pattern guidance](https://docs.microsoft.com/azure/architecture/patterns/retry) and [unified logging guidance](https://docs.microsoft.com/azure/architecture/example-scenario/logging/unified-logging).

- Which region and availability zones are you deploying the application?
  >Deploying the entire application to the same region and one step further, deploying it to the same availability zone will give the application the lowest latency by having all of the parts of the system in the same data center.

## Capacity Planning

- Will your application be exposed to occasional major peak loads?
  >Major events like Black Friday, Singles Day, End-of-month reporting or marketing pushes can create abnormal load on your application and require additional resources.
  >
  >**Links:**
  >
  >- [Large scale event management](https://docs.microsoft.com/azure/architecture/framework/Scalability/capacity#large-scale-event-management)

- Do you know your scale limits and what is most likely to be your bottleneck?
  >An application is made up of many different components, services and frameworks within both infrastructure and application code. The design and choices in each area will incur unique limits and scale options. Knowing how your application behaves under different kinds of load allows you to be better prepared to handle it.
  >
  >**Links:**
  >
  >- [Autoscale guidance](https://docs.microsoft.com/azure/architecture/best-practices/auto-scaling)

- Is the required peak capacity aligned with the subscription quotas and limits?
  >Limitless scale requires dedicated design and one of the important design considerations is the limits and quotas of Azure subscriptions. Some services are almost limitless, others require more planning. Some services have default limits that can be increased by contacting support
  >
  >**Links:**
  >
  >- [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits)

- If you have a disaster recovery plan in another region, have you ensured you have the needed capacity quotas allocated?
  >Quotas and limits typically apply at region level, and therefore the needed capacity should also be planned for the DR region.

- Do you know the growth rate of your data?
  >Your solution might work great in the first week or month, but what happens when data just keeps increasing. Will the solution slow down, or will it even break at some threshold. Planning for data growth, data retention and archiving is essential in capacity planning.

- Has caching and queuing been considered to handle varying load?
  >Caching and queuing offers a way to handle heavy load in read and write scenarios respectively. However, it must be carefully considers as this also means that data is not fresh and writes do not happen instantly, so you could be dealing with eventual consistency and stale data.

## Performance Testing

### Understanding Testing

- How does your team perceive the importance of performance testing?
  > This is a fantastic question to gauge a pulse for the customer's perspective on testing, in general. Based on how the customer responds can be a good indicator of how likely they are to commit time and resources to adequately execute performance testing proven practices.
  >
  >**Links:**
  >
  >- [The Benefits of Performance Testing](https://testpoint.com.au/the-benefits-of-performance-testing/)
  >- [Business Benefits of Performance Testing](https://www.sitereq.com/post/business-benefits-of-performance-testing)

- Have you identified the required human and environment resources needed to create performance tests?
  > Successfully implementing meaningful performance tests requires a number of resources. It is not _just_ a single developer or QA Analyst running some tests on their local machine. Instead, performance tests need a test environment (also known as a test bed) that tests can be executed against without interfering with production environments and data. Performance testing requires input and commitment from developers, architects, database administrators, and network administrators. In short, solid performance testing is a _team_ responsibility.
  >
  >Additionally, to run scaled tests, a machine with enough resources (e.g. memory, processors, network connections, etc.) needs to be made available. While this machine can be located within a data center or on-premises, it is often advantageous to perform performance testing from instances located from multiple geographies. This better simulates what a end user can expect.
  >
  >**Links:**
  >
  >- [The Core Activities of Performance Testing](https://dzone.com/articles/the-core-activities-of-performance-testing)

### Testing Types and Tooling

- What types of performance testing are you currently executing (or looking to execute) against your application?
  > Most people think of load testing as the only form of performance testing. However, there are different types of performance testing&mdash;load testing, stress testing, API testing, client-side/browser testing, etc. It is important that you understand and articulate the different types of tests, along with their pro's and con's, to the customer. With a shared understanding, you can then identify a path forward to leveraging existing tests or the creation of new tests.
  >
  >**Links:**
  >
  >- [The Ultimate Guide to Performance Testing and Software Testing](https://stackify.com/ultimate-guide-performance-testing-and-software-testing/)

- What tools are you currently using for performance testing?
  > There are various performance testing tools available for DevOps. Some tools like _JMeter_ only perform testing against endpoints and tests HTTP statuses. Other tools like _K6_ and _Selenium_ can perform tests that also check data quality and variations. _Application Insights_, while not necessarily designed to test server load, can test the performance of an application within the user's browser. When determining what testing tools you will implement, it is always important to keep what _type_ of performance testing you are attempting to execute.
  >
  >**Links:**
  >
  >- [Web performance testing: 18 free open-source tools to consider](https://techbeacon.com/app-dev-testing/web-performance-testing-18-free-open-source-tools-consider)

- What areas of your application are you currently testing?
  > The customer may be testing performance with a few different approaches. Performance testing can be initiated within the client's browser, full integration testing (e.g. testing the response of multiple endpoints required to comprise the data of a single page), or testing the performance of a single API endpoint. As stated under the previous question, having a clear vision of the areas you are attempting to test will help identify the tools you will need.
  
### Identify Goals and Baselines for Performance

- Have you identified goals or baselines for application performance?
  > There are many types of goals when determining baselines for application performance. Perhaps baselines center around a certain number of visitors within a given time period, the time it takes to render a page, the type required for executing a stored procedure, or a desired number of transactions if your site conducts some type of e-commerce. It is important to identify and maintain a shared understanding of these baselines so that you can assist the customer in architecting a system meets them.
  >
  >Baselines can vary based on types of connections or platforms that a user may leverage for accessing the application. It may be important to establish baselines that address the diversity of connections, platforms, and other elements (like time of day, or weekday versus weekend). Based on how this question is answered, the following questions can be asked or presented to customer for additional discovery.
  >
  >**Links:**
  >
  >- [Driving a Simple Performance Baseline](https://www.apmdigest.com/driving-a-simple-performance-baseline)
  >- [Establishing a Performance Baseline](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2003/cc781394(v=ws.10))

- Are your goals based on device and/or connectivity type, or are they considered the same across the board?
  > It is important to identify _how_ users are connecting to your application. Are they primarily connecting via a wired connection, wireless, or by using a mobile device?  Additionally, you should seek to understand the targeted device types, whether that a mobile device, a tablet or laptop/desktop PC. All of these factors play a major role in performance as it relates to data transmission (e.g. sending data to and receiving data from a remote service) and processing (e.g. displaying that data to a user via a graph, table, etc.). For example, if the site has a large amount of widgets, it may be advantageous to create an experience that is optimized for mobile devices since these devices tend to have smaller processors and less memory.

- What are your goals for establishing an initial connection to a service?
  > It would be helpful to determine a goal that is based upon from when the connection reaches the server, to when the service spins/cycles up, to providing a response. By establishing this baseline, you and your customer can determine if adequate resources have been assigned to the machine. These resources can include, but are not limited to processors, RAM, and disk IOPS. Finally, creating rules for "Always-On" or properly configuring idle time-outs (e.g. IIS, containers, etc.) will be especially helpful for optimizing response times.
  >
  >**Links:**
  >
  >- [FAQ: How do I decrease the response time for the first request after idle time?](https://docs.microsoft.com/azure/app-service/faq-availability-performance-application-issues#how-do-i-decrease-the-response-time-for-the-first-request-after-idle-time)
  >- [Use IIS Application Initialization for keeping ASP.NET Apps alive](https://weblog.west-wind.com/posts/2013/oct/02/use-iis-application-initialization-for-keeping-aspnet-apps-alive)
  >- [Keep your Azure Web App Hydrated and Responsive](https://microsoft.github.io/AzureTipsAndTricks/blog/tip143.html)

- What are your goals for a complete page load?
  > What are the customer's goals for a completed page load? When formulating this metric, it is important to note the varying thresholds that can be deemed acceptable. Some customers&mdash;whose primary audience is internal and are salary-based&mdash;may base their thresholds on the user's mental capacity to sit at the application screen. Other customers that have service-related users (i.e. users who are paid for performance) may base their thresholds on the ability to keep the user working as fast as possible (mental state is not the primary motivator) because increased productivity typically increases revenue.
  >
  >Typically, most industry standards target page load times to 1-2 seconds, while 3-5 seconds is "acceptable", and more than 5 is unacceptable. If applications are being hosted in Azure App Services, there are a number of tactics that can increase page performance.
  >
  >**Links:**
  >
  >- [Nine Performance Tips for Azure App Services](https://www.telerik.com/blogs/nine-performance-tips-for-azure-app-services)

- What are your goals for an API endpoint complete response?
  > Data-centric applications are comprised of pulling data from various API endpoints. For a single page, this could mean _many_ server requests. The page is only as fast as the slowest endpoint. It is important for the customer to test the performance of their APIs to quickly identify bottlenecks in the application that impede user experience. As an example, if a dashboard page requires data from ten API endpoints and one of those endpoints requires 6.0 seconds to return data, while the remaining endpoints only a few hundred milliseconds, this is a good indicator that the single endpoint needs to be inspected and targeted for optimization.
  
- What are your goals for server response times?
  > Similar to above regarding the initial connection to a service, you will also want to understand how long it takes for the server to receive, process, and then return data.  This round-trip can also help ensure that enough hardware resources have assigned to the environment.  Additionally, it is possible to identify "noisy neighbors"&mdash;applications running on the same disk (typically in a virtualized environment) or sharing the same network&mdash;that are consuming available resources.  Finally, another bottleneck in many environments is traffic on a network that is being shared with a data repository (e.g. SQL). If an application server and its database server share the same network as general traffic, then the overall performance of the application can be greatly affected.

- What are your goals for latency between systems/microservices?
  > Performance should not only be monitored within the application itself, but response times between service tiers should also be noted. While this is important for n-Tier applications, it is especially crucial for microservices. Most microservices leverage some time of pub-sub architecture where communication is asynchronous. However, validation and sending and receiving messages should still take place. In these instances, understanding the routing and latency between services is imperative to increasing performance.
  >
  >**Links:**
  >
  >- [Fighting Service Latency in Microservices With Kubernetes](https://dzone.com/articles/fighting-service-latency-in-microservices-with-kub)
  >- [Best Practices for Microservice Performance](https://cloud.google.com/appengine/docs/standard/java/microservice-performance)
  >- [Common Performance Problems With Microservices](https://www.jrebel.com/blog/performance-problems-with-microservices)

- What are your goals for database queries?
  > Ensuring that data operations are optimized is a key component to any performance assessment. It is important to understand what data is being queried and when. The data life-cycle, if abused, can affect the performance of any application (or microservice). Confirm that a database administrator (a data architect is preferred) is part of the assessment as they will have the necessary tools for monitoring and optimizing a database and its queries.
  >
  >**Links:**
  >
  >- [Display an Actual (SQL) Execution Plan](https://docs.microsoft.com/sql/relational-databases/performance/display-an-actual-execution-plan)
  >- [15 SQL Server Performance Counters to Monitor in 2020](https://www.sentryone.com/blog/allenwhite/sql-server-performance-counters-to-monitor)

### Expected Application and Environment Usage

- Is application usage sporadic or predictable?
  > Is is important to understand application and environment usage. The customer may have an understanding of certain seasons or incidents that increase user load (e.g. a weather service being hit by users facing a storm, an e-commerce site during the holiday season).

- If usage is predictable, is it based on time of day, day of week, or season (e.g. holiday shopping season)?
  > Dig deeper and document predictable periods. By doing so, you can leverage resources like Azure Automation to proactively scale the application and its underlying environment.
  >
  >**Links:**
  >
  >- [Auto Scaling Azure Web Apps Vertically](http://samspoerle.com/auto-scaling-azure-web-apps-vertically-increase-size-and-decrease-size/)
  >- [Scale a web app manually using PowerShell](https://docs.microsoft.com/azure/app-service/scripts/powershell-scale-manual)

- What does a typical load look like?
  > Identifying a typical load helps the customer set realistic expectations for performance testing. A "typical load" can be measured in individual users, web requests, user sessions, or transactions. When documenting typical loads, ensure that all periods identified in the previous question have typical loads specified.

- How much of the application is involved in serving a single request?
  > When understanding load and demands on the application, it is necessary to understand how the application is architected&mdash;whether monolithic, n-Tier or microservice-based&mdash;and then understand how load is distributed across the application. This is crucial for focusing in on the testing of individual components and identifying bottlenecks.

### Azure Service Limits

- What services are being utilized in Azure (and on-prem) that need to be measured?
  > This assessment may already be complete, but it helps to identify some currently utilized systems to begin measuring load capacity. Once these environments have been identified, created benchmarks should include these systems.

- What SKUs for those services are currently purchased and how are they configured?
  > Understand which SKUs the customer has currently purchased. Additionally, seek to understand the the configuration of the SKUs (e.g. auto-scale settings for Application Gateways and App Services).

- Based on the previous section (expected application and environment usage), do the purchased SKUs and the current configuration support expected usage?
  > Once the purchased SKUs have been identified, determine if the purchased resources have the _capabilities_ of supporting anticipated load. For example, if the customer expects the load to require 30 instances of of an App Service, yet they are currently leverage a Standard App Service Plan SKU (maximum of 10 instances supported), then the customer will need to upgrade their App Service Plan in order to accomodate the anticipated load.
  >
  >**Links:**
  >
  >- [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits)
  >- [Troubleshooting resource limits and connection issues](https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-intermittent-outbound-connection-errors)


### Performance Across Regions

- For disaster recovery and failover, should a region become inoperable, does the paired region support the same SKU levels and configurations as the primary region?
  > If it doesn't, then either an alternative pair of regions need to be chosen or the application needs to be re-architected for the necessary load. This ensures that if a single region should fail, the operating region is capable of supporting the anticipated, combined load.
  >
  >**Links:**
  >
  >- [Products available by region](https://azure.microsoft.com/global-infrastructure/services/)
  >- [Regions and Availability Zones in Azure](https://docs.microsoft.com/azure/availability-zones/az-overview)

- Should a region fail, have you tested the amount of time it would take for users to fail over to the paired region?
  > Customers should know how long it would take for customers to be re-routed from a failed region. Typically, a planned, test failover can help determine how long would be required to fully scale to support the redirected load. Based on the recovery time (e.g. time required to scale), the customer can adequately plan for unforeseen outages.

- Should a region fail, can the paired region handle the additional load?
  > Proper DR planning ensures that the end user experiences very little, if any, degradation in service.  This includes the customer planning for a percentage of maximum utilization in each region in the case that a single region fails and all load is placed on the remaining available region(s). This means that a customer, should architect a solution that has enough margin to handle some immediate redirection of requests while providing enough runway to scale efficiently.
  >
  >**Links:**
  >
  >- [Run a web application in multiple Azure regions for high availability](https://docs.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/multi-region)
  >- [Improve scalability in an Azure web application](https://docs.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)
  >- [Azure to Azure disaster recovery architecture](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-architecture)

### Understanding Application Behavior Under Load

- What specific types of testing have you performed on your application?
  > In general, the concept of "performance testing" includes three smaller, definitive categories&mdash;performance testing, load testing, and stress testing. Most customers, however, equate load testing to performance testing. It is important to understand the differences and being able to articulate them.
  >
  >**Links:**
  >
  >- [Load Testing vs Stress Testing vs Performance Testing: Difference Discussed](https://www.guru99.com/performance-vs-load-vs-stress-testing.html)
  >- [Load Testing vs. Stress Testing](https://www.loadview-testing.com/load-testing-vs-stress-testing/)

- Have you completed a stress test on the application?
  > A stress test determines the _maximum_ number of users an application can handle at a given time before the application begins to deteriorate. It is important to determine this maximum to understand what kind of load the current environment can adequately support without buckling.
  >
  >**Links:**
  >
  >- [Stress Testing Guide For Beginners](https://www.softwaretestinghelp.com/stress-testing/)

- Have you determined an acceptable operational margin between your peak utilization and the applications maximum load?
  > What's the maximum taxation you wish to place on resources? Factors such as memory, CPU, disk IOPS should all be considered. Once a stress test has been performed resulting in the maximum supported load and an operational margin has been chosen, it is best to determine an operational threshold. Then, environment scaling (automatic or manual) can be performed once the threshold has been reached.

- What are the metrics of a performance test under standard loads?
  > A true performance test measures how the application performs under a standard load.
  >
  >**Links:**
  >
  >- [What are the best Performance Testing Tools?](https://techcommunity.microsoft.com/t5/testingspot-blog/what-are-the-best-performance-testing-tools/ba-p/367774)

- Given your determination of acceptable operational margin and response under _standard_ levels of load, has the environment been configured adequately?
  > Determine if the environment is rightly configured to handle "standard" loads. (e.g. Are the correct SKUs selected based on desired margins?) Over allocation can unnecessarily increase costs and maintenance; under allocation can result in poor user experience.

- How well does the application respond under certain increased levels of loads?
  > Typically, there's a stair step model to determining load capacity. The stair step model considers various levels of users for various time periods. Running a load test helps to determine how well the application scales as load increases on the application.
  >
  >**Links:**
  >
  >- [Load Testing](https://loadninja.com/load-testing/)
  >- [Load Testing Tutorial: What is? How to?](https://www.guru99.com/load-testing-tutorial.html)

- Given your determination of acceptable operational margin and response under _increased_ levels of load, have you configured the environment to scale out to sustain performance efficiency?
  > Determine if the environment is rightly configured to scale in order to handle increased loads. (e.g. Does the environment scale effectively at certain times of day or at specific performance counters?) If the customer has identified specific times in which load increases, then the environment can be configured to proactively scale prior to the actual increase in load.
  >
  >**Links:**
  >
  >- [Autoscaling](https://docs.microsoft.com/azure/architecture/best-practices/auto-scaling)
  >- [Get started with Autoscale in Azure](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-get-started)

- Have you correctly configured the environment to scale back in for the purpose of saving costs when load is under certain performance thresholds?
  > Ensure that a rule has been configured to scale the environment back down once load settles below set thresholds.

### Performance Improvements

- Are you using any caching mechanisms?
  > Seek to identify if the customer is using any type of caching, whether it is client-side caching, view caching, or data caching. Incorporating proper caching can greatly improve efficiency and user experience. Incorporating caching can also help reduce latency by eliminating repetitive calls to microservices, APIs, and data repositories.
  >
  >**Links:**
  >
  >- [Web Caching Basics: Terminology, HTTP Headers, and Caching Strategies](https://www.digitalocean.com/community/tutorials/web-caching-basics-terminology-http-headers-and-caching-strategies)
  >- [Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-overview)
  >- [Caching](https://docs.microsoft.com/azure/architecture/best-practices/caching)
  >- [API Management caching policies](https://docs.microsoft.com/azure/api-management/api-management-caching-policies)

- If you are using page caching, what mechanisms are you using?
  > There's various types of caching mechanisms that can be configured with a web page and it's components. Such examples include expiry dates, tags, modification dates, content, or other variances like IP addresses or encoding types.

- What are you using for data caching?
  > Azure Cache for Redis is a preferred solution for data caching as it improves performance by storing data in memory instead of on disk like SQL Server. Certain development frameworks like .NET also have mechanisms for caching data at the server level.
  >
  >**Links:**
  >
  >- [Cache in-memory in ASP.NET Core](https://docs.microsoft.com/aspnet/core/performance/caching/memory?view=aspnetcore-3.1)
  >- [Implementing Caching In Web API](https://www.c-sharpcorner.com/article/implementing-caching-in-web-api/)

- Are you using any CDNs?
  > CDNs store static files in locations that are typically geographically closer to the user than the data center. This increases performance as latency for downloading these artifacts is reduced.
  >
  >**Links:**
  >
  >- [Best practices for using content delivery networks (CDNs)](https://docs.microsoft.com/azure/architecture/best-practices/cdn)

- Are you using SSL offloading?
  > SSL offloading places the SSL certificate at an appliance that sits in front of the web server, instead of on the web server itself. This is beneficial for two reasons. First, the verification of the SSL certificate is conducted by the appliance instead of the web server, which reduces the taxation on the server. Second, SSL offloading can often eliminate the need to manage certificates across microservices.
  >
  >**Links:**
  >
  >- [Gateway Offloading pattern](https://docs.microsoft.com/azure/architecture/patterns/gateway-offloading)

- Are you using authentication/token verification offloading?
  > Like SSL offloading, authentication/token verification offloading on an appliance can reduce taxation on the server. Additionally, authentication verification offloading can greatly reduce development complication as developers no longer need to worry with the complications of SAML or OAuth tokens and, instead, can focus specifically on the business logic.
  >
  >**Links:**
  >
  >- [Microservices Authentication and Authorization Using API Gateway](https://dzone.com/articles/security-in-microservices)
  >- [API Management authentication policies](https://docs.microsoft.com/azure/api-management/api-management-authentication-policies)

- Are you using database replicas and data partitioning?
  > Database replicas and data partitioning can improve application performance by providing multiple copies of the data and/or reducing the taxation of database operations. Both mechanisms involve conversations and planning between developers and database administrators.
  >
  >**Links:**
  >
  >- [Horizontal, vertical, and functional data partitioning](https://docs.microsoft.com/azure/architecture/best-practices/data-partitioning)
  >- [Use read-only replicas to offload read-only query workloads](https://docs.microsoft.com/azure/azure-sql/database/read-scale-out)

 - How do you know when you have reached _acceptable_ efficiency?
   > There is almost no limit to how much an application can be performance-tuned. How do you know when you have tuned an application enough? It really comes down to the 80/20 rule&mdash;generally, 80% of the application can be optimized by focusing on just 20%. After optimizing 20%, a company typically sees a diminishing return on further optimization. The question the customer must answer is how much of the remaining 80% of the application is worth optimizing for the business. In other words, how much will optimizing the remaining 80% help the business reach its goals (e.g. customer acquisition/retention, sales, etc.)? The business must determine their own _realistic_ definition of "acceptable."

### Performance Pipeline

 - Do you have performance validation stages in your deploy and build pipelines?
    > This is a probing question to get feedback on how the customer views performance testing in CI/CD pipelines. Testing here can ensure that performance regressions and adverse affects can be caught as early as possible.
 
## Monitoring

### Application-level Monitoring

- Do you have detailed instrumentation in the application code?
  > Instrumentation of you code allows precise detection of underperforming pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code. APM technology, such as Application Insights, should be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation.
  >
  >**Links:**
  >
  >- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)

- Are application logs collected from different application environments?
  > Application logs and events should be collected across all major environments to support the end-to-end application lifecycle.

- Are application events correlated across all application components?
  > Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made you can then see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a completed transaction that has flowed through the system.
  >
  >Log events coming from different application components or different component tiers of the application should be correlated to build end-to-end transaction flows (see [Distributed tracing](https://docs.microsoft.com/azure/architecture/microservices/logging-monitoring#distributed-tracing)). For instance, this is often achieved by using consistent correlation IDs transferred between components within a transaction.
  >
  >**Links:**
  >
  >- [Log Analytics Query](https://docs.microsoft.com/azure/azure-monitor/log-query/get-started-portal)

- Are log messages captured in a structured format?
  > Application events should ideally be captured as a structured data type with machine-readable data points which can easily be indexed and searched, rather than an unstructured string types.

- Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?
  > Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.

- Is the end-to-end performance of critical system flows monitored?
  > It should be possible to correlate application log events across critical system flows, such as user login, to fully assess the health of key scenarios in the context of targets and NFRs.

### Resource/Infrastructure-level Monitoring

- Which log aggregation technology is used to collect logs and metrics from Azure resources?
  > Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as 3rd-party appliances such as firewalls or Anti-Malware solutions used in the application. For instance, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink.
  >
  >**Links:**
  >
  >- [Event Hub Diagnostic Logs](https://docs.microsoft.com/azure/event-hubs/event-hubs-diagnostic-logs)

- Are you collecting Azure Activity Logs within the log aggregation tool?
  > Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. Such information is extremely useful for the interpretation and troubleshooting of issues, as it provides transparency around configuration changes that can be mapped to adverse performance events.

- Is resource level monitoring enforced throughout the application?
  > All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. Azure Policy should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.

- Are logs and metrics available for critical internal dependencies?
  > To be able to build a robust application health model it is vital that visibility into the operational state of critical internal dependencies, such as a shared NVA or Express Route connection, be achieved.

- Are critical external dependencies monitored?
  > Critical external dependencies, such as an API service, should be monitored to ensure operational visibility of performance. For instance, a probe could be used to measure the latency of an external API.

### Data Interpretation & Health Modelling

- Are application and resource level logs aggregated in a single data sink, or is it possible to cross-query events at both levels?
  > To build a robust application health model it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues.

  - Are application level events automatically correlated with performance metrics to quantify the current application state?
    > The overall performance can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults.

  - Is the transaction flow data used to generate application/service maps?
    > An [Application Map](https://docs.microsoft.com/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.

- Is a health model used to qualify what 'healthy' and 'unhealthy' states represent for the application?
  > A holistic application health model should be used to quantify what 'healthy' and 'unhealthy' states represent across all application components. It is highly recommended that a 'traffic light' model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized, e.g. 95% of requests are processed in <= 500ms with AKS node utilization at x% etc.

  - Are critical system flows used to inform the health model?
    > The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow.

  - Can the health model determine if the application is performing at expected performance targets?
    > The health model should have the ability to evaluate application performance as a part of the application’s overall health state.
  
- Are long-term trends analyzed to predict performance issues before they occur?
  > Analytics can and should be performed across long-term operational data to help inform on the history of application performance and detect if there have been any regressions. For instance, if the average response times have been slowly increasing over time and getting closer to the maximum target.

- Have retention times for logs and metrics been defined and with housekeeping mechanisms configured?
  > Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis.

## Troubleshooting

- Does the application spend a lot of time in the database?
  > Applications that spend a lot of execution time in the database layers can benefit from a database tuning analysis. This analysis will only focus on the data tier components and may require special resources such as DBA’s to tune queries, indexes, execution plans and more.
  >
  >**Links:**
  >
  >- [Azure SQL Database and Azure SQL Managed Instance monitoring and performance tuning](https://docs.microsoft.com/azure/azure-sql/database/monitoring-tuning-index)
  >- [Automatic tuning](https://docs.microsoft.com/azure/azure-sql/database/automatic-tuning-overview)
  >- [Monitor and tune Azure Database for PostgreSQL](https://docs.microsoft.com/azure/postgresql/concepts-monitoring)

- Does the application have high CPU or Memory utilization?
  > If the application has very high CPU or memory utilization, then consider scaling the application either horizontal or Vertical. Scaling horizontal to more compute resources will spread the load across more machines this will however increase the network complexity as there will be more machines to support the system. Scaling the application vertical to a larger machine that is optimized for higher CPU or memory workloads may also be considered. Profiling the application code can be useful to find code structures that may be sub optimal and replace it with better performing code structures.  These decisions are a balance of several factors that can include cost, system complexity, time to implement.
  >
  >**Links:**
  >
  >- [Vertical VM Scaling](https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-vertical-scale-reprovision)
  >- [Horizontal VM Scaling](https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview)
  >- [AKS Scaling](https://docs.microsoft.com/azure/aks/concepts-scale)
  >- [App Service](https://docs.microsoft.com/azure/app-service/manage-scale-up)
  >- [Code Profiling](https://docs.microsoft.com/visualstudio/profiling/profiling-feature-tour?view=vs-2019)
  >- [VM Profiling](https://docs.microsoft.com/azure/virtual-machines/troubleshooting/performance-diagnostics)

- Does the application response time increase while not using all the CPU or memory allocated to the system no matter the load?
  > When the system response times increase without any increase in the CPU or Memory this is an indicator that there is a resource that is time blocked. This can mean many things such as thread sleep, connection wait, message queueing, the list can go on. The bottom line is there is something that is consuming time but not compute resources. Try to locate these issues with tracing data that can deliver time spans for each layer of the application architecture that is correlated to an application transaction.
  >
  >**Links:**
  >
  >- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
  >- [Distributed Tracing](https://docs.microsoft.com/azure/azure-monitor/app/distributed-tracing)
  >- [Log Analytics Query](https://docs.microsoft.com/azure/azure-monitor/log-query/get-started-portal)

- Do you profile the application code with any profiling tooling?
  > Application profiling will involve tooling like Visual Studio Performance Profile, AQTime,dotTrace and others. These tools will give you in depth analysis of individual code paths.
  >
  >**Links:**
  >
  >- [Visual Studio Performance Profile](https://docs.microsoft.com/visualstudio/profiling/profiling-feature-tour?view=vs-2019)
  >- [dotTrace](https://www.jetbrains.com/profiler/)
  >- [AQtime](https://smartbear.com/product/aqtime-pro/overview/)

- Do you profile the network with any traffic capture tooling?
  > Network Capture tooling can capture the network traffic and deep dive into the interactions at the network layer that may affect your application due to network configuration or other network traffic issues.
  >
  >**Links:**
  >
  >- [Security analytics, network/application performance management](https://docs.microsoft.com/azure/virtual-network/virtual-network-tap-overview#virtual-network-tap-partner-solutions)

