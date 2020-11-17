# Scenario Windows Virtual Deskop

# Navigation Menu

  - [WVD](#WVD)
    - [FSLogix](#FSLogix)
    - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Identity &amp; Access Control](#Identity--Access-Control)
# WVD
        
## FSLogix
### Questions
* Has [FSLogix](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) been included in your design?
  > If using a solution where your users can sign into different Windows Virtual Desktop Session Hosts (Multi-session for example), [FSLogix](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) should be used to centralize users' profiles.
                            
  - Which storage solution is being used for FSLogix?
    > Azure Files ([Azure AD Domain Services](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-profile-container-adds) or [Active Directory Domain Servces](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share), [Azure NetApp Files](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-fslogix-profile-container), [VM-based file share](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-user-profile)
                                
                            
  - Is Cloud Cache included in your FSLogix architecture?
    > FSLogix Cloud Cache is used for best practice failover and quick recovery scenarios
                                
                            
  - What backup solution are you using for your chosen storage service?
    > It is just as vital to implement a backup solution next to your disaster recovery solution
                                
                            
## Networking &amp; Connectivity
### Questions
* Networking is a core component of Windows Virtual Desktop and should be included in your solution design
  - Does your Virtual Network in Azure have line of sight to your domain network?
    > For WVD Session Hosts to join onto your Active Directory domain, the Virtual Network they reside on should be able to resolve your Active Directory domain name
                                
                            
  - Does your WVD Session Hosts have access to all necessary application workloads (Hybrid Connectivity)?
    > Some application workloads may not be running in Azure which means that WVD will require access to third party datacenters (ExpressRoute, site-to-site VPN)
                                
                            
  - Have you designed for your WVD Session Hosts to scale?
    > By allowing your WVD Session Hosts to have a dedicated subnet inside a Virtual Network, the outcome is the solution has the ability to scale to meet demand should it need to
                                
                            
## Identity &amp; Access Control
### Questions
* Windows Virtual Desktop requires that there is a hybrid identity solution implemented
  - Have you set up  [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect) in your environment?
    > This is a prerequisite for Windows Virtual Desktop. This is required to translate the user signing into the WVD Management plane via Azure AD to translate to user in the Active Directory forest
                                
                            