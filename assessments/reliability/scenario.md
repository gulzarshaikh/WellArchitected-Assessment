# Scenario Reliability

# Navigation Menu
- [SAP](#SAP)
  - [Design](#Design)
  - [Platform support](#Platform-support)
# SAP
    
## Design
            
* Are all SAP components used in your design supported on Azure and on the SKU of choice?

  _SAP has strict requirements on what versions of their software can run on Azure and with what configuration this is supported._

  > Review both the SAP software specifics you want to run on Azure. Consult the [Microsoft](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/sap-certifications) and SAP documentation.

    - Is your SAP software supported on Azure?

      _In order to gain support from SAP you must run supported software on Azure._
      > Start with the [SAP software support documentation by Microsoft](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/sap-supported-product-on-azure) and then cross validate against the SAP notes

    - Using HANA? Is your HANA scale mechanism supported?

      _HANA Scale out has limited support, whereas scale up is generally well supported. Validate your support._
      > Validate if your database of choice with  supported in the [SAP HANA Hardware Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/iaas.html#categories=Microsoft%20Azure)

    - Not running HANA? Is your database of choice with software supported?

      _Validate whether you run Windows or Linux and are supported._
      > Reference [SAP Note #1928533](https://launchpad.support.sap.com/#/notes/1928533) to validate whether your choice of VM SKU is supported.

            
        
## Platform support
            
* For HANA, when using premium disks on Mv1/Mv2, is `write accelerator` enabled on log disks?

  _Write Accelerator must be enabled to be in a supported scenario._

  > Ensure write accelerator is enabled for any log disks attached. Ensure that the [prescribed caching mechanisms](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/hana-vm-operations-storage#solutions-with-premium-storage-and-azure-write-accelerator-for-azure-m-series-virtual-machines) for these disks are set.

            
        