# Scenario Azure Virtual Deskop

# Navigation Menu

  - [AVD](#AVD)
    - [Management &amp; Monitoring](#Management--Monitoring)
    - [FSLogix](#FSLogix)
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
                                
                            
## FSLogix
### Design Considerations
* [FSLogix](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) technology allows for users profiles to be stored in a central location and accessed by AVD Session Hosts, side loading the disks in a seamless manner. If using a solution where your users can sign into different Azure Virtual Desktop Session Hosts (Multi-session for example), [FSLogix](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) should be used to centralize users&#39; profiles.
  - (Storage) Storage requirements should be optimized for performance in the Azure Virtual Desktop service
    > [Storage sizing for Azure Files and Azure NetApp Files](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix#performance-requirements) needs to align with IOPS Requirements
                                
                            
  - (Storage) Size of the volumes should reflect the performance needed
    > Consideration of the size of the volume where user profiles will be stored on a per user profile size basis
                                
                            
  - (Storage - Azure Files) SKU of the Azure Files Storage Account
    > Light users - Standard File Shares, Medium users - Standard/Premium File Shares, Heavy users - Premium File Shares, Power users - Premium File Shares
                                
                            
  - The chosen storage service for FSLogix
    > Azure Files ([Azure AD Domain Services](https://docs.microsoft.com/azure/virtual-desktop/create-profile-container-adds) or [Active Directory Domain Services](https://docs.microsoft.com/azure/virtual-desktop/create-file-share), [Azure NetApp Files](https://docs.microsoft.com/azure/virtual-desktop/create-fslogix-profile-container), [VM-based file share](https://docs.microsoft.com/azure/virtual-desktop/create-host-pools-user-profile))
                                
                            
  - [FSLogix Cloud Cache](https://docs.microsoft.com/en-us/fslogix/cloud-cache-resiliency-availability-cncpt) for Business Continuity &amp; Disaster Recovery
    > FSLogix Cloud Cache is used for best practice failover and quick recovery scenarios
                                
                            
  - Backup solution for the chosen storage service that FSLogix will be using
    > It is just as vital to implement a backup solution next to your disaster recovery solution. [Azure NetApps Files supports scheduled snapshots](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-manage-snapshots) and Azure Backup should be considered for [File Shares](https://docs.microsoft.com/azure/backup/azure-file-share-backup-overview)
                                
                            
  - Design your profile storage solution to reside in the same Azure region as your session hosts, if not the next closest region
    > This increases performance and latency for a better end user experience
                                
                            
  - Exclude user profile VHD(x) from AV and malware scans
    > All files inside the VHD will be scanned on demand
                                
                            
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
    > This is a prerequisite for Azure Virtual Desktop. This is required to translate the user signing into the AVD Management plane via Azure AD to the user in the Active Directory forest. Azure AD Join only is supported, but as of time of writing is in Public Preview.
                                
                            
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
                                
                            