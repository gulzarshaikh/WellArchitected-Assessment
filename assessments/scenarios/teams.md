# Scenario Microsoft Teams

# Navigation Menu

  - [Teams Tab Apps](#Teams-Tab-Apps)
    - [Requirements](#Requirements)
    - [Architecture](#Architecture)
    - [Design](#Design)
    - [Processes](#Processes)
# Teams Tab Apps
        
## Requirements
### Questions
* Requirements
  - How many users are expected to use the solution?
    > The number of expected hourly, daily, monthly users is a good indicator for later requirements in regards to scalability and others.
                                
                            
  - Is the solution accessed from users in a specific geographic region?
    > Solutions with users from various geographical regions have other requirements in regards to latency and availability.
                                
                            
## Architecture
### Questions
* Solution Architecture &amp; Overview
  - Is the solution backend hosted on a cloud platform like Azure?
                            
  - Does the solution have dependencies to any on-premises systems?
    > Solutions with dependencies to on-premises systems might have specific requirements in regards to connectivity via e.g. VPN or Express Route.
                                
                            
## Design
### Questions
* Is the current solution able to scale?
  > Scalability is a key aspect to fulfill increasing usage while maintaining a consistent user experience.
                            
  - Is the solution separated into separate components that can scale individually?
    > Separate components of an application might have different requirements in regards to scalability, state and lifecycle.
                                
                            
* How is the solution and its components monitored?
  - Are critical system flows within the solution monitored?
                            
## Processes
### Questions
* How are changes and features rolled out?
  - Is it possible to test changes in a production-like environment first?
                            