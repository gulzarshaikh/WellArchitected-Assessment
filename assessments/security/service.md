# Service Security

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Storage](#Storage)
    - [Storage Accounts](#Storage-Accounts)
# Storage
        
## Storage Accounts
### Design Considerations
* Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
* Storage account names must be unique within Azure. No two storage accounts can have the same name.
* The current [SLA for Storage Accounts](https://azure.microsoft.com/en-us/support/legal/sla/storage/v1_5/) (v1.5, June 2019) specifies a 99.9% guarantee for LRS, ZRS and GRS accounts and a 99.99% guarantee for RA-GRS (provided that requests to RA-GRS switch to secondary endpoints if there is no success on the primary endpoint) to successfully process requests to **read data**. And at least 99.9% to successfully process requests to **write data**. SLAs for other storage tiers might differ. Go to [Azure Storage redundancy](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy) to see which redundancy option is best for a specific scenario.
### Configuration Recommendations
* Enable Azure Defender for all of your storage accounts
  > Azure Defender for Azure Storage provides an additional layer of security intelligence that detects unusual and potentially harmful attempts to access or exploit storage accounts. Security alerts are triggered in Azure Security Center when anomalies in activity occur and are also sent via email to subscription administrators, with details of suspicious activity and recommendations on how to investigate and remediate threats. For more information, see [Configure Azure Defender for Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/azure-defender-storage-configure).
                            
* Turn on soft delete for blob data
  > Soft delete enables you to recover blob data after it has been deleted. For more information on soft delete, see [Soft delete for Azure Storage blobs](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-soft-delete).
                            
* Use Azure AD to authorize access to blob data
  > Azure AD provides superior security and ease of use over Shared Key for authorizing requests to Blob storage. It is recommended to use Azure AD authorization with your blob and queue applications when possible to minimize potential security vulnerabilities inherent in Shared Key. For more information, see [Authorize access to Azure blobs and queues using Azure Active Directory](https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad).
                            
  - Keep in mind the principal of least privilege when assigning permissions to an Azure AD security principal via Azure RBAC
    > When assigning a role to a user, group, or application, grant that security principal only those permissions that are necessary for them to perform their tasks. Limiting access to resources helps prevent both unintentional and malicious misuse of your data.
                                
                            
  - Use Managed Identities to access blob and queue data
    > Azure Blob and Queue storage support Azure AD authentication with [managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview). Managed identities for Azure resources can authorize access to blob and queue data using Azure AD credentials from applications running in Azure virtual machines (VMs), function apps, virtual machine scale sets, and other services. By using managed identities for Azure resources together with Azure AD authentication, you can avoid storing credentials with your applications that run in the cloud as well as issues with expiring service principals. See [Authorize access to blob and queue data with managed identities for Azure resources](https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad-msi) for more information.
                                
                            
* Use blob versioning or immutable blobs to store business-critical data
  > Consider using [Blob versioning](https://docs.microsoft.com/en-us/azure/storage/blobs/versioning-overview) to automatically maintain previous versions of an object or the use of legal holds and time-based retention policies to store blob data in a WORM (Write Once, Read Many) state. Blobs stored immutably can be read, but cannot be modified or deleted for the duration of the retention interval. For more information, see [Store business-critical blob data with immutable storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-immutable-storage).
                            
* Enable the Secure transfer required option on all of your storage accounts
  > When you enable the Secure transfer required option, all requests made against the storage account must take place over secure connections. Any requests made over HTTP will fail. For more information, see [Require secure transfer in Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-require-secure-transfer).
                            
  - Limit shared access signature (SAS) tokens to HTTPS connections only
    > Requiring HTTPS when a client uses a SAS token to access blob data helps to minimize the risk of eavesdropping. For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview).
                                
                            
  - Avoid/prevent using Shared Key authorization to access Storage Accounts
    > It is recommended to use Azure AD to authorize requests to Azure Storage and possible to [prevent Shared Key Authorization](https://docs.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent). For scenarios that require Shared Key authorization, always prefer SAS tokens over distributing the Shared Key.
                                
                            
  - Regenerate your account keys periodically
    > Rotating the account keys periodically reduces the risk of exposing your data to malicious actors.
                                
                            
  - Have a revocation plan in place for any SAS that you issue to clients
    > If a SAS is compromised, you will want to revoke that SAS as soon as possible. To revoke a user delegation SAS, revoke the user delegation key to quickly invalidate all signatures associated with that key. To revoke a service SAS that is associated with a stored access policy, you can delete the stored access policy, rename the policy, or change its expiry time to a time that is in the past.
                                
                            
* Restrict default Internet access for Storage Accounts
  > By default network access to Storage Accounts is not restricted and open to all traffic coming from the Internet. Access to storage accounts should be granted to specific [Azure Virtual Networks only](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security) whenever possible or use [private endpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) to allow clients on a virtual network (VNet) to securely access data over a [Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview). See [Use private endpoints for Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-private-endpoints) for more. Exception can be made for Storage Accounts that need to be accessible via the Internet.
                            
  - Enable firewall rules
    > Configure firewall rules to limit access to your storage account to requests that originate from specified IP addresses or ranges, or from a list of subnets in an Azure Virtual Network (VNet). For more information about configuring firewall rules, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security).
                                
                            
  - Limit network access to specific networks
    > [Limiting network access](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security) to networks hosting clients requiring access reduces the exposure of your resources to network attacks either by using the built-in [Firewall and virtual networks](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security) functionality or by using [private endpoints](https://docs.microsoft.com/en-us/azure/storage/common/storage-private-endpoints).
                                
                            
  - Allow trusted Microsoft services to access the storage account
    > Turning on firewall rules for storage accounts blocks incoming requests for data by default, unless the requests originate from a service operating within an Azure Virtual Network (VNet) or from allowed public IP addresses. Requests that are blocked include those from other Azure services, from the Azure portal, from logging and metrics services, and so on. You can permit requests from other Azure services by adding an exception to allow trusted Microsoft services to access the storage account. For more information about adding an exception for trusted Microsoft services, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security).
                                
                            