# Application Security

# Navigation Menu

- [Design Principles](#design-principles)
- [Application Assessment Checklist](#Application-Assessment-Checklist)
  - [Application Design](#Application-Design)
    - [Design](#Design)
    - [Dependencies](#Dependencies)
    - [Application Composition](#Application-Composition)
    - [Threat Analysis](#Threat-Analysis)
    - [Security Criteria &amp; Data Classification](#Security-Criteria--Data-Classification)
    - [Dependencies, frameworks and libraries](#Dependencies-frameworks-and-libraries)
  - [Health Modelling &amp; Monitoring](#Health-Modelling--Monitoring)
    - [Application Level Monitoring](#Application-Level-Monitoring)
    - [Resource and Infrastructure Level Monitoring](#Resource-and-Infrastructure-Level-Monitoring)
    - [Auditing](#Auditing)
  - [Networking &amp; Connectivity](#Networking--Connectivity)
    - [Connectivity](#Connectivity)
    - [Endpoints](#Endpoints)
    - [Data flow](#Data-flow)
  - [Security &amp; Compliance](#Security--Compliance)
    - [Security Center](#Security-Center)
    - [Network Security](#Network-Security)
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
    - [Common Engineering Criteria](#Common-Engineering-Criteria)
  - [Identity &amp; Access Control](#Identity--Access-Control)
    - [Separation of duties](#Separation-of-duties)
    - [Control-plane RBAC](#Control-plane-RBAC)
    - [Authentication and authorization](#Authentication-and-authorization)


# Design Principles

The following Design Principles provide context for questions, why a certain aspect is important and how is it applicable to Security.

These critical design principles are used as lenses to assess the Security of an application deployed on Azure, providing a framework for the application assessment questions that follow.


## Plan resources and determine how to harden them


  Ensure that security is taken into account when resources used by this workload are planned, and that it's understood how individual cloud services are protected. Use a service enablement framework to evaluate.



## Automate and use least privilege


  Implement least privilege throughout the application and control plane to protect against data exfiltration and malitious actor scenarios. Drive automation through DevSecOps to minimize the need for human interaction.



## Classify and encrypt Data


  Classify data according to risk and apply industry standard encryption at rest and in transit holistically, ensuring keys and certificates are stored securely and managed properly.



## Monitor security of entire system and plan incident responses


  Correlate security and audit events to model application health and identify active threats. Establish automated and manual procedures to respond to incidents leveraging SIEM tooling for tracking.



## Identify and protect endpoints


  Monitor and protect the network integrity of internal and external endpoints through security appliances, such as firewalls or web application firewalls. Use industry standard approaches to protect against common attack vectors, such as DDoS (e.g. SlowLoris).



## Protect against code level vulnerabilities


  Identify and mitigate code-level vulnerabilities (e.g. cross-site scripting, SQL injection). Regularly incorporate security fixes and patching of all parts of the codebase, including dependencies, into the operational lifecycle.



## Model and test against potential threats


  Establish procedures to identify and mitigate known threats. Use penetration testing to verify threat mitigation, as well as static code analysis and code scanning to detect and prevent future vulnerabilities.




---



# Application Assessment Checklist
## Application Design
    
### Design
            
* Are there any regulatory or governance requirements for this workload?


  _Regulatory requirements may mandate that operational data, such as application logs and metrics, remain within a certain geo-political region. This has obvious implications for how the application should be operationalized._
  > Make sure that all regulatory requirements are known and well understood. Create processes for obtaining attestations and be familiar with the [Microsoft Trust Center](https://www.microsoft.com/trust-center). Regulatory requirements like data sovereignty and others might affect the overall architecture as well as the selection and configuration of specific PaaS and SaaS services.
* Are Azure Tags used to enrich Azure resources with operational metadata?


  _Using tags can help to manage resources and make it easier to find relevant items during operational procedures._
  > Azure Tags provide the ability to associate critical metadata as a name-value pair, such as billing information (e.g. cost center code), environment information (e.g. environment type), with Azure resources, resource groups, and subscriptions. See [Tagging Strategies](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging) for best practices.
* Does the workload hide detailed error messages / verbose information from the end user / client?


  _Providing unnecessary information to end users in case of application failure should be avoided. Revealing detailed error information (call stack, SQL queries, out of range errors...) can provide attackers with valuable information about the internals of the application. Error handlers should make the application fail gracefully and log the error._
  > Do not expose security details in error messages. Handle exceptions and failures gracefully (with retry logic) and log them for further inspection.
* Is platform-specific information (e.g. web server version) removed from server-client communication channels in this workload?


  _Information revealing the application platform, such as HTTP banners containing framework information ("`X-Powered-By`", "`X-ASPNET-VERSION`"), are commonly used by malicious actors when mapping attack vectors of the application. HTTP headers, error messages, website footers etc. should not contain information about the application platform. Azure CDN or Cloudflare can be used to separate the hosting platform from end users, Azure API Management offers [transformation policies](https://docs.microsoft.com/azure/api-management/api-management-transformation-policies) that allow to modify HTTP headers and remove sensitive information._
  > Remove platform-specific information from HTTP headers, error messages, web site content (e.g. page footer).
    - Does the workload use API Management or Azure Front Door to modify HTTP headers and remove sensitive information?


      _Azure API Management and Azure Front Door offers transformation policies that allow to modify HTTP headers and remove sensitive information._

      > Remove sensitive information from HTTP headers with Azure API Management or Azure Front Door.
    - Does this workload use CDN (content delivery network) solutions to separate the hosting platform from the end users / clients?


      _Azure CDN can be used to separate the hosting platform from end users. Azure CDN contains a rule engine to remove platform-specific information and headers. The use of Azure CDN or 3rd party CDN will have different cost implications depending on what is chosen for the workload._

      > Use CDN to separate the hosting platform from the end users / clients.
* Does the organization use cloud native security controls for this workload?


  _Native security controls are maintained and supported by the service provider, eliminating, or reducing effort required to integrate external security tooling and update those integrations over time._
  > Use native security capabilities in application services.
* Does this workload use cloud services for well-established functions instead of building custom service implementations?


  _Developers should use services available from a cloud provider for well-established functions like databases, encryption, identity directory, and authentication instead of writing custom versions or third-party solutions that must be integrated into the cloud provider._
  > Use services available from a cloud provider for well-established functions like databases, encryption, identity directory, and authentication.
### Dependencies
            
* Is the organization using a Landing Zone concept for this workload and how was it implemented?


  _Landing Zone refers to components that are already defined and in place before the workloads are getting deployed by the workload owners, e.g. network topology with Hub/Spoke concept. The purpose of the “Landing Zone” is to ensure that when a workload lands on Azure, the required “plumbing” is already in place, providing greater agility and compliance with enterprise security and governance requirements. This is crucial, that a Landing Zone will be handed over to the workload owner with the security guardrails deployed._
  > Implement a landing zone concept with Azure Blueprints and Azure Policies.
    - Does the organization use Azure Blueprints to consistently deploy environments of this workload that comply with organizational policies?


      _Automation of deployment and maintenance tasks reduces security and compliance risk by limiting opportunity to introduce human errors during manual tasks._

      > Use Azure Blueprints to consistently deploy environments that comply with organizational policies.
### Application Composition
            
* What Azure services are used by the application?


  _It is important to understand what Azure services, such as App Services and Event Hubs, are used by the application platform to host both application code and data. In a discussion around cost, this can drive decisions towards the right replacements (e.g. moving from Virtual Machines to containers to increase efficiency, or migrating to .NET Core to use cheaper SKUs etc.)._
  > All Azure services in use should be identified.
    - What operational features/capabilities are used for leveraged services?


      _Operational capabilities, such as auto-scale and auto-heal for App Services, can reduce management overheads, support operational effectiveness and reduce cost._

      > Make sure you understand the operational features/capabilities available and how they can be used in the solution.
    - What technologies and frameworks are used by the application?


      _It is important to understand what technologies are used by the application and must be managed, such as .NET Core , Spring, or Node.js._

      > All technologies and frameworks should be identified. Vulnerabilities of these dependencies must be understood (there are automated solutions on the market that can help: [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) or [NPM audit](https://docs.npmjs.com/cli/audit)).
### Threat Analysis
            
* Has the workload been threat modeled?


  _Threat modeling is an engineering technique which can be used to help identify threats, attacks, vulnerabilities and countermeasures that could affect an application. Threat modeling consists of: defining security requirements, identifying threats, mitigating threats, validating threat mitigation. Microsoft uses [STRIDE](https://docs.microsoft.com/azure/security/develop/threat-modeling-tool-threats) for threat modeling.  This might be the right time to talk through the STRIDE methodology and then the tools available to help them with Threat Modeling.  There are tools like [Microsoft Threat Modeling Tool](https://docs.microsoft.com/azure/security/develop/threat-modeling-tool-getting-started) which can help._
  > Adopt threat modeling processes.
    - Are identified threats ranked based on organizational impact?


      _Ranked threats improves the understanding of risks associated with security issues._

      > Rank identified threats based on organizational impact.
    - Does the organization track threat modeling or vulnerability scan results with a management system?


      _Effectively tracking and prioritizing discovered application threats is a vital component of vulnerability management._

      > Centralize threat modeling results.
    - Are identified threats mapped to mitigations?


      _Mitigations are controls to help protect, detect and respond to a certain type of threat._

      > Map threats to mitigations.
    - Are identified threats communicated to stakeholders? E.g., business, IT, application users


      _After defining and analyzing the risks, identify risk owners which are the roles that are responsible for mitigating the risk. They need to be aware of the risks so that they can start the mitigation process by allocating resources (e.g. financial or people)_

      > Establish communication processes for identified threats.
* How are threats addressed once found?


  _The threat modeling tool will produce a report of all the threats identified. This report is typically uploaded into a tracking tool or work items that can be validated and addressed by the developers. Cyber security teams can also use the report to determine attack vectors during a penetration test.  As new features are added to the solution, the threat model should be updated and integrated into the code management process.  If a security issue is found, there should be a process to triage the issue into the next release cycle or a faster release, depending on the severity._
  > Develop and implement a process to track, triage, and address threats into the application development lifecycle.
* Does the organization have established processes and timelines to deploy security fixes for this workload?


  _Fixing identified vulnerabilities in a timely manner helps staying secure and preventing additional attack vectors._
  > Develop or implement established processes and timelines to deploy mitigations for identified threats.
    - How long does it typically take to deploy a security fix into production?


      _It's important to understand how the customer is updating when a security vulnerability is discovered in their workload: the process and tools, approvals, who is made aware and if there's executive sponsorship to bypass lengthy processes when it comes to security._

* Does the organization have a defined set of security requirements for this workload?


  _Azure resources should be blocked that do not meet the proper security requirements defined during service enablement._
  > Define security requirements for the workload.
* Has the organization addressed threat protection for the workload?


  _Enterprise workloads are subjected to many threats that can jeopardize confidentiality, availability, or integrity and should be protected with advanced security solutions._
  > Implement threat protection for the workload.
* Has the organization identified and classified business critical workloads which may adversely affect operations if they are compromised or become unavailable?


  _Enterprise organizations typically have a large application portfolio. Have key business applications been identified and classified? This should include applications that have a high business impact if affected. Examples would be business critical data, regulated data, or business critical availability. These applications also might include applications which have a high exposure to attack such as public facing websites key to organizational success._
  > Identify and classify business critical applications.
* Does the organization evaluate the security posture of this workload using standard benchmarks?


  _[Benchmarking](https://docs.microsoft.com/azure/architecture/framework/Security/governance#evaluate-security-using-benchmarks) enables security program improvement by learning from external organizations. It lets the organization know how its current security state compares to that of other organizations. As an example, the Center for Internet Security (CIS) has created security benchmarks for Azure that map to the CIS Control Framework. Another reference example is the MITRE ATT&CK™ framework that defines the various adversary tactics and techniques based on real-world observations._
  > Establish security benchmarking using [Azure Security Benchmark](https://docs.microsoft.com/azure/security/benchmarks/overview) to align with industry standards.
### Security Criteria &amp; Data Classification
            
* How do you monitor and maintain your compliance of this workload?


  _Find out how they make sure they maintain compliance as the Azure Platform evolves and they update their application. Are there things preventing them from adopting new features in the platform because it will knock them out of compliance?_
    - Does the organization have a process for regulatory or governance compliance attestation for this workload?


      _Knowing whether your cloud resources are in compliance with standards mandated by governments or industry organizations is essential in today's globalized world (e.g. GDPR)._

      > Perform regulatory compliance attestation.
    - Has the organization established a monitoring and assessment solution for compliance?


      _Continuously monitoring and assessing the workload increases the overall security and compliance of your workload in Azure. For example Azure Security Center provides a regulatory compliance dashboard._

      > Continuously assess and monitor compliance.
* Does the organization periodically perform external and/or internal workload audits?


  _Compliance is important for several reasons. Aside from signifying levels of standards, like ISO 27001 and others, noncompliance with regulatory guidelines may bring sanctions and penalties._
  > Periodically perform external and/or internal workload security audits.
    - How often do you have internal and external audits of this workload?


      _Determine the process the customer uses for auditing the solution. Is it done internally, external, or both. How are findings reflected back to the application? Is everyone aware of the audit and involved or is it done in a silo. This will help reduce the firefighting mentality when there is a finding and stress of performing updates._

      > Perform regular internal and external compliance audits.
* Are Azure policies used to enforce security, compliance and organizational standards of this workload?


  _Azure Policy should be used to enforce and report a compliant configuration of Azure services. Azure policies can be used on multiple levels. It is recommended to apply organizational wide security controls on Azure platform level. These policies build the guardrails of a landing zone._
  > Define a set of Azure Policies which enforce organizational standards and are aligned with the governance team.
* Has the organization developed and maintained a security plan in support of the workload?


  _A security plan should be part of the main planning documentation for the cloud. It should include several core elements including organizational functions, security skilling, technical security architecture and capabilities roadmap._
  > Develop a security plan.
* Does the organization prioritize security best practices by reviewing guidance based on industry recommendations and apply those settings proactively and completely to all systems as the cloud workload is implemented?


  _Security best practices are ideally applied proactively and completely to all systems as the cloud workload is implemented._
  > Review, prioritize, and proactively apply security best practices to cloud resources.
* Does the organization build the appropriate level of resilience into the security infrastructure of this workload?


  _Building cybersecurity resilience into an organization requires balancing investments across the security lifecycle, diligently applying maintenance, vigilantly responding to anomalies and alerts to prevent security assurance decay, and designing to defense in depth and least privilege._
  > Implement holistic security resilience strategy.
* Does the organization consider balancing attacker vs. defender cost for this workload?


  _Cybersecurity attacks are planned and conducted by human attackers that must manage their return on investment into attacks (return could include profit or achieving an assigned objective)._
  > Implement defenses that detect and prevent easy and cheap attack methods.
* Does the organization consider containing attacker access to Azure workloads when making investments in security solutions?


  _The actual security risk for an organization is heavily influenced by how much access an adversary can or does obtain to valuable systems and data. For example, when each user only has a focused scope of permissions assigned to them, the impact of compromising an account will be limited._
  > Implement security strategy to contain attacker access.
### Dependencies, frameworks and libraries
            
* Does the application team maintain a list frameworks and libraries used by this workload?


  _As part of the workload inventory the application team should maintain a framework and library list, along with versions in use. Understanding of the frameworks and libraries (custom, OSS, 3rd party, etc.) used by the application and the resulting vulnerabilities is important. There are automated solutions on the market that can help with this assessment: [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/), [NPM audit](https://docs.npmjs.com/cli/v6/commands/npm-audit) or [WhiteSource Bolt](https://www.whitesourcesoftware.com/free-developer-tools/bolt/)._
  > Conduct inventory of used frameworks and libraries.
* Are frameworks and library updates included into the workload lifecycle?


  _Application frameworks are frequently provided with updates (e.g. security), released by the vendor or communities. Critical and important security patches need to be prioritized._
  > Include framework & library updates into workload lifecycle.
## Health Modelling &amp; Monitoring
    
### Application Level Monitoring
            
* How is security monitored in this workload?


  _Organization is monitoring the security posture across workloads and central SecOps team is monitoring security-related telemetry data and investigating security breaches. Communication, investigation and hunting activities need to be aligned with the application team._
* Does the organization actively monitor identity related risk events related to potentially compromised identities of this workload?


  _Most security incidents take place after an attacker initially gains access using a stolen identity. These identities can often start with low privileges, but attackers then use that identity to traverse laterally and gain access to more privileged identities. This repeats as needed until the attacker controls access to the ultimate target data or systems. Reported risk events for Azure AD can be viewed in Azure AD reporting, or Azure AD Identity Protection. Additionally, the Identity Protection risk events API can be used to programmatically access identity related security detections using Microsoft Graph._
  > Establish detection and response strategy for identity risks.
* Is Personally identifiable information (PII) detected and removed/obfuscated automatically for this workload?


  _Extra care should be taken around logging of sensitive application areas. PII (contact information, payment information etc.) should not be stored in any application logs and protective measures should be applied (such as obfuscation). Machine learning tools like [Cognitive Search PII detection](https://docs.microsoft.com/azure/search/cognitive-search-skill-pii-detection) can help with this._
  > Automatically remove/obfuscate personally identifiable information (PII) for this workload.
* Does the organization have a central SecOps teams which monitors security related telemetry data for this workload?


  _Organization is monitoring the security posture across workloads and central SecOps team is monitoring security-related telemetry data and investigating security breaches._
  > Establish a SecOps team and monitor security related events.
    - Does the organization have an established process for communication, investigation &amp; hunting activities that is aligned with the workload team?


      _Development team needs to be aware of those activities to align their security improvement  activities with the outcome of those activities._

      > Define a process for aligning communication, investigation & hunting activities with the application team.
### Resource and Infrastructure Level Monitoring
            
* Does the security team have access to and monitor all subscriptions and tenants that are connected to the existing cloud environment, relative to this workload?


  _Ensure the security organization is aware of all enrollments and associated subscriptions connected to the existing environment and is able to monitor those resources as part of the overall enterprise security posture._
  > Ensure all Azure environments that connect to your production environment/network apply your organization’s policy and IT governance controls for security.
### Auditing
            
* Does the organization conduct periodic & automated access reviews of the workload to make sure only authorized people have access?


  _As people in the organization and on the project change, it is crucial to make sure that only the right people have access to the application infrastructure. Auditing and reviewing access reduces the attack vector to the application. Azure control plane depends on Azure AD and access reviews are often centrally performed often as part of internal or external audit activities. For the application specific access it is recommended to do the same at least twice a year._
  > Conduct periodic access reviews for the workload.
## Networking &amp; Connectivity
    
### Connectivity
            
* Are the services of this workload, which should not be accessible from public IP addresses, protected with network restrictions / IP firewall rules?


  _Azure provides networking solutions to restrict access to individual application services. Multiple levels (such as IP filtering or firewall rules) should be explored to prevent application services from being accessed by unauthorized actors._
  > Protect non-public accessible services with network restrictions / IP firewall.
* Does the workload use Service Endpoints or Private Link for accessing Azure PaaS services?


  _[Service Endpoints](https://docs.microsoft.com/azure/virtual-network/virtual-network-service-endpoints-overview) and [Private Link](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) can be leveraged to restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios). Don’t forget that Private Link is a paid service and has meters for inbound and outbound data processed. Private Endpoints are charged as well._
  > Use service endpoints and private links where appropriate.
* Does the organization use Azure Firewall or any 3rd party next generation Firewall for this workload to control outgoing traffic of Azure PaaS services (data exfiltration protection) where Private Link is not available?


  _NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported._
  > Use Azure Firewall or a 3rd party next generation firewall to protect against data exfiltration concerns.
* Does the workload use network security groups (NSG) to isolate and protect traffic within the workload's VNet?


  _If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked._
  > Use NSG or Azure Firewall to protect and control traffic within the VNet
    - Does the organization have configured NSG flow logs to get insights about incoming and outgoing traffic of this workload?


      _NSG flow logs should be captured and analyzed to monitor performance and security. The NSG flow logs enables Traffic Analytics to gain insights into internal and external traffic flows of the application._

      > Configure and collect network traffic logs.
* Does the organization restrict access to the workload backend infrastructure (APIs, databases, etc.) by only a minimal set of public IP addresses - only those who really need it?


  _Web applications typically have one public entrypoint and don't expose subsequent APIs and database servers over the internet. When using gateway services like [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/) it's possible to restrict access only to a set of Front Door IP addresses and lock down the infrastructure completely._
  > Restrict access to backend services to a minimal set of public IP addresses, only those who really need it.
* Does the organization identify and isolate groups of resources from other parts of the organization to aid in detecting and containing adversary movement within the enterprise?


  _A unified [enterprise segmentation strategy](https://docs.microsoft.com/azure/architecture/framework/Security/governance#enterprise-segmentation-strategy) will guide all technical teams to consistently segment access using networking, applications, identity, and any other access controls._
  > Establish a unified enterprise segmentation strategy.
    - Does the organization align the cloud network segmentation strategy with the enterprise segmentation model?


      _Aligning cloud network segmentation strategy with the enterprise segmentation model reduces confusion and resulting challenges with different technical teams (networking, identity, applications, etc.) each developing their own segmentation and delegation models that don’t align with each other._

      > Align cloud network segmentation strategy with the enterprise segmentation model.
### Endpoints
            
* Are all public endpoints of this workload protected / secured?


  _External application endpoints should be protected against common attack vectors, such as Denial of Service (DoS) attacks like Slowloris, to prevent potential application downtime due to malicious intent. Azure-native technologies such as Azure Firewall, Application Gateway/Azure Front Door WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection._
  > Protect all public endpoints with appropriate solutions, e.g. Azure Front Door, Application Gateway, Azure Firewall, Azure DDOS Protection or any 3rd party solution.
    - Are public endpoints of this workload protected with firewall or WAF (Web Application Firewall)?


      _[Azure Firewall](https://docs.microsoft.com/azure/firewall/features) is a managed, cloud-based network security service that protects Azure Virtual Network resources. [Web Application Firewall](https://docs.microsoft.com/azure/web-application-firewall/ag/ag-overview) (WAF) mitigates the risk of an attacker being able to exploit commonly known security application vulnerabilities like cross-site scripting or SQL injection._

      > Use web application firewall.
* Does the organization protect publishing methods for the workload (e.g FTP, Web Deploy)?


  _Application resources allowing multiple methods to publish app content (e.g FTP, Web Deploy) should have the unused endpoints disabled. For Azure Web Apps SCM is the recommended endpoint and it can be protected separately with network restrictions for sensitive scenarios._
  > Protect workload publishing methods and restrict those not in use.
    - Does the organization have an CI/CD process for publishing code in this workload?


      _Developers shouldn't publish their code directly to app servers - automated and gated CI/CD process should manage this._

      > Implement an automated and gated CD/CD deployment process.
* Do workload virtual machines running on premises or in the cloud have direct internet connectivity for users that may perform interactive logins, or by applications running on virtual machines?


  _Attackers constantly scan public cloud IP ranges for open management ports and attempt “easy” attacks like common passwords and known unpatched vulnerabilities. Limiting internet access from within an application server can prevent data exfiltration or stop the attacker from downloading additional tools._
  > Develop process and procedures to prevent direct Internet access of virtual machines (such as proxy or firewall) with logging and monitoring to enforce policies.
* Does the organization have the capability and plans in place to mitigate DDoS attacks for this workload?


  _DDoS attacks can be very debilitating and completely block access to your services or even take down the services, depending on the type of DDoS attack._
  > Mitigate DDoS attacks. Use Standard protection for critical workloads where outage would have business impact. Also consider CDN as another layer of protection.
### Data flow
            
* Are there controls in place for this workload to detect and protect from data exfiltration?


  _Data exfiltration occurs when an internal/external malicious actor performs an unauthorized data transfer. The solution should leverage a layered approach such as hub/spoke for network communications with deep packet inspection to detect/protect from data exfiltration attack. Azure Firewall, UDR (User-defined Routes), NSG (Network Security Groups), Key Protection, Data Encryption, PrivateLink, and Private Endpoints are layered defenses for a data exfiltration attack. Azure Sentinel and Azure Security Center can be used to detect data exfiltration attempts and alert incident responders._
  > Apply a layered defense in depth / zero trust approach, e.g. use Azure Security Center to detect data exfiltration attempts.
* Is the traffic between subnets, Azure components and tiers of the workload managed and secured?


  _Data filtering between subnets and other Azure resources should be protected. Network Security Groups, PrivateLink, and Private Endpoints can be used for traffic filtering._
  > Control network traffic between subnets (east/west) and application tiers (north/south).
* Does the organization leverage a cloud application security broker (CASB) for this workload?


  _CASBs provide rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all Microsoft and third-party cloud services._
  > Leverage a cloud application security broker (CASB).
## Security &amp; Compliance
    
### Security Center
            
* Does the organization use tools to discover and remediate common risks within Azure tenants?


  _Identifying and remediating common security hygiene risks significantly reduces overall risk to the organization by increasing cost to attackers. [Azure Secure Score](https://docs.microsoft.com/azure/security-center/security-center-secure-score) in Azure Security Center monitors the security posture of machines, networks, storage and data services, and applications to discover potential security issues (internet connected VMs, or missing security updates, missing endpoint protection or encryption, deviations from baseline security configurations, missing Web Application Firewall (WAF), and more)._
  > Discover and remediate common risks to improve Secure Score in Azure Security Center.
### Network Security
            
* Does the organization have a designated group responsible for centralized network management and security of this workload?


  _Centralizing network management and security can reduce the potential for inconsistent strategies that create potential attacker exploitable security risks. Because all divisions of the IT and development organizations do not have the same level of network management and security knowledge and sophistication, organizations benefit from leveraging a centralized network team’s expertise and tooling._
  > Establish designated group responsible for central network management.
* Does the organization have controls in place to ensure that security extends past the network boundaries of the workload in order to effectively prevent, detect, and respond to threats?


  _Traditional network controls based on a “trusted intranet” approach will not be able to effectively provide security assurances for cloud applications._
  > Evolve security beyond network controls.
* What kind of data loss prevention (DLP) is used for this workload?


  _Network-based data loss prevention (DLP) is decreasingly effective at identifying both inadvertent and deliberate data loss. The reason for this is that most modern protocols and attackers use network-level encryption for inbound and outbound communications. While the organization can use “SSL-bridging” to provide an “authorized man-in-the-middle” that terminates and then reestablishes encrypted network connections, this can also introduce privacy, security and reliability challenges._
  > Deprecate legacy network security controls.
* Has the organization enabled enhanced network visibility by integrating network logs into a Security information and event management (SIEM) solution or similar technology?


  _Integrating logs from the network devices, and even raw network traffic itself, will provide greater visibility into potential security threats flowing over the wire._
  > Integrate network logs into a SIEM.
* Does the organization have cloud virtual networks that are designed for growth based on an intentional subnet security strategy?


  _Most organizations end up adding more resources to networks than initially planned. When this happens, IP addressing and subnetting schemes need to be refactored to accommodate the extra resources. This is a labor-intensive process. There is limited security value in creating a very large number of small subnets and then trying to map network access controls (such as security groups) to each of them._
  > Design virtual networks for growth.
* Does the organization have a security containment strategy that blends existing on-premises security controls and practices with native security controls available in Azure, and uses a zero-trust approach?


  _Assume breach is the recommended cybersecurity mindset and the ability to contain an attacker is vital to protect information systems._
  > Build a security containment strategy.
### Encryption
            
* Does the workload use industry standard encryption algorithms instead of creating own?


  _Organizations should rarely develop and maintain their own encryption algorithms. Secure standards already exist on the market and should be preferred. AES should be used as symmetric block cipher, AES-128, AES-192 and AES-256 are acceptable. Crypto APIs built into operating systems should be used where possible, instead of non-platform crypto libraries. For .NET make sure you follow the [.NET Cryptography Model](https://docs.microsoft.com/dotnet/standard/security/cryptography-model)._
  > Use standard and recommended encryption algorithms.
* Does the workload communicate over encrypted (TLS / HTTPS) network channels only?


  _Any network communication between client and server where man-in-the-middle attack can occur, needs to be encrypted. All website communication should use HTTPS, no matter the perceived sensitivity of transferred data (man-in-the-middle attacks can occur anywhere on the site, not just on login forms)._
  > Use encrypted network channels (TLS / HTTPS) for all client/server communication.
* What TLS version is used in this workload?


  _All Microsoft Azure services fully support TLS 1.2. It is recommended to migrate solutions to support **TLS 1.2** and use this version by default. TLS 1.3 is not available on Azure yet, but should be the preferred option once implemented on the platform._
  > Use TLS 1.2 by default on Azure. Prefer TLS 1.3 where possible.
* Does the workload use secure modern hash algorithms?


  _Applications should use the **SHA-2** family of hash algorithms (SHA-256, SHA-384, SHA-512)._
  > Use only secure hash algorithms (SHA-2 family).
* Does the organization store customer managed keys for this workload in Azure Key Vault and protect them with identity-based access control?


  _Keys must be stored in a secure location with identity-based access control and audit policies. Data encryption keys are often encrypted with a key encryption key in Azure Key Vault to further limit access._
  > Store customer managed keys in Azure Key Vault
    - Does the organization protect customer managed keys in this workload with an additional key encryption key (KEK)?


      _More than one encryption key should be used in an encryption at rest implementation. Storing an encryption key in Azure Key Vault ensures secure key access and central management of keys._

      > Use an additional key encryption key (KEK) to protect your data encryption key (DEK).
* How is data at rest protected in this workload?


  _This includes all information storage objects, containers, and types that exist statically on physical media, whether magnetic or optical disk.  All data should be classified and encrypted with an encryption standard. It should also be tagged so that it can be audited._
  > Classify your data at rest and use encryption.
* Is there any portion of the workload that does not secure data in transit?


  _When data is being transferred between components, locations, or programs, it’s in transit. Data in transit should be encrypted using a common encryption standard at all points to ensure data integrity. For example: web applications and APIs should use HTTPS/SSL for all communication with clients and also between each other (in micro-services architecture). Determine if all components in the solution are using a consistent standard. There are times when encryption is not possible due to technical limitations, but the reason needs to be clear and valid._
  > Data in transit should be encrypted at all points to ensure data integrity.
* Does the organization use identity-based storage access controls for this workload?


  _Protecting data at rest is required to maintain confidentiality, integrity, and availability assurances across all workloads. Cloud service providers make multiple methods of access control available - shared keys, shared signatures, anonymous access, identity provider-based. Identity provider methods (such as AAD and RBAC) are the least liable to compromise and enable more fine-grained role-based access controls._
  > Implement identity-based storage access controls.
* Does the organization encrypt virtual disk files for virtual machines which are associated with this workload?


  _Encrypting the virtual disk files helps prevent attackers from gaining access to the contents of the disk files in the event an attacker is able to download the files and mount the disk files offline on a separate system._
  > Use tools like Azure Disk Encryption, BitLocker or DM-Crypt to encrypt virtual disks.
## Operational Procedures
    
### Configuration &amp; Secrets Management
            
* Where is application configuration information stored and how does the application access it?


  _Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault_
  > Preferably configuration information is stored using a dedicated configuration management system like Azure App Configuration or Azure Key Vault so that it can be updated independently of the application code.
* How are passwords and other secrets managed?


  _API keys, database connection strings and passwords are all sensitive to leakage, occasionally require rotation and are prone to expiration. Storing them in a secure store and not within the application code or configuration simplifies operational tasks like key rotation as well as improving overall security._
  > Tools like Azure Key Vault or [HashiCorp Vault](https://www.vaultproject.io/) should be used to store and manage secrets securely rather than being baked into the application artefact during deployment, as this simplifies operational tasks like key rotation as well as improving overall security. Keys and secrets stored in source code should be identified with static code scanning tools. Ensure that these scans are an integrated part of the continuous integration (CI) process.
* Do you have procedures in place for secret rotation?


  _In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Key rotation reduces the attack vectors and should be automated and executed without any human interactions._
  > Secrets (keys, certificates etc.) should be replaced once they have reached the end of their active lifetime or once they have been compromised. Renewed certificates should also use a new key. A process needs to be in place for situations where keys get compromised (leaked) and need to be regenerated on-demand. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with [rotation processes](https://docs.microsoft.com/azure/key-vault/secrets/tutorial-rotation-dual).
* Does the application use Managed Identities?


  _[Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) in Azure can be used to securely access Azure services while removing the need to store the secrets or certificates of Service Principals._
  > Wherever possible Azure Managed Identities (either system-managed or user-managed) should be used since they remove the management burden of storing and rotating keys for service principles. Thus, they provide higher security as well as easier maintenance.
* Are the expiry dates of SSL/TLS certificates monitored and are processes in place to renew them?


  _Expired SSL/TLS certificates are one of the most common yet avoidable causes of application outages; even Azure and more recently Microsoft Teams have experienced outages due to expired certificates._
  > Tracking expiry dates of SSL/TLS certificates and renewing them in due time is therefore highly critical. Ideally the process should be automated, although this often depends on leveraged CA. If not automated, sufficient alerting should be applied to ensure expiry dates do not go unnoticed
* Is there a defined access model for keys and secrets for this workload?


  _Permissions to keys and secrets have to be controlled with an [access model](https://docs.microsoft.com/azure/key-vault/general/secure-your-key-vault)._
  > Define an access model for keys and secrets. Use Azure Key Vault as the secure store and protect the keys/secrets with Azure RBAC.
* Does the organization have a clear guidance or requirement on what type of keys (PMK - Platform Managed Keys vs CMK - Customer Managed Keys) should be used for this workload?


  _Different approaches can be used by the workload team. Decisions are often driven by security, compliance and specific data classification requirements. Understanding these requirements is important to determine which key types are best suitable (MMK - Microsoft-managed Keys, CMK - Customer-managed Keys or BYOK - Bring Your Own Key)._
  > Provide guidance for either platform managed keys (PMK) or customer managed keys (CMK), based on security or compliance requirements of this workload.
* Does the organization define clear responsibility / role concept for managing keys and secrets for this workload?


  _Central SecOps team should provide guidance on how keys and secrets are managed (governance), application DevOps team is responsible to manage the application related keys and secrets._
  > Define a role & responsibility concept for managing keys and secrets.
### Patch &amp; Update Process (PNU)
            
* Does the organization reduce the count and potential severity of security vulnerabilities for this workload by implementing security practices and tools during the development lifecycle?


  _Security vulnerabilities can result in an application disclosing confidential data, allowing criminals to alter data/records, or the data/application becoming unavailable for use by customers and employees. Applications will almost always contain logic errors, so it is important to discover, evaluate, and correct them to avoid damage to the organization’s reputation, revenue, or margins. This is made easier by discovering these vulnerabilities in the early stages of the development cycle. [Develop Secure Applications on Azure whitepaper](https://azure.microsoft.com/resources/develop-secure-applications-on-azure/)_
  > Implement security practices and tools during development lifecycle.
* Does the organization have a formal policy for this workload to apply security updates to VMs in a timely manner, and do strong passwords exist on those VMs for any local administrative accounts that may be in use?


  _Attackers constantly scan public cloud IP ranges for open management ports and attempt “easy” attacks like common passwords and unpatched vulnerabilities._
  > Put a solution in place that ensures all VMs are patched in a timely manner and that ensures strong local administrative password management.
### Incident Response
            
* Are operational processes for incident response defined and tested for this workload?


  _Actions executed during an incident and response investigation could impact application availability or performance. It is recommended to define these processes and align them with the responsible (and in most cases central) SecOps team. The impact of such an investigation on the application has to be analyzed._
  > Establish an incident response plan and perform periodically a simulated execution.
* Are there playbooks built to help incident responders quickly understand the workload and components to mitigate an attack and investigate?


  _Incident responders are part of a central SecOps team and need to understand security insights of an application. Playbooks can help to understand the security concepts and cover the typical investigation activities. These procedures can and should be automated as much as possible (while maintaining confidence and security)._
  > Define security playbooks which help to understand, investigte and respond to security incidents. It is recommended to automate as many steps of those procedures as you can. Automation reduces overhead. It can also improve your security by ensuring the process steps are done quickly, consistently, and according to your predefined requirements.
* Does the organization have a security operations center (SOC) that leverages a modern security approach?


  _A SOC has a critical role in limiting the time and access an attacker can get to valuable systems and data.  In addition, it provides the vital role of detecting the presence of adversaries, reacting to an alert of suspicious activity, or proactively hunting for anomalous events in the enterprise activity logs._
  > Establish a security operations center (SOC).
## Deployment &amp; Testing
    
### Application Deployments
            
* Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?


  _N-1 and N+1 refer to roll-back and roll-forward. Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle._
  > Automated deployment pipelines should allow for quick roll-forward and roll-back deployments to address critical bugs and code updates outside of the normal deployment lifecycle
* Are code scanning tools an integrated part of the continuous integration (CI) process for this workload?


  _Credentials should not be stored in source code or configuration files, because that increases the risk of exposure. Code analyzers (such as Roslyn analyzers for Visual Studio) can prevent from pushing credentials to source code repository and pipeline addons such as CredScan (part of Microsoft Security Code Analysis) help to catch credentials during the build process._
  > Integrate code scanning tools within CI/CD pipeline.
    - Are dependencies and framework components included in the code scanning process of this workload?


      _As part of the continuous integration process it is crucial that every release includes a scan of all components in use. Vulnerable dependencies should be flagged and investigated. This can be done in combination with other code scanning tasks (e.g. code churn, test results/coverage)._

      > Include code scans into CI/CD process that also covers 3rd party dependencies and framework components.
* How are credentials, certificates and other secrets managed in CI/CD pipelines for this workload?


  _Secrets need to be managed in a secure manner inside of the CI/CD pipeline. Secrets need to be stored either in a secure store inside the pipeline or externally in Azure Key Vault. When deploying application infrastructure (e.g. with Azure Resource Manager or Terraform), credentials and keys should be generated during the process, stored directly in Key Vault and referenced by deployed resources. Hardcoded credentials should be avoided._
  > Store keys and secrets outside of deployment pipeline in Azure Key Vault or in secure store for the pipeline.
* Are branch policies used in source control management of this workload? How are they configured?


  _Branch policies provide additional level of control over the code which is commited to the product. It is a common practice to not allow pushing against the main branch and require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author. Different branches can have different purposes and access levels, for example: feature branches are created by developers and are open to push, integration branch requires PR and code-review and production branch requires additional approval from a senior developer before merging._
  > Implement branch policy strategy to enhance branch security.
### Build Environments
            
* Does the organization apply security controls (e.g. IP firewall restrictions, update management, etc.) to self-hosted build agents for this workload?


  _When the organization uses their own build agents it adds management complexity and can become an attack vector. Build machine credentials must be stored securely and file system needs to be cleaned of any temporary build artifacts regularly. Network isolation can be achieved by only allowing outgoing traffic from the build agent, because it's using pull model of communication with Azure DevOps._
  > Apply security controls to self-hosted build agents in the same manner as with other Azure IaaS VMs.
### Testing &amp; Validation
            
* Does the organization use Azure Defender (Azure Security Center) or any third-party solution to scan containers in this workload for vulnerabilities?


  _Azure Security Center is the Azure-native solution for securing containers. Security Center can protect virtual machines that are running Docker, Azure Kubernetes Service clusters, Azure Container Registry registries. ASC is able to scan container images and identify security issues, or provide real-time threat detection for containerized environments. [Container Security in Security Center](https://docs.microsoft.com/azure/security-center/container-security)_
  > Scan container workloads for vulnerabilities.
* Does the organization perform penetration testing or have a third-party entity perform penetration testing of this workload to validate the current security defenses?


  _Real world validation of security defenses is critical to validate a defense strategy and implementation. Penetration tests or red team programs can be used to simulate either one time, or persistent threats against an organization to validate defenses that have been put in place to protect organizational resources._
  > Use penetration testing and red team exercises to validate security defenses for this workload.
* Does the organization have a method to carry out simulated attacks on users of this workload?


  _People are a critical part of your defense, especially those with elevated permissions, so ensuring they have the knowledge and skills to avoid and resist attacks will reduce your overall organizational risk. Simulating attacks for educational purposes helps to enforce understanding of the various means that an attacker may use to compromise accounts. Tools such as Office 365 Attack Simulation or similar may be used._
  > Simulate attack against users and critical accounts. Ensure proper follow-up to educate users about the various means that an attacker may use.
## Operational Model &amp; DevOps
    
### General
            
* Has the organization adopted a formal DevOps approach to building and maintaining software in this workload to ensure security and feature enhancements can be deployed in rapid fashion?


  _The DevOps approach increases the organization’s ability to rapidly address security concerns without waiting for a longer planning and testing cycle of traditional waterfall model. Key attributes are: automation, close integration of infra and dev teams, testability and reliability and repeatability of deployments.* [Adopt the DevOps approach](https://docs.microsoft.com/azure/architecture/framework/Security/applications-services#adopt-the-devops-approach)_
  > Adopt a formal DevSecOps approach to building and maintaining software.
* Does the organization leverage DevOps security guidance based on industry lessons-learned, and available automation tools (OWASP guidance, Microsoft toolkit for Secure DevOps etc.)?


  _Organizations should leverage a control framework such as NIST, CIS or ASB [(Azure Security Benchmarks)](https://docs.microsoft.com/azure/security/benchmarks/) for securing applications on the cloud rather than starting from zero._
  > Follow DevOps security guidance and automation for securing applications.
### Roles &amp; Responsibilities
            
* Are tools or processes in place to grant access on a just-in-time basis?


  _Minimizing the number of people who have access to secure information or resources reduces the chance of a malicious actor gaining access or an authorized user inadvertently impacting a sensitive resource. For example, Azure AD [Privileged Identity Management](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure) provides time-based and approval-based role activation to mitigate the risks of excessive, unnecessary, or misused access permissions on resources that you care about._
  > Implement just-in-time privileged access management.
    - Does anyone have long-standing write-access to production environments?


      _Regular, long-standing write access to production environments by user accounts can pose a security risk and manual intervention is often prone to errors._

      > Limit long-standing write access to production environments only to service principals.
* Does the organization clearly define CI/CD roles and permissions for this workload?


  _Defining CI/CD permissions properly ensures that only users responsible for production releases are able to initiate the process and that only developers can access the source code. Azure DevOps offers pre-defined roles which can be assigned to individual users of groups. Using them properly can make sure that for example only users responsible for production releases are able to initiate the process and that only developers can access the source code. Variable groups often contain sensitive configuration information and can be protected as well._
  > Clearly define CI/CD roles and permissions.
* Does the organization have release gate approvals configured in their DevOps release process of this workload?


  _Pull Requests and code reviews serve as the first line of approvals during development cycle. Before releasing new code to production (new features, bugfixes etc.), security review and approval should be required._
  > Configure quality gate approvals in DevOps release process.
* Is the security team involved in the planning, design and overall DevOps process of this workload, so that they can implement security controls, auditing and response processes?


  _There should be a process for onboarding service securely to Azure. The onboarding process should include reviewing the configuration options to determine what logging/monitoring needs to be established, how to properly harden a resource before it goes into production.  For a list of common criteria for onboarding resoruces, see the [Service Enablement Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#service-enablement-framework)_
  > Involve security team into development process.
* Has the organization developed and maintained a security training program to ensure technical staff of this workload are well-informed and equipped with the appropriate skills?


  _Cybersecurity threats are always evolving and therefore those responsible for organizational information security require specialized, continual, and relevant training to ensure staff maintains the level of competency required to protect, detect, and respond._
  > Develop security training program.
* Does the organization have the appropriate emergency access accounts configured for this workload in case of an emergency?


  _While rare, sometimes extreme circumstances arise where all normal means of administrative access are unavailable and for this reason emergency access accounts (also refered to as 'break glass' accounts) should be available. These accounts are strictly controlled in accordance with best practice guidance, and they are closely monitored for unsanctioned use to ensure they are not compromised or used for nefarious purposes. [Emergency Access Acounts](https://docs.microsoft.com/azure/active-directory/roles/security-emergency-access)_
  > Configure emergency access accounts.
* Has the organization clearly defined lines of responsibility and designated responsible parties for specific functions in Azure?


  _Clearly documenting and sharing the contacts responsible for each of these functions will create consistency and facilitate communication. Examples of such contact groups include network security, network management, server endpoint security, incident response, policy management, identity..._
  > Designate the parties responsible for specific functions in Azure.
### Common Engineering Criteria
            
* Has the organization implemented or considered implementing elevated security capabilities such as dedicated Hardware Security Modules (HSMs) or the use of [Confidential Computing](https://azure.microsoft.com/solutions/confidential-compute/)?


  _Careful consideration is necessary on whether to utilize specialized security capabilities in an organization’s enterprise architecture._
  > Review and consider elevated security capabilities for Azure workloads.
## Identity &amp; Access Control
    
### Separation of duties
            
* Does the application team have a clear view on responsibilities and individual/group access levels for this workload?


  _Application roles and responsibility model need to be defined covering the different access level of each operational function (e.g publish production release, access customer data, manipulate database records). It's in the interest of the application team to include central functions (e.g. SecOps, NetOps, IAM) into this view._
* Has role-based and/or resource-based authorization been configured within Azure AD for this workload?


  _Role-based and resource-based authorization are common approaches to authorize users based on required permission scopes. [Role-based and resource-based](https://docs.microsoft.com/azure/architecture/multitenant-identity/authorize)_
* Are there any processes and tools leveraged in this workload to manage privileged activities?


  _Zero-trust principle comes with the requirement of no standing access to an environment. Native and 3rd party solution can be used to elevate access permissions for at least highly privileged if not all activities. [Azure AD Privileged Identity Management](https://docs.microsoft.com/azure/active-directory/privileged-identity-management/pim-configure) (Azure AD PIM) is the recommended and Azure native solution._
  > Establish processes and use tools to manage priviliged access.
* Has the organization established a lifecycle management policy for critical accounts in this workload?


  _A compromise of an account in a role that is assigned privileges with a business-critical impact can be detrimental to organizational information systems and should therefore be closely monitored including a lifecycle process._
  > Establish lifecycle management policy for critical accounts.
    - Does the organization regularly review access from accounts that have privileges to this workload?


      _It is important to monitor the usage of high privilege accounts and set up a recurring review pattern to ensure that accounts are removed from permissions as roles change._

      > Regularly review access for critical roles.
    - Are all roles (critical and non-critical) assigned only to accounts which really need them and reviewed regularly?


      _All access should be assigned only when really needed. Even the Reader role, especially with wide scope (subscription, resource group level), can provide an attack vector, because if attacker compromises such user account or service principal, they get access to information such as source code of Azure Automation runbooks, Azure Logic Apps definitions, virtual network structure and other configuration properties of various services._

      > Assign all roles only as needed and review access periodically.
* Has a designated point of contact been assigned for this workload to receive Azure incident notifications from Microsoft?


  _Security alerts need to reach the right people in your organization. It is important to ensure a security contact receives Azure incident notifications, or alerts from Microsoft / Azure Security Center, such as a notification that your resource is compromised and/or attacking another customer._
  > Establish a designated point of contact to receive Azure incident notifications from Microsoft.
* Does the organization assign the appropriate level of privileges for managing the Azure environment for this workload based on a clearly documented strategy built with the principle of least privilege and based on operational needs?


  _Microsoft recommends starting from the Core Services Reference Permissions model and Segment Reference Permissions model to provide clear guidance for technical teams implementing these permissions._
  > Document and implement a privileged access strategy sourced from Microsoft core services reference models.
### Control-plane RBAC
            
* Does the organization protect the workload infrastructure with role-based access control (RBAC)?


  _Performing role-based or/or resource-based authorization with Azure Active Directory allows centralized management that supports the principle of least privilege when accessing organizational resources. RBAC provides the necessary tools to maintain separation of concerns when it comes to accessing the application infrastructure. Aligned with the [separation of duties](#separation-of-duties) section, users should have only the minimal set of permissions. Examples: "Developers can't access production infrastructure.", "Only the SecOps team can read and manage Key Vault secrets.", "Project A team can access and manage Resource Group A and all resources within."_
  > Implement role-based access control for application infrastructure.
* Does the organization leverage resource locks in this workload to protect critical infrastructure?


  _Critical infrastructure typically doesn't change often. To prevent accidental/undesired modification of resources, Azure offers the locking functionality where only specific roles and users with permissions are able to delete/modify resources. Locks can be used on critical parts of the infrastructure, but special care needs to be taken in the DevOps process - modification locks can sometimes block automation (see [Considerations before applying locks](https://review.docs.microsoft.com/azure/azure-resource-manager/management/lock-resources#considerations-before-applying-locks) for more information)._
  > Implement resource locks to protect critical infrastructure.
* Is there a direct access to the workload infrastructure through Azure Portal, command-line Interface (CLI) or REST API?


  _While it is recommended to deploy application infrastructure via automation and CI/CD, to maximize application autonomy and agility, restrictive access control need be balanced on less critical development and test environments._
  > Restrict application infrastructure access only to CI/CD for critical workloads.
* Does the organization use a single identity provider for cross-platform identity management of this workload?


  _A single identity provider such as Azure Active Directory (AAD) for all enterprise assets and cloud services will simplify management and security, minimizing the risk of oversights or human mistakes. Ideally this provider should span across platforms (Windows, Linux, Azure, AWS, Google...)._
  > Use single identity provider for cross-platform IDM.
* Does the organization have a well-defined identity strategy for controlling access to cloud-based workloads?


  _Identity provides the basis of a large percentage of security assurances and a well-defined identity strategy is effective in protecting the organization from cybersecurity threats._
  > Implement a well-defined identity strategy.
* Does the organization assign permissions to Azure workloads based on individual resources or use custom permissions?


  _Custom resource-based permissions are often not needed and can result in increased complexity and confusion as they do not carry the intention to new similar resources. This then accumulates into a complex legacy configuration that is difficult to maintain or change without fear of "breaking something" – negatively impacting both security and solution agility. Higher level permissions sets - based on resource groups or management groups - are usually more efficient._
  > Assign permissions based on management or resource groups.
* Does the organizational security team have read-only access into all cloud environment resources for this workload?


  _Provide [security teams](https://docs.microsoft.com/azure/architecture/framework/Security/governance#security-team-visibility) read-only access to the security aspects of all technical resources in their purview. Security organizations require visibility into the technical environment to perform their duties of assessing and reporting on organizational risk. Without this visibility, security will have to rely on information provided from groups, operating the environment, who have a potential conflict of interest (and other priorities).
Note that security teams may separately be granted additional privileges if they have operational responsibilities or a requirement to enforce compliance on Azure resources.
For example in Azure, assign security teams to the Security Readers permission that provides access to measure security risk (without providing access to the data itself).
Because security will have broad access to the environment (and visibility into potentially exploitable vulnerabilities), you should consider them critical impact accounts and apply the same protections as administrators._
  > Ensure security team has "Security Readers" or equivalent on cloud resources in their purview.
* Does the organization use the root management group and carefully consider any changes that are applied using this group?


  _The [root management group](https://docs.microsoft.com/azure/architecture/framework/security/design-management-groups#use-root-management-group-with-caution) ensures consistency across the enterprise by applying policies, permissions, and tags across all subscriptions. This group can affect all resources in Azure and incorrect use can impact the security of all workloads in Azure._
  > Add planning, testing, and validation rigor to the use of the root management group.
### Authentication and authorization
            
* Are authentication tokens cached securely and encrypted when sharing across web servers in this workload?


  _OAuth tokens are usually cached after they've been acquired. Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability. Tokens should be stored securely and handled as any other credentials. When there's a need to share tokens across application servers (instead of each server acquiring and caching their own) encryption should be used. [Acquire and cache tokens](https://docs.microsoft.com/azure/active-directory/develop/msal-acquire-cache-tokens)_
  > Configure web apps to reuse authentication tokens securely and handle them like other credentials.
    - Is trusted state information protected when stored on untrusted client (such as cookie in a web browser)?


      _State data can contain not just session identifier, but also account and claims information, which can get exploited by the client. In a situation where the application needs to round-trip trusted state via an untrusted client (which can be session cookie in a web browser), it has to ensure that the information isn't tampered with. See [ASP.NET Core Data Protection](https://docs.microsoft.com/aspnet/core/security/data-protection/introduction?view=aspnetcore-5.0) for more details on how to use .NET APIs._

      > Implement Data Protection for trusted state information.
* How is the workload authenticated when communicating with Azure platform services?


  _Try to avoid authentication with keys (connection strings, API keys etc.) and always prefer Managed Identities (formerly also known as Managed Service Identity, MSI). Managed identities enable Azure Services to authenticate to each other without presenting explicit credentials via code. Typical use case is a Web App accessing Key Vault credentials or a Virtual Machine accessing SQL Database. [Managed identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/)_
  > Use managed identites for authentication to other Azure platform services.
* Do all APIs for this workload require authentication?


  _API URLs used by client applications are exposed to attackers (JavaScript code on a website can be viewed, mobile application can be decompiled and inspected) and should be protected. For internal APIs, requiring authentication can increase the difficulty of lateral movement if an attacker obtains network access. Typical mechanisms include API keys, authorization tokens, IP restrictions or Azure Managed identities._
  > Require API authentication for all workloads.
    - Does this workload leverage modern (OAuth 2.0, OpenID) authentication protocols?


      _Modern authentication protocols support strong controls such as MFA and should be used instead of legacy._

      > Standardize on modern authentication protocols.
* How is user authentication handled in this workload?


  _If possible, applications should utilize Azure Active Directory or other managed identity providers (such as Microsoft Account, Azure B2C...) to avoid managing user credentials with custom implementation. Modern protocols like OAuth 2.0 use token-based authentication with limited timespan, identity providers offer additional functionality like multi-factor authentication, password reset etc._
* Does the organization enforce conditional access for this workload?


  _Modern cloud-based applications are often accessible over the internet and location-based networking restrictions don't make much sense, but it needs to be mapped and understood what kind of restrictions are required. Multi-factor Authentication (MFA) is a necessity for remote access, IP-based filtering can be used to enable ad-hoc debugging, but VPNs are preferred._
  > Implement Conditional Access Policies.
    - Does the organization enforce password less or multi-factor authentication for users of this workload?


      _Attack methods have evolved to the point where passwords alone cannot reliably protect an account.  Modern authentication solutions including password-less and multi-factor authentication increase security posture through strong authentication._

      > Enforce password-less or MFA.
* Does the organization prioritize authentication via identity services for this workload vs. cryptographic keys?


  _Consideration should always be given to authenticating with identity services rather than cryptographic keys when available. Managing keys securely with application code is difficult and regularly leads to mistakes like accidentally publishing sensitive access keys to code repositories like GitHub. Identity systems (such as Azure Active Directory) offer secure and usable experience for access control with built-in sophisticated mechanisms for key rotation, monitoring for anomalies, and more._
* Does the organization synchronize current on-premises Active Directory with Azure AD, or other cloud identity systems?


  _Consistency of identities across cloud and on-premises will reduce human errors and resulting security risk. Teams managing resources in both environments need a consistent authoritative source to achieve security assurances._
  > Synchronize on-premise directory with Azure AD
    - Does the organization synchronize on-premises admin accounts to Azure Active Directory, or to another cloud identity provider?


      _Synchronizing on-premises admin accounts to Azure Active Directory creates a pivot point that allows an on-premsise compromise to impact Azure workloads._

      > Avoid synching on-premises admin accounts to AAD.
    - Does the organization use cloud provider identity services designed to host non-employee rather than including vendors, partners, and customers into a corporate directory?


      _Using a cloud identity provider reduces risk by granting the appropriate level of access to external entities instead of the full default permissions given to full-time employees. This least privilege approach and clear differentiation of external accounts from company staff makes it easier to prevent and detect attacks coming in from these vectors._

      > Use cloud provider identity services for non-employees.
