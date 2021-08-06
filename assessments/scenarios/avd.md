# Scenario Azure Virtual Deskop

# Navigation Menu

  - [AVD](#AVD)
    - [Management &amp; Monitoring](#Management--Monitoring)
    - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Identity &amp; Access Control](#Identity--Access-Control)
# AVD
        
## Management &amp; Monitoring
### Design Considerations
* Managing and monitoring any Azure service is a core component from an operations standpoint which is why this is included in Design Considerations
  - Azure Virtual Desktop service logs should be integrated into Azure Monitor Log Analytics
    > Azure Monitor allows for a central location around log and monitoring data in Azure
                                
                            
  - Configure the necessary performance counters for your monitoring services
    > It is recommended to enable [performance counters for AVD](https://docs.microsoft.com/azure/virtual-desktop/azure-monitor#set-up-performance-counters)
                                
                            
  - Enable Azure Monitor for Azure Virtual Desktop
    > [Azure Monitor for Azure Virtual Desktop](https://docs.microsoft.com/azure/virtual-desktop/azure-monitor) can be used to find and troubleshoot problems in deployments, view the status and health of host pools, diagnose user feedback and understand resource utilization.
                                
                            
  - Azure Virtual Desktop Session Hosts should be backed up (when not using auto-scale/pooled)
    > AVD [EnableBackupScript](https://github.com/Azure/RDS-Templates/tree/master/EnableBackupScript) can be used to back up AVD Session Hosts
                                
                            
## Networking &amp; Connectivity
### Design Considerations
* Placement of your Azure Virtual Desktop session hosts in your network is a key consideration and should be included in your design
  - Active Directory Domain Services line of site
    > For AVD Session Hosts to join onto your Active Directory domain, the Virtual Network they reside on should be able to resolve your Active Directory domain name. It is strongly recommended to extend and build [Domain Controllers in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain).
                                
                            
  - Connection to application(s), Active Directory Domain Services and workloads should be in line with the expected availability requirements for the environment
    > Availability of applications, domain services and connectivity methods should adhere to the availability requirements. Refer back to [Networking Reliability](https://github.com/Azure/WellArchitected-Assessment/blob/main/assessments/reliability/application.md#networking--connectivity) for more information.
                                
                            
  - Application workload line of sight from your AVD Session Host(s)
    > Some application workloads may not be running in Azure which means that AVD will require access to third party datacenters (ExpressRoute, site-to-site VPN). It is recommended to migrate applications and workloads accessed by AVD into Azure as close to the AVD environment as possible following [Enterprise Scale Landing Zone guidance](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/).
                                
                            
  - Design your solution architecture for scale
    > Ensure that your network architecture has enough internal IP addresses to support the number of AVD Session Hosts in your environment
                                
                            
## Identity &amp; Access Control
### Design Considerations
* Azure Virtual Desktop requires that there is a hybrid identity solution implemented
  - Set up [Azure AD Connect](https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect).
    > This is a prerequisite for Azure Virtual Desktop. This is required to translate the user signing into the AVD Management plane via Azure AD to the user in the Active Directory forest
                                
                            
  - AVD Users must be sourced from the same Active Directory Domain Service (ADDS) that is synchronising to Azure AD. AVD does not support B2B or Microsoft Accounts
    > Synchronize all identities to a single Azure AD using Azure AD Connect
                                
                            
  - The account used for domain join during the session host building cannot have multi-factor authentication or other interactive prompts
    > During the session host building phase/automation the account used to work on those hosts cannot have multi-factor authentication
                                
                            
  - Specifying the Organizational Unit (OU) that AVD Session Hosts will reside in
    > Segregate the AVD Session Host Virtual Machines (VMs) into Active Directory Organizational Units (OUs) for each host pool to manage policies and orphaned objects
                                
                            
  - Follow the principle of least privilege
    > [Built-in RBAC Roles](https://docs.microsoft.com/azure/virtual-desktop/rbac) should be reviewed. Assignment to groups can provide lower administration rather than user assignment.
                                
                            
  - Leverage Azure AD Conditional Access policies
    > Create policies for AVD. For example, multi-factor authentication can be enforced on conditions such as risky sign-ins increasing an organizations security posture
                                
                            