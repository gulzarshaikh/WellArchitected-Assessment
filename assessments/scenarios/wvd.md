# Scenario Windows Virtual Deskop

# Navigation Menu

  - [WVD](#WVD)
    - [Management &amp; Monitoring](#Management--Monitoring)
    - [FSLogix](#FSLogix)
    - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Identity &amp; Access Control](#Identity--Access-Control)
# WVD
        
## Management &amp; Monitoring
### Design Considerations
* Managing and monitoring any Azure service is a core component from an operations standpoint which is why this is included in Design Considerations
  - Windows Virtual Desktop service logs should be integrated into Azure Monitor Log Analytics
    > Azure Monitor allows for a central location around log and monitoring data in Azure
                                
                            
  - Configure the necessary performance counters for your monitoring services
    > We recommend enabling [performance counters for WVD](https://docs.microsoft.com/azure/virtual-desktop/azure-monitor#set-up-performance-counters). Azure Monitor for Windows Virtual Desktop is currently in public preview so should not be used for production workloads.
                                
                            
  - Windows Virtual Desktop Session Hosts should be backed up (when not using auto-scale/pooled)
    > [WVD Session Hosts backed up](https://github.com/Azure/RDS-Templates/tree/master/EnableBackupScript) can be used to back up WVD Session Hosts
                                
                            
## FSLogix
### Design Considerations
* [FSLogix](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) technology allows for users profiles to be stored in a central location and accessed by WVD Session Hosts, side loading the disks in a seamless manner. If using a solution where your users can sign into different Windows Virtual Desktop Session Hosts (Multi-session for example), [FSLogix](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) should be used to centralize users&#39; profiles.
  - (Storage) Storage requirements should be optimized for performance in the Windows Virtual Desktop service
    > [Storage sizing for Azure Files and Azure NetApp Files](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#performance-requirements) need to align with IOPS Requirements
                                
                            
  - (Storage) Size of the volumes should reflect the performance needed
    > Consideration of the size of the volume where user profiles will be stored on a per user profile size basis
                                
                            
  - (Storage - Azure Files) SKU of the Azure Files Storage Account
    > Light users - Standard File Shares, Medium users - Standard/Premium File Shares, Heavy users - Premium File Shares, Power users - Premium File Shares
                                
                            
  - The chosen storage service for FSLogix
    > Azure Files ([Azure AD Domain Services](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-profile-container-adds) or [Active Directory Domain Services](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-file-share), [Azure NetApp Files](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-fslogix-profile-container), [VM-based file share](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-user-profile)
                                
                            
  - [FSLogix Cloud Cache](https://docs.microsoft.com/en-us/fslogix/cloud-cache-resiliency-availability-cncpt) for Business Continuity &amp; Disaster Recovery
    > FSLogix Cloud Cache is used for best practice failover and quick recovery scenarios
                                
                            
  - Backup solution for the chosen storage service that FSLogix will be using
    > It is just as vital to implement a backup solution next to your disaster recovery solution. [Azure NetApps Files supports scheduled snapshots](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-manage-snapshots) and Azure Backup should be considered for [File Shares(https://docs.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview)]
                                
                            
  - Design your storage to reside as close as possible to your session hosts
    > This increases performance and latency for a better end user experience
                                
                            
  - Exclude user profile VHD(x) from AV and malware scans
    > All files inside the VHD would be scanned on demand
                                
                            
## Networking &amp; Connectivity
### Design Considerations
* Placement of your Windows Virtual Desktop session hosts in your network is a key consideration and should be included in your design
  - Active Directory Domain Services line of site
    > For WVD Session Hosts to join onto your Active Directory domain, the Virtual Network they reside on should be able to resolve your Active Directory domain name. It is strongly recommended to extend and build [Domain Controllers in Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/identity/adds-extend-domain).
                                
                            
  - Connection to application(s), Active Directory Domain Services and workloads should be in line with the expected availability requirements for the environment
    > Availability of applications, domain services and connectivity methods should adhere to the availability requirements. Refer back to [Networking Reliability](https://github.com/Azure/WellArchitected-Assessment/blob/main/assessments/reliability/application.md#networking--connectivity) for more information.
                                
                            
  - Application workload line of sight from your WVD Session Host(s)
    > Some application workloads may not be running in Azure which means that WVD will require access to third party datacenters (ExpressRoute, site-to-site VPN). It is recommended to migrate applications and workloads accessed by WVD into Azure as close to the WVD environment as possible following [Enterprise Scale Landing Zone guidance](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/).
                                
                            
  - Designing your solution architecture for scale
    > Ensure that your network architecture has enough internal addresses to support the number of WVD Session Hosts in your environment
                                
                            
## Identity &amp; Access Control
### Design Considerations
* Windows Virtual Desktop requires that there is a hybrid identity solution implemented
  - Set up  [Azure AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect).
    > This is a prerequisite for Windows Virtual Desktop. This is required to translate the user signing into the WVD Management plane via Azure AD to the user in the Active Directory forest
                                
                            
  - WVD Users must be sourced from the same Active Directory Domain Service (ADDS) that is synchronising to Azure AD. WVD Does not support B2B or Microsoft Accounts
    > Synchronize all identities to a single Azure AD using Azure AD Connect
                                
                            
  - The account used for domain join during the session host building cannot have multi-factor authentication or other interactive prompts
    > During the session host building phase/automation the account used to work on those hosts cannot have multi-factor authentication
                                
                            
  - Specifying the Organizational Unit (OU) that WVD Session Hosts will reside in
    > Segregate the WVD Session Host Virtual Machines (VMs) into Active Directory OUs (Organizational Units) for each host pool to manage policies and orphaned objects
                                
                            
  - Follow the principle of least privilege
    > [Built-in RBAC Roles](https://docs.microsoft.com/en-us/azure/virtual-desktop/rbac) should be reviewed. Assignment to groups can provide lower administration rather than user assignment.
                                
                            
  - Leverage Azure AD Conditional Access policies
    > Create policies for WVD. For example, multi-factor authentication can be enforced on conditions such as risky sign-ins increasing an organizations security posture
                                
                            
