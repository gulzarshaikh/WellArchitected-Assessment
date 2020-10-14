# Application Security

# Navigation Menu
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [General](#General)
    - [Unassigned](#Unassigned)
  - [Application Design](#Application-Design)
    - [Design](#Design)
    - [Application Composition](#Application-Composition)
    - [Threat Analysis](#Threat-Analysis)
    - [Security Criteria &amp; Data Classification](#Security-Criteria--Data-Classification)
    - [Dependencies, frameworks and libraries](#Dependencies-frameworks-and-libraries)
  - [Health Modelling](#Health-Modelling)
    - [Application Level Monitoring](#Application-Level-Monitoring)
    - [Auditing](#Auditing)
  - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Connectivity](#Connectivity)
    - [Endpoints](#Endpoints)
    - [Data flow](#Data-flow)
  - [Security &amp; Compliance](#Security--Compliance)
    - [Encryption](#Encryption)
  - [Operational Procedures](#Operational-Procedures)
    - [Configuration &amp; Secrets Management](#Configuration--Secrets-Management)
    - [Patch &amp; Update Process (PNU)](#Patch--Update-Process-PNU)
    - [Incident Response](#Incident-Response)
  - [Deployment &amp; Testing](#Deployment--Testing)
    - [Application Deployments](#Application-Deployments)
    - [Build Environments](#Build-Environments)
    - [Testing &amp; Validation](#Testing--Validation)
  - [Operational Model &amp; DevOps](#Operational-Model--DevOps)
    - [General](#General)
    - [Roles &amp; Responsibilities](#Roles--Responsibilities)
  - [Identity &amp; Access Control](#Identity--Access-Control)
    - [Separation of duties](#Separation-of-duties)
    - [Control-plane RBAC](#Controlplane-RBAC)
    - [Authentication and authorization](#Authentication-and-authorization)



# Application Assessment Checklist
## General
    
### Unassigned
            
* Is the organization using a Landing Zone concept and how was it implemented?


  _The purpose of the “Landing Zone” is to ensure that when a workload lands on Azure, the required “plumbing” is already in place, providing greater agility and compliance with enterprise security and governance requirements. This is crucial, that a Landing Zone will be handed over to the workload owner with the security guardrails deployed._
* Are Azure policies used to enforce security and compliance configuration?


  _Azure Policy should be used to enforce and report a compliant configuration of Azure services. Azure policies can be use on multiple levels. It is recommended to apply organizational wide security controls on Azure platform level. These policies build the guardrails of a landing zone._
## Application Design
    
### Design
            
* Are there any regulatory or governance requirements?


  _Regulatory requirements may mandate that operational data, such as application logs and metrics, remain within a certain geo-political region. This has obvious implications for how the application should be operationalized._
  > Make sure that all regulatory requirements are known and well understood. Create processes for obtaining attestations and be familiar with the [Microsoft Trust Center](https://www.microsoft.com/trust-center). Regulatory requirements like data sovereignty and others might affect the overall architecture as well as the selection and configuration of specific PaaS and SaaS services.
* Are errors and exceptions handled properly without exposing information to users?


  _Providing unnecessary information to end users in case of application failure should be avoided. Revealing detailed error information (call stack, SQL queries, out of range errors...) can provide attackers with valuable information about the internals of the application. Error handlers should make the application fail gracefully and log the error._
* Is platform-specific information removed from server-client communication?


  _Information revealing the application platform, such as HTTP banners containing framework information ("`X-Powered-By`", "`X-ASPNET-VERSION`"), are commonly used by malicious actors when mapping attack vectors of the application. HTTP headers, error messages, website footers etc. should not contain information about the application platform. Azure CDN or Cloudflare can be used to separate the hosting platform from end users, Azure API Management offers [transformation policies](https://docs.microsoft.com/azure/api-management/api-management-transformation-policies) that allow to modify HTTP headers and remove sensitive information._
### Application Composition
            
* What Azure services are used by the application?


  _It is important to understand what Azure services, such as App Services and Event Hub, are used by the application platform to host both application code and data._
  > All Azure services in use should be identified.
    - What Azure services are used by the application?


      _It is important to understand what Azure services, such as App Services and Event Hub, are used by the application platform to host both application code and data._

      > All Azure services in use should be identified.
    - What Azure services are used by the application?


      _It is important to understand what Azure services, such as App Services and Event Hub, are used by the application platform to host both application code and data._

      > All Azure services in use should be identified.
### Threat Analysis
            
* Does the organization identify the highest severity threats to this workload via threat modeling?


  _Threat modeling is an engineering technique which can be used to help identify threats, attacks, vulnerabilities and countermeasures that could affect an application. Threat modeling consists of: defining security requirements, identifying threats, mitigating threats, validating threat mitigation. Microsoft uses [STRIDE](https://docs.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) for threat modeling.  This might be the right time to talk through the STRIDE methodology and then the tools available to help them with Threat Modeling.  There are tools like [Microsoft Threat Modeling Tool](https://docs.microsoft.com/azure/security/develop/threat-modeling-tool-getting-started) which can help.Determine if they understand the attack vectors of their solution with this question. Get them to discuss the defense in depth that they have around the identified threats and how they are detecting, protecting, and responding to a potential attack. Try to uncover how they identified the threats and communicated those to all interested parties or if rather are hoping no one finds out. This question should set the stage for the audience that needs to be involved and the topics that will be discussed throughout the assessment._
* How are threats addressed once found?


  _The threat modeling tool will produce a report of all the threats identified. This report is typically uploaded into a tracking tool or work items that can be validated and addressed by the developers. Cyber security teams can also use the report to determine attack vectors during a penetration test.  As new features are added to the solution, the threat model should be updated and integrated into the code management process.  If a security issue is found, there should be a process to triage the issue into the next release cycle or a faster release, depending on the severity.  Try to understand what process they use, if any, to prioritize security fixes._
* How long does it typically take to deploy a security fix into production?


  _Get an understanding of how the customer is updating when a security vulnerability is discovered in their software. Get them to talk through the process and tools, approvals, who they make aware and if they have executive sponsorship to bypass lengthy processes when it comes to security. How serious are they about security updates?_
### Security Criteria &amp; Data Classification
            
* How do you monitor and maintain your compliance?


  _Find out how they make sure they maintain compliance as the Azure Platform evolves and they update their application. Are there things preventing them from adopting new features in the platform because it will knock them out of compliance?_
* How often do you have internal and external audits?


  _Determine the process the customer uses for auditing the solution. Is it done internally, external, or both. How are findings reflected back to the application? Is everyone aware of the audit and involved or is it done in a silo. This will help reduce the firefighting mentality when there is a finding and stress of performing updates._
### Dependencies, frameworks and libraries
            
* Does the application team maintain a list frameworks and libraries?


  _As part of the application inventory the application team should maintain a framework and library list, along with versions in use._
* Are frameworks and library updates included into the application lifecycle?


  _Application frameworks are frequently provided with updates (e.g. security), released by the vendor or communities. Critical and important security patches need to be prioritized._
## Health Modelling
    
### Application Level Monitoring
            
* How is security monitored in the application context?


  _Organization is monitoring the security posture across workloads and central SecOps team is monitoring security-related telemetry data and investigating security breaches. Communication, investigation and hunting activities need to be aligned with the application team._
* Does the organization actively monitor identity related risk events related to potentially compromised identities?


  _Most security incidents take place after an attacker initially gains access using a stolen identity. These identities can often start with low privileges, but attackers then use that identity to traverse laterally and gain access to more privileged identities. This repeats as needed until the attacker controls access to the ultimate target data or systems. Reported risk events for Azure AD can be viewed in Azure AD reporting, or Azure AD Identity Protection. Additionally, the Identity Protection risk events API can be used to programmatically access identity related security detections using Microsoft Graph._
* Is Personally identifiable information (PII) detected and removed/obfuscated automatically?


  _Extra care should be take around logging of sensitive application areas. PII (contact information, payment information etc.) should not be stored in any application logs and protective measures should be applied (such as obfuscation). Machine learning tools like [Cognitive Search PII detection](https://docs.microsoft.com/azure/search/cognitive-search-skill-pii-detection) can help with this._
### Auditing
            
* Is access to the control plane and data plane of the application periodically reviewed?


  _As people in the organization and on the project change, it is crucial to make sure that only the right people have access to the application infrastructure. Auditing and reviewing the access control reduces the attack vector to the application. Azure control plane depends on Azure AD and access reviews are often centrally performed often as part of internal or external audit activities. For the application specific access it is recommended to do the same at least twice a year._
## Networking &amp; Connectivity
    
### Connectivity
            
* Are network restrictions used for non-public services?


  _Azure provides networking solutions to restrict access to individual application services. Multiple levels (such as IP filtering or firewall rules) should be explored to prevent application services from being accessed by unauthorized actors._
* Is communication to Azure PaaS services secured using VNet Service Endpoints or Private Link?


  _[Service Endpoints](https://docs.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview) and [Private Link](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) can be leveraged to restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios)._
* If data exfiltration concerns exist for services where Private Link is not yet supported, is filtering via Azure Firewall or NVA (Network Virtual Appliance) being used?


  _NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported (Azure Firewall)._
* Are Network Security Groups (NSGs) being used?


  _If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked._
    - Are Network Security Groups (NSGs) being used?


      _If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked._

### Endpoints
            
* Is there a clear distinction between endpoints exposed to public internet and internal ones?


  _Web applications typically have one public entrypoint and don't expose subsequent APIs and database servers over the internet. When using gateway services like [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/) it's possible to restrict access only to a set of Front Door IP addresses and lock down the infrastructure completely._
* Are all external application endpoints secured?


  _External application endpoints should be protected against common attack vectors, such as Denial of Service (DoS) attacks like Slowloris, to prevent potential application downtime due to malicious intent. Azure-native technologies such as Azure Firewall, Application Gateway/Azure Front Door WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection (Azure DDoS Protection)._
* Are public endpoints protected with firewall or WAF (Web Application Firewall)?


  _[Azure Firewall](https://docs.microsoft.com/azure/firewall/features) is a managed, cloud-based network security service that protects Azure Virtual Network resources. [Web Application Firewall](https://docs.microsoft.com/azure/web-application-firewall/ag/ag-overview) (WAF) protects web applications against common attacks like cross-site scripting or SQL injection._
* Are application publishing methods restricted and protected?


  _Application resources allowing multiple methods to publish app content (e.g FTP, Web Deploy) should have the unused endpoints disabled. For Azure Web Apps SCM is the recommended endpoint and it can be protected separately with network restrictions for sensitive scenarios. Developers shouldn't publish their code directly to app servers - automated and gated CI/CD process should manage this._
### Data flow
            
* Are there controls in place to detect and protect from data exfiltration?


  _Data exfiltration occurs when an internal/external malicious actor performs and unauthorized data transfer. The solution should leverage a layered approach such as, hub/spoke for network communications with deep packet inspection to detect/protect from a data exfiltration attack. Azure Firewall, UDR (User-defined Routes), NSG (Network Security Groups), Key Protection, Data Encryption, PrivateLink, and Private Endpoints are layered defenses for a data exfiltration attack. Azure Sentinel and Azure Security Center can be used to detect data exfiltration attempts and alert incident responders._
* Are there controls in place to control traffic between subnets, Azure components and tiers in the application?


  _Data filtering between subnets and other Azure resources should be protected. Network Security Groups, PrivateLink, and Private Endpoints can be used for traffic filtering._
## Security &amp; Compliance
    
### Encryption
            
* Does the organization use industry standard encryption algorithms instead of creating their own?


  _Organizations should rarely develop and maintain their own encryption algorithms. Secure standards already exist on the market and should be preferred. AES should be used as symmetric block cipher, AES-128, AES-192 and AES-256 are acceptable. Crypto APIs built into operating systems should be used where possible, instead of non-platform crypto libraries. For .NET make sure you follow the [.NET Cryptography Model](https://docs.microsoft.com/dotnet/standard/security/cryptography-model)._
* Is the client-server communication encrypted?


  _Any network communication between client and server where man-in-the-middle attack can occur, needs to be encrypted. All website communication should use HTTPS, no matter the perceived sensitivity of transferred data (man-in-the-middle attacks can occur anywhere on the site, not just on login forms)._
* What TLS version is used across workloads?


  _All Microsoft Azure services fully support TLS 1.2. It is recommended to migrate solutions to support **TLS 1.2** and use this version by default. TLS 1.3 is not available on Azure yet, but should be the preferred option once implemented on the platform._
* Are modern hashing functions used?


  _Applications should use the **SHA-2** family of hash algorithms (SHA-256, SHA-384, SHA-512)._
* If using own data encryption keys (for encryption at rest), are they stored securely?


  _Keys must be stored in a secure location with identity-based access control and audit policies. Data encryption keys are often encrypted with a key encryption key in Azure Key Vault to further limit access._
* How is data at rest protected?


  _This includes all information storage objects, containers, and types that exist statically on physical media, whether magnetic or optical disk.  All data should be classified and encrypted with an encryption standard.  How is the data classified and tagged as such so that it can be audited._
* How is data in transit secured?


  _When data is being transferred between components, locations, or programs, it’s in transit. Data in transit should be encrypted at all points to ensure data integrity. For example: web applications and APIs should use HTTPS/SSL for all communication with clients and also between each other (in micro-services architecture)._
    - How is data in transit secured?


      _When data is being transferred between components, locations, or programs, it’s in transit. Data in transit should be encrypted at all points to ensure data integrity. For example: web applications and APIs should use HTTPS/SSL for all communication with clients and also between each other (in micro-services architecture)._

## Operational Procedures
    
### Configuration &amp; Secrets Management
            
* Where is application configuration information stored and how does the application access it?


  _Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault_
  > Preferably configuration information is stored using a dedicated configuration management system like Azure App Configuration or Azure Key Vault so that it can be updated independently of the application code.
* How are passwords and other secrets managed?


  _Are secrets stored in a specially protected way or in the same way as any other application configuration?_
  > Tools like Azure Key Vault or HashiCorp Vault should be used to store and manage secrets securely rather than being baked into the application artefact during deployment, as this simplifies operational tasks like key rotation as well as improving overall security. Keys and secrets stored in source code should be identified with static code scanning tools. Ensure that these scans are an integrated part of the continuous integration (CI) process.
* Do you have procedures in place for key/secret rotation?


  _In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Key rotation reduces the attack vectors and should be automated and executed without any human interactions._
  > Secrets (keys, certificates etc.) should be replaced once they have reached the end of their active lifetime or once they have been compromised. Renewed certificates should also use a new key. A process needs to be in place for situations where keys get compromised (leaked) and need to be regenerated on-demand. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with rotation processes([Key Vault Key Rotation](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual))
* Are the expiry dates of SSL certificates monitored and are processes in place to renew them?


  _Expired SSL certificates are one of the most common yet avoidable causes of application outages; even Azure and more recently Microsoft Teams have experienced outages due to expired certificates._
  > Tracking expiry dates of SSL certificates and renewing them in due time is therefore highly critical. Ideally the process should be automated, although this often depends on leveraged CA. If not automated, sufficient alerting should be applied to ensure expiry dates do not go unnoticed
* Are Azure policies used to control the configuration of the solution resources?


  _Azure Policy should be used to deploy desired settings where applicable. Azure resources should be blocked that do not meet the proper security requirements defined during service enablement._
* Does an access model exist and has it been implemented for Key Vaults to grant access to keys and secrets?


  _Permissions to keys and secrets have to be controlled with a [access model](https://docs.microsoft.com/azure/key-vault/general/secure-your-key-vault)._
* Who is responsible to manage the keys and secrets for the application?


  _Central SecOps team provides guidance on how keys and secrets are managed (governance), application DevOps team is responsible to manage the application related keys and secrets._
* What types of keys and secrets are used and how are those generated?


  _Different approaches can be used by the workload team. Decisions are often driven by security, compliance and specific data classification requirements. Understanding these requirements is important to determine which key types are best suitable (MMK - Microsoft-managed Keys, CMK - Customer-managed Keys or BYOK - Bring Your Own Key)._
### Patch &amp; Update Process (PNU)
            
* Does the organization reduce the count and potential severity of security vulnerabilities for this workload by implementing security practices and tools during the development lifecycle? [Develop Secure Applications on Azure whitepaper](https://azure.microsoft.com/resources/develop-secure-applications-on-azure/)


  _Security vulnerabilities can result in an application disclosing confidential data, allowing criminals to alter data/records, or the data/application becoming unavailable for use by customers and employees. Applications will almost always contain logic errors, so it is important to discover, evaluate, and correct them to avoid damage to the organization’s reputation, revenue, or margins. This is made easier by discovering these vulnerabilities in the early stages of the development cycle._
### Incident Response
            
* Are operational processes for incident response defined and tested?


  _Actions executed during an incident and response investigation could impact application availability or performance. It is recommended to define these processes and align them with the responsible (and in most cases central) SecOps team. The impact of such an investigation on the application has to be analyzed._
* Are there playbooks built to help incident responders quickly understand the application and components to do an investigation?


  _Incident responders are part of a central SecOps team and need to understand security insights of an application. Playbooks can help to understand the security concepts and cover the typical investigation activities._
## Deployment &amp; Testing
    
### Application Deployments
            
* Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?


  _N-1 and N+1 refer to roll-back and roll-forward._
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle
* Is credential scanning included as part of automated build process?


  _Credentials should not be stored in source code or configuration files, because that increases the risk of exposure. Code analyzers (such as Roslyn analyzers for Visual Studio) can prevent from pushing credentials to source code repository and pipeline addons such as CredScan (part of Microsoft Security Code Analysis) help to catch credentials during the build process._
* How are credentials, certificates and other secrets managed in CI/CD pipelines?


  _Secrets need to be managed in a secure manner inside of the CI/CD pipeline. The secrets needs to be stored either in a secure store inside the pipeline or externally in Azure Key Vault. When deploying application infrastructure (e.g. with Azure Resource Manager or Terraform), credentials and keys should be generated during the process, stored directly in Key Vault and referenced by deployed resources. Hardcoded credentials should be avoided._
* Is code scan included in continuos integration (CI) process and are dependencies and framework components covered by this process?


  _As part of the continuous integration process it is crucial that every release includes a scan of all components in use. Vulnerable dependencies should be flagged and investigated. This can done in combination with other code scanning tasks (e.g. code churn, test results/coverage)._
* Are branch policies used in source control management? How are they configured?


  _Branch policies provide additional level of control over the code which is commited to the product. It is a common practice to not allow pushing against the main branch and require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author. Different branches can have different purposes and access levels, for example: feature branches are created by developers and are open to push, integration branch requires PR and code-review and production branch requires additional approval from a senior developer before merging._
### Build Environments
            
* Are self-hosted build agents used in the Azure DevOps CI/CD pipelines?


  _When the organization uses their own build agents it adds management complexity and can become an attack vector. Build machine credentials must be stored securely and file system needs to be cleaned of any temporary build artifacts regularly. Network isolation can be achieved by only allowing outgoing traffic from the build agent, because it's using pull model of communication with Azure DevOps._
### Testing &amp; Validation
            
* Are you using Azure Security Center (ASC) to scan containers for vulnerabilities? Or any third-party solution?


  _Azure Security Center is the Azure-native solution for securing containers. Security Center can protect virtual machines that are running Docker, Azure Kubernetes Service clusters, Azure Container Registry registries. ASC is able to scan container images and identify security issues, or provide real-time threat detection for containerized environments. [Container Security in Security Center](https://docs.microsoft.com/azure/security-center/container-security)_
* Does the organization perform penetration testing or have a third-party entity perform penetration testing to validate the current security defenses put in place?


  _Real world validation of security defenses is critical to validate a defense strategy and implementation. Penetration tests or red team programs can be used to simulate either one time, or persistent threats against an organization to validate defenses that have been put in place to protect organizational resources._
## Operational Model &amp; DevOps
    
### General
            
* Has the organization adopted a formal DevOps approach to building and maintaining software to ensure security and feature enhancements can be deployed in rapid fashion?


  _The DevOps approach increases the organization’s ability to rapidly address security concerns without waiting for a longer planning and testing cycle of traditional waterfall model. Key attributes are: automation, close integration of infra and dev teams, testability and reliability and repeatability of deployments.* [Adopt the DevOps approach](https://docs.microsoft.com/azure/architecture/framework/Security/applications-services#adopt-the-devops-approach)_
* Does the organization leverage DevOps security guidance based on industry lessons-learned, and available automation tools (OWASP guidance, Microsoft toolkit for Secure DevOps etc.)?


  _Organizations should leverage a control framework such as NIST, CIS or ASB [(Azure Security Benchmarks)](https://docs.microsoft.com/azure/security/benchmarks/) for securing applications on the cloud rather than starting from zero._
### Roles &amp; Responsibilities
            
* Do you have release gate approvals so that security teams can evaluate new features/code updates?


  _Pull Requests and code reviews serve as the first line of approvals during development cycle. Before releasing new code to production (new features, bugfixes etc.), security review and approval should be required._
* Is the security team involved in the planning and design so that they can implement security controls, auditing, response processes into the solutions?


  _There should be a process for onboarding service securely to Azure.  The onboarding process should include reviewing the configuration options to determine what logging/monitoring needs to be established, how to properly harden a resource before it goes into production.  For a list of common criteria for onboarding resoruces, see the [Service Enablement Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#service-enablement-framework)_
## Identity &amp; Access Control
    
### Separation of duties
            
* Does the application team have a clear view on responsibilities and individual/group access levels?


  _Application roles and responsibility model need to be defined covering the different access level of each operational function (e.g publish production release, access customer data, manipulate database records). It's in the interest of the application team to include central functions (e.g. SecOps, NetOps, IAM) into this view._
* Has role-based and/or resource-based authorization been configured within Azure AD?


  _Role-based and resource-based authorization are common approaches to authorize users based on required permission scopes. [Role-based and resource-based](https://docs.microsoft.com/azure/architecture/multitenant-identity/authorize)_
* Are authentication tokens cached securely and encrypted when sharing across web servers?


  _Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability. Tokens should be stored securely and handled as any other credentials. When there's a need to share tokens across application servers (instead of each server acquiring and caching their own) encryption should be used. [Acquire and cache tokens](https://docs.microsoft.com/azure/active-directory/develop/msal-acquire-cache-tokens)_
* Are there any processes and tools leveraged to manage privileged activities?


  _Zero-trust principle comes with the requirement of no standing access to an environment. Native and 3rd party solution can be used to elevate access permissions for at least highly privileged if not all activities. [Azure AD Privileged Identity Management](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure) (Azure AD PIM) is the recommended and Azure native solution._
### Control-plane RBAC
            
* Is the application infrastructure protected with RBAC (role-based access control)?


  _RBAC provides the necessary tools to maintain separation of concerns when it comes to accessing the application infrastructure. Aligned with the [separation of duties](#separation-of-duties) section, users should have only the minimal set of permissions. Examples: "Developers can't access production infrastructure.", "Only the SecOps team can read and manage Key Vault secrets.", "Project A team can access and manage Resource Group A and all resources within."_
* Are there resource locks applied on critical parts of the infrastructure?


  _To prevent deleting or modifying resources, Azure offers the locking functionality where only specific roles and users with permissions are able to delete/modify resources. Locks can be used on critical parts of the infrastructure, but special care needs to be taken in the DevOps process - modification locks can sometimes block automation._
* Is there a direct access to the application infrastructure through Azure Portal, Command-line Interface (CLI) or REST API?


  _While it is recommended to deploy application infrastructure via automation and CI/CD. To maximize application autonomy and agility, restrictive access control need be balanced on less critical development and test environments._
* Are CI/CD pipeline roles clearly defined and permissions set?


  _Azure DevOps offers pre-defined roles which can be assigned to individual users of groups. Using them properly can make sure that for example only users responsible for production releases are able to initiate the process and that only developers can access the source code. Variable groups often contain sensitive configuration information and can be protected as well._
### Authentication and authorization
            
* How is the application authenticated when communicating with Azure platform services?


  _Try to avoid authentication with keys (connection strings, API keys etc.) and always prefer Managed Identities (formerly also known as Managed Service Identity, MSI). Managed identities enable Azure Services to authenticate to each other without presenting explicit credentials via code. Typical use case is a Web App accessing Key Vault credentials or a Virtual Machine accessing SQL Database. [Managed identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/)_
* What kind of authentication is required by application APIs?


  _API URLs used by client applications are exposed to attackers (JavaScript code on a website can be viewed, mobile application can be decompiled and inspected) and should be protected. For internal APIs, requiring authentication can increase the difficulty of lateral movement if an attacker obtains network access. Typical mechanisms include API keys, authorization tokens, IP restrictions or Azure Managed identities._
* How is user authentication handled in the application?


  _If possible, applications should utilize Azure Active Directory or other managed identity providers (such as Microsoft Account, Azure B2C...) to avoid managing user credentials with custom implementation. Modern protocols like OAuth 2.0 use token-based authentication with limited timespan, identity providers offer additional functionality like multi-factor authentication, password reset etc._
* Are there any conditional access requirements for the application?


  _Modern cloud-based applications are often accessible over the internet and location-based networking restrictions don't make much sense, but it needs to be mapped and understood what kind of restrictions are required. Multi-factor Authentication (MFA) is a necessity for remote access, IP-based filtering can be used to enable ad-hoc debugging, but VPNs are preferred._
* Does the organization prioritize authentication via identity services for this workload vs. cryptographic keys?


  _Consideration should always be given to authenticating with identity services rather than cryptographic keys when available. Managing keys securely with application code is difficult and regularly leads to mistakes like accidentally publishing sensitive access keys to code repositories like GitHub. Identity systems (such as Azure Active Directory) offer secure and usable experience for access control with built-in sophisticated mechanisms for key rotation, monitoring for anomalies, and more._
