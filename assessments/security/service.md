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
* The current [SLA for Storage Accounts](https://azure.microsoft.com/en-us/support/legal/sla/storage/v1_5/) (v1.5, June 2019) specifies a 99.9% guarantee for LRS, ZRS and GRS accounts and a 99.99% guarantee for RA-GRS (provided that requests to RA-GRS switch to secondary endpoints if there is no success on the primary endpoint).
### Configuration Recommendations
* Enable Azure Defender for all of your storage accounts
  > Azure Defender for Azure Storage provides an additional layer of security intelligence that detects unusual and potentially harmful attempts to access or exploit storage accounts. Security alerts are triggered in Azure Security Center when anomalies in activity occur and are also sent via email to subscription administrators, with details of suspicious activity and recommendations on how to investigate and remediate threats. For more information, see [Configure Azure Defender for Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/azure-defender-storage-configure).
                            
* Turn on soft delete for blob data
  > Soft delete enables you to recover blob data after it has been deleted. For more information on soft delete, see [Soft delete for Azure Storage blobs](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-soft-delete).
                            
* Store business-critical data in immutable blobs
  > Configure legal holds and time-based retention policies to store blob data in a WORM (Write Once, Read Many) state. Blobs stored immutably can be read, but cannot be modified or deleted for the duration of the retention interval. For more information, see [Store business-critical blob data with immutable storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-immutable-storage).
                            
* Limit shared access signature (SAS) tokens to HTTPS connections only
  > Requiring HTTPS when a client uses a SAS token to access blob data helps to minimize the risk of eavesdropping. For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview).
                            
* Restrict Default Network Access for Storage Accounts
  > Access to storage accounts should be granted to specific Azure Virtual Networks only whenever possible or use [private](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) endpoints to allow clients on a virtual network (VNet) to securely access data over a [Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview). See [Use private endpoints for Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-private-endpoints) for more. Expections are Storage Accounts that need to be accessible via the Internet.
                            