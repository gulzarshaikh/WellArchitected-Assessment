# Scenario Microsoft Teams

# Navigation Menu

  - [Security &amp; Compliance](#Security--Compliance)
    - [Network Security](#Network-Security)
  - [Teams](#Teams)
    - [Requirements](#Requirements)
  - [Teams Tab Apps](#Teams-Tab-Apps)
    - [Architecture](#Architecture)
    - [Design](#Design)
    - [Processes](#Processes)
# Security &amp; Compliance
        
## Network Security
### Design Recommendations
* Protect QnA Maker with network isolation.
  > Azure Cognitive Services provides a layered security model. This model enables you to [secure your Cognitive Services accounts](https://docs.microsoft.com/azure/cognitive-services/cognitive-services-virtual-networks?tabs=portal) to a specific subset of networks. When network rules are configured, only applications requesting data over the specified set of networks can access the account. On the App Service side, you can use the `CognitiveServicesManagement` service tag to allow the Authoring APIs to invoke App Service and update Azure Search accordingly. Make sure you also allow other entry points like Bot service, QnA Maker portal (may be your corporate network) etc. for prediction `GenerateAnswer` API access. Alternatively, the App Service Environment (ASE) can be used to host QnA Maker App Service. See [Recommended settings for network isolation](https://docs.microsoft.com/azure/cognitive-services/qnamaker/how-to/set-up-qnamaker-service-azure?tabs=v1#recommended-settings-for-network-isolation) for more.
                            
# Teams
        
## Requirements
### Questions
* Requirements
  > High-level requirements for a specific Microsoft Teams App solution like availability, latency, expected no. of users etc.
                            
  - How many users are expected to use the solution?
    > The number of expected hourly, daily, monthly users is a good indicator for later requirements in regards to scalability and others.
                                
                            
  - Is the solution accessed from users in a specific geographic region?
    > Solutions with users from various geographical regions have other requirements in regards to latency and availability.
                                
                            
  - What is the expected SLA or availability for the solution and its components?
    > Different Teams applications can have varying requirements in terms of availability and contractual SLAs. Internal-only chatbot may accept more outage time than a Tabs application used as the only surface for a business system. Availability of dependent services (such as QnA knowledgbases) need to be considered as well.
                                
                            
# Teams Tab Apps
        
## Architecture
### Questions
* Solution Architecture &amp; Overview
  - Is the solution backend hosted on a cloud platform like Azure?
    > Cloud platforms like Microsoft Azure offer certain capabilities like auto scaling and data center regions across the globe that might not be available on-premises.
                                
                            
  - Does the solution depend on specific Azure PaaS services?
    > Not all PaaS services are available in all Azure data center regions, do not have the same scale capabilities, SLAs and options.
                                
                            
  - Does the solution have dependencies to any on-premises systems?
    > Solutions with dependencies to on-premises systems might have specific requirements in regards to connectivity via e.g. VPN or Express Route.
                                
                            
## Design
### Design Considerations
* Security
  - If the solution requires authentication, integrate Microsoft single sign-on (SSO) for a seamless sign-in experience.
                            
### Questions
* Is the current solution able to scale?
  > Scalability is a key aspect to fulfill increasing usage while maintaining a consistent user experience.
                            
  - Is the solution separated into separate components that can scale individually?
    > Separate components of an application might have different requirements in regards to scalability, state and lifecycle.
                                
                            
* How is the solution and its components monitored?
  - Are critical system flows within the solution monitored?
                            
  - Are response times monitored?
    > If a response to an action takes more than three seconds, you must provide a loading message or warning.
                                
                            
## Processes
### Questions
* How are changes and features rolled out?
  - Is there a separation between dev/test and prod?
                            
  - Are new releases versioned and tested before they&#39;re rolled out to production?
                            
  - Where are changes to the Teams Tab app tested?
    > Microsoft Teams apps can be debugged Purely local, Locally hosted in Teams or Cloud-hosted in Teams. See [Choosing a setup to test and debug your Microsoft Teams app](https://docs.microsoft.com/microsoftteams/platform/concepts/build-and-test/debug) for more.
                                
                            
  - Is it possible to test changes in a production-like environment first?
                            