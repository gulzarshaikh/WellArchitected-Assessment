# Service Security

This list contains design considerations and recommended configuration options, specific to individual Azure services.



# Navigation Menu

  - [Compute](#Compute)
    - [Azure Kubernetes Service (AKS)](#Azure-Kubernetes-Service-AKS)
# Compute
        
## Azure Kubernetes Service (AKS)
### Configuration Recommendations
* Security Guidelines
  - Use [Managed Identities](https://docs.microsoft.com/azure/aks/use-managed-identity) to avoid having to manage and rotate service principles.
                            
  - Utilize [AAD integration](https://docs.microsoft.com/en-us/azure/aks/managed-aad) to take advantage of centralized account management and passwords, application access management, and identity protection.
                            
  - Use Kubernetes RBAC with AAD for [least privilege](https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac) and minimize granting administrator privileges to protect configuration and secrets access.
                            
  - Limit access to Kubernetes cluster configuration file with Azure role-based access control. https://docs.microsoft.com/en-us/azure/aks/control-kubeconfig-access
                            
  - Use [Pod Identities](https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-identity#use-pod-identities) and [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure#usage) with Azure Key Vault to protect secrets, certificates, and connection strings.
                            
  - Ensure certificates are rotated often [Rotate certificates](https://docs.microsoft.com/en-us/azure/aks/certificate-rotation).
                            
  - Regularly process Linux node security and kernel updates and reboots using [kured.](https://docs.microsoft.com/en-us/azure/aks/node-updates-kured)
                            
  - Use Azure Security Center to provide AKS recommendations.
                            
* Ensure proper selection of Network Plug-in [Kubenet vs. Azure CNI](https://docs.microsoft.com/en-us/azure/aks/concepts-network#compare-network-models) based on network requirements and cluster sizing.
* Use [Azure Network Policies](https://docs.microsoft.com/en-us/azure/aks/use-network-policies) or Calico to control traffic between pods. **Requires CNI Network Plug-in.**
* Utlize a central monitoring tool (eg. - [Azure Monitor and App Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview)) to centrally collect metrics, logs, and diagnostics for troubleshooting purposes.
  - Enable and review Kubernetes master node logs. https://docs.microsoft.com/en-us/azure/aks/view-master-logs
                            
* Define [Pod resource requests and limits](https://docs.microsoft.com/en-us/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits) in application deployment manifests.