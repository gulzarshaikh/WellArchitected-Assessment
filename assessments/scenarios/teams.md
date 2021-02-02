# Scenario Microsoft Teams

# Navigation Menu

  - [Teams](#Teams)
    - [Requirements](#Requirements)
  - [Teams Tab Apps](#Teams-Tab-Apps)
    - [Architecture](#Architecture)
    - [Design](#Design)
    - [Processes](#Processes)
# Teams
        
## Requirements
### Questions
* Requirements
  > High-level requirements for a specific Teams App solution like availability, latency, expected no. of users etc.
                            
  - How many users are expected to use the solution?
    > The number of expected hourly, daily, monthly users is a good indicator for later requirements in regards to scalability and others.
                                
                            
  - Is the solution accessed from users in a specific geographic region?
    > Solutions with users from various geographical regions have other requirements in regards to latency and availability.
                                
                            
# Teams Tab Apps
        
## Architecture
### Questions
* Solution Architecture &amp; Overview
  - Is the solution backend hosted on a cloud platform like Azure?
    > Cloud platforms like Microsoft Azure offer certain capabilities like auto scaling and data center regions across the globe that might not be available on-premises.
                                
                            
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
                            