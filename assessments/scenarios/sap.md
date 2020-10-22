# Scenario SAP

# Navigation Menu

  - [SAP](#SAP)
    - [Design](#Design)
    - [Platform support](#Platform-support)
# SAP
        
## Design
### Questions
* Are all SAP components used in your design supported on Azure and on the SKU of choice?
  > SAP has strict requirements on what versions of their software can run on Azure and with what configuration this is supported.
                            
  - Is your SAP software supported on Azure?
    > In order to gain support from SAP you must run supported software on Azure.
                                
                            
  - Using HANA? Is your HANA scale mechanism supported?
    > HANA Scale out has limited support, whereas scale up is generally well supported. Validate your support.
                                
                            
  - Not running HANA? Is your database of choice with software supported?
    > Validate whether you run Windows or Linux and are supported.
                                
                            
## Platform support
### Questions
* For HANA, when using premium disks on Mv1/Mv2, is `write accelerator` enabled on log disks?
  > Write Accelerator must be enabled to be in a supported scenario.
                            