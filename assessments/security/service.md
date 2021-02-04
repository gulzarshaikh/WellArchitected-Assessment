# Service Security

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Compute](#Compute)
    - [Azure Kubernetes Service (AKS)](#Azure-Kubernetes-Service-AKS)
  - [Data](#Data)
    - [Azure Databricks](#Azure-Databricks)
  - [Storage](#Storage)
    - [Storage Accounts](#Storage-Accounts)
# Compute
        
## Azure Kubernetes Service (AKS)
### Configuration Recommendations
* Security Guidelines
  - Use [Managed Identities](https://docs.microsoft.com/azure/aks/use-managed-identity) to avoid having to manage and rotate service principles.
                            
  - Utilize [AAD integration](https://docs.microsoft.com/azure/aks/managed-aad) to take advantage of centralized account management and passwords, application access management, and identity protection.
                            
  - Use Kubernetes RBAC with AAD for [least privilege](https://docs.microsoft.com/azure/aks/azure-ad-rbac) and minimize granting administrator privileges to protect configuration and secrets access.
                            
  - Limit access to [Kubernetes cluster configuration](https://docs.microsoft.com/azure/aks/control-kubeconfig-access) file with Azure role-based access control.
                            
  - Limit access to [actions that containers can perform](https://docs.microsoft.com/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources). Provide the least number of permissions, and avoid the use of root / privileged escalation.
                            
  - Evaluate the use of the built-in [AppArmor security module](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-security#app-armor) to limit actions that containers can perform such as read, write, or execute, or system functions such as mounting filesystems.
                            
  - Evaluate the use of the [seccomp (secure computing)](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-security#secure-computing). seccomp works at the process level and allows you to limit the process calls that containers can perform.
                            
  - Use [Pod Identities](https://docs.microsoft.com/azure/aks/operator-best-practices-identity#use-pod-identities) and [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure#usage) with Azure Key Vault to protect secrets, certificates, and connection strings.
                            
  - Use [Azure Security Center](https://docs.microsoft.com/azure/security-center/defender-for-kubernetes-introduction) to provide AKS recommendations.
                            
  - Secure clusters and pods with Azure Policy
    > [Azure Policy](https://docs.microsoft.com/azure/aks/use-pod-security-on-azure-policy) can help to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. It can also control what functions pods are granted and if anything is running against company policy. This access is defined through built-in policies provided by the [Azure Policy Add-on for AKS](https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes). By providing additional control over the security aspects of your pod's specification, like root privileges, enables stricter security adherence and visibility into what is deployed in your cluster. If a pod does not meet conditions specified in the policy, Azure Policy can disallow the pod to start or flag a violation.
                                
                            
* Ensure proper selection of network plugin based on network requirements and cluster sizing.
  > Azure CNI is required for specific scenarios like for example Windows-based node pools, specific networking requirements and Kubernetes Network Policies. See [Kubenet vs. Azure CNI](https://docs.microsoft.com/azure/aks/concepts-network#compare-network-models) for more information.
                            
* Use [Azure Network Policies](https://docs.microsoft.com/azure/aks/use-network-policies) or Calico to control traffic between pods. **Requires CNI Network Plug-in.**
* Utilize a central monitoring tool (eg. - [Azure Monitor and App Insights](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview)) to centrally collect metrics, logs, and diagnostics for troubleshooting purposes.
  - Enable and review [Kubernetes master node logs](https://docs.microsoft.com/azure/aks/view-master-logs).
                            
  - Configure scraping of Prometheus metrics with Azure Monitor for containers
    > Azure Monitor for containers provides a seamless onboarding experience to collect Prometheus metrics. See [Configure scraping of Prometheus metrics with Azure Monitor for containers](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-prometheus-integration) for more.
                                
                            
* Define [Pod resource requests and limits](https://docs.microsoft.com/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits) in application deployment manifests.
# Data
        
## Azure Databricks
### Design Considerations
* All users&#39; notebooks and notebook results are encrypted at rest by default. If additional requirements are in place, consider using [customer-managed keys for notebooks](https://docs.microsoft.com/azure/databricks/security/keys/customer-managed-key-notebook).
### Configuration Recommendations
* Isolate your workspaces, compute and data from public access. Make sure that only the right people have access and only via secure channels.
  - Ensure that the cloud workspaces for your analytics are only accessible by properly [managed users](https://docs.microsoft.com/azure/databricks/administration-guide/users-groups/). Azure Active Directory can handle single sign-on for remote access. For additional security, see [Conditional Access](https://docs.microsoft.com/azure/databricks/administration-guide/access-control/conditional-access).
                            
  - Implement Azure Private Link and ensure that all traffic between users of your platform,the notebooks and the compute clusters that process queries is encrypted and transmitted over the cloud provider’s network backbone, inaccessible to the outside world.
                            
  - Restrict and monitor your virtual machines. Clusters which execute queries should have SSH and network access restricted to prevent installation of arbitrary packages and should use only images that are periodically scanned for vulnerabilities.
                            
  - Use Dynamic IP access lists to allow admins to access workspaces only from their corporate networks.
                            
* Use the [VNet injection](https://docs.microsoft.com/azure/databricks/administration-guide/cloud-configurations/azure/vnet-inject) functionality to enable more secure scenarios, such as:
  - Connecting to other Azure services using service endpoints.
                            
  - Connecting to on-premises data sources, taking advantage of user-defined routes.
                            
  - Connecting to a network virtual appliance to inspect all outbound traffic and take actions according to allow and deny rules.
                            
  - Using custom DNS.
                            
  - Deploying Azure Databricks clusters in existing virtual networks.
                            
* Use [diagnostic logs](https://docs.microsoft.com/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs) to audit workspace access and permissions. Use audit logs to see privileged activity in a workspace, cluster resizing, files/folders shared on the cluster etc.
* Consider using the [Secure cluster connectivity](https://docs.microsoft.com/azure/databricks/security/secure-cluster-connectivity) feature and [hub/spoke architecture](https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html) to prevent opening ports and assigning public IP addresses on cluster nodes.
* Use Azure Active Directory [credential passthrough](https://docs.microsoft.com/azure/databricks/security/credential-passthrough/adls-passthrough) to avoid the need for service principals when communicating with Azure Data Lake Storage.
### Supporting Source Artifacts
* Databricks blog: [Best practices to secure an enterprise-scale data platform](https://databricks.com/blog/2020/03/16/security-that-unblocks.html)
# Storage
        
## Storage Accounts
### Design Considerations
* Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only.
* Storage account names must be unique within Azure. No two storage accounts can have the same name.
* The current [SLA for Storage Accounts](https://azure.microsoft.com/support/legal/sla/storage/v1_5/) (v1.5, June 2019) specifies a 99.9% guarantee for LRS, ZRS and GRS accounts and a 99.99% guarantee for RA-GRS (provided that requests to RA-GRS switch to secondary endpoints if there is no success on the primary endpoint) to successfully process requests to **read data**. And at least 99.9% to successfully process requests to **write data**. SLAs for other storage tiers might differ. Go to [Azure Storage redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy) to see which redundancy option is best for a specific scenario.
### Configuration Recommendations
* Enable Azure Defender for all of your storage accounts
  > Azure Defender for Azure Storage provides an additional layer of security intelligence that detects unusual and potentially harmful attempts to access or exploit storage accounts. Security alerts are triggered in Azure Security Center when anomalies in activity occur and are also sent via email to subscription administrators, with details of suspicious activity and recommendations on how to investigate and remediate threats. For more information, see [Configure Azure Defender for Azure Storage](https://docs.microsoft.com/azure/storage/common/azure-defender-storage-configure).
                            
* Turn on soft delete for blob data
  > [Soft delete for Azure Storage blobs](https://docs.microsoft.com/azure/storage/blobs/storage-blob-soft-delete) enables you to recover blob data after it has been deleted.
                            
* Use Azure AD to authorize access to blob data
  > Azure AD provides superior security and ease of use over Shared Key for authorizing requests to Blob storage. It is recommended to use Azure AD authorization with your blob and queue applications when possible to minimize potential security vulnerabilities inherent in Shared Key. For more information, see [Authorize access to Azure blobs and queues using Azure Active Directory](https://docs.microsoft.com/azure/storage/common/storage-auth-aad).
                            
  - Keep in mind the principal of least privilege when assigning permissions to an Azure AD security principal via Azure RBAC
    > When assigning a role to a user, group, or application, grant that security principal only those permissions that are necessary for them to perform their tasks. Limiting access to resources helps prevent both unintentional and malicious misuse of your data.
                                
                            
  - Use Managed Identities to access blob and queue data
    > Azure Blob and Queue storage support Azure AD authentication with [managed identities for Azure resources](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview). Managed identities for Azure resources can authorize access to blob and queue data using Azure AD credentials from applications running in Azure virtual machines (VMs), function apps, virtual machine scale sets, and other services. By using managed identities for Azure resources together with Azure AD authentication, you can avoid storing credentials with your applications that run in the cloud as well as issues with expiring service principals. See [Authorize access to blob and queue data with managed identities for Azure resources](https://docs.microsoft.com/azure/storage/common/storage-auth-aad-msi) for more information.
                                
                            
* Use blob versioning or immutable blobs to store business-critical data
  > Consider using [Blob versioning](https://docs.microsoft.com/azure/storage/blobs/versioning-overview) to automatically maintain previous versions of an object or the use of legal holds and time-based retention policies to store blob data in a WORM (Write Once, Read Many) state. Blobs stored immutably can be read, but cannot be modified or deleted for the duration of the retention interval. For more information, see [Store business-critical blob data with immutable storage](https://docs.microsoft.com/azure/storage/blobs/storage-blob-immutable-storage).
                            
* Enable the Secure transfer required option on all of your storage accounts
  > When you enable the Secure transfer required option, all requests made against the storage account must take place over secure connections. Any requests made over HTTP will fail. For more information, see [Require secure transfer in Azure Storage](https://docs.microsoft.com/azure/storage/common/storage-require-secure-transfer).
                            
  - Limit shared access signature (SAS) tokens to HTTPS connections only
    > Requiring HTTPS when a client uses a SAS token to access blob data helps to minimize the risk of eavesdropping. For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-sas-overview).
                                
                            
  - Avoid/prevent using Shared Key authorization to access Storage Accounts
    > It is recommended to use Azure AD to authorize requests to Azure Storage and possible to [prevent Shared Key Authorization](https://docs.microsoft.com/azure/storage/common/shared-key-authorization-prevent). For scenarios that require Shared Key authorization, always prefer SAS tokens over distributing the Shared Key.
                                
                            
  - Regenerate your account keys periodically
    > Rotating the account keys periodically reduces the risk of exposing your data to malicious actors.
                                
                            
  - Have a revocation plan in place for any SAS that you issue to clients
    > If a SAS is compromised, you will want to revoke that SAS as soon as possible. To revoke a user delegation SAS, revoke the user delegation key to quickly invalidate all signatures associated with that key. To revoke a service SAS that is associated with a stored access policy, you can delete the stored access policy, rename the policy, or change its expiry time to a time that is in the past.
                                
                            
  - Use near-term expiration times on an ad hoc SAS, service SAS or account SAS
    > If a SAS is compromised, it's valid only for a short time. This practice is especially important if you cannot reference a stored access policy. Near-term expiration times also limit the amount of data that can be written to a blob by limiting the time available to upload to it. Clients should renew the SAS well before the expiration, in order to allow time for retries if the service providing the SAS is unavailable.
                                
                            
* Restrict default Internet access for Storage Accounts
  > By default network access to Storage Accounts is not restricted and open to all traffic coming from the Internet. Access to storage accounts should be granted to specific [Azure Virtual Networks only](https://docs.microsoft.com/azure/storage/common/storage-network-security) whenever possible or use [private endpoints](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) to allow clients on a virtual network (VNet) to securely access data over a [Private Link](https://docs.microsoft.com/azure/private-link/private-link-overview). See [Use private endpoints for Azure Storage](https://docs.microsoft.com/azure/storage/common/storage-private-endpoints) for more. Exception can be made for Storage Accounts that need to be accessible via the Internet.
                            
  - Enable firewall rules
    > Configure firewall rules to limit access to your storage account to requests that originate from specified IP addresses or ranges, or from a list of subnets in an Azure Virtual Network (VNet). For more information about configuring firewall rules, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security).
                                
                            
  - Limit network access to specific networks
    > [Limiting network access](https://docs.microsoft.com/azure/storage/common/storage-network-security) to networks hosting clients requiring access reduces the exposure of your resources to network attacks either by using the built-in [Firewall and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security) functionality or by using [private endpoints](https://docs.microsoft.com/azure/storage/common/storage-private-endpoints).
                                
                            
  - Allow trusted Microsoft services to access the storage account
    > Turning on firewall rules for storage accounts blocks incoming requests for data by default, unless the requests originate from a service operating within an Azure Virtual Network (VNet) or from allowed public IP addresses. Requests that are blocked include those from other Azure services, from the Azure portal, from logging and metrics services, and so on. You can permit requests from other Azure services by adding an exception to allow trusted Microsoft services to access the storage account. For more information about adding an exception for trusted Microsoft services, see [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/azure/storage/common/storage-network-security).
                                
                            