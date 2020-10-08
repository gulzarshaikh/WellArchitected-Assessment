[![Well-Architected Assessment](/templates/media/wellarchitected-icon.png "Well-Architected Assessment")](#)

# Overview

This Well-Architected Assessment has been produced to help the global CE&S community to identify key optimizations for applications built on Azure, providing key recommendations to better serve our customers. 

More specifically, it has been developed to help structure and frame Microsoft-driven Well-Architected Assessments by providing review questions and consolidated best-practice technical guidance aligned to the [Microsoft Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/).

The assessment guidance contained within this repo is presented through the scope of each individual Well-Architected tenet (Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security), as well as across all tenets as a 'Go-Live' assessment.
For each scoped assessment, the content is structured through three technical lenses:

* _Application_: Provides end-to-end review guidance and questions for application assessments across all relevant technical domains

* _Service_: Focuses on each of the Azure services that have been used in the solution to provide best-practice configuration recommendations and design considerations

* _Scenario_: Extends the application and service lenses with additional review questions and best-practice guidance for specific workload archetypes, such as SAP, HPC, or Internet of Things. 

# Assessment Navigation

|||||
| --- | --- | --- | --- |
| [**Go-Live**](./assessments/golive/overview.md) | Application | Service | Scenario 
| [**Reliability**](./assessments/reliability/overview.md) | [Application](./assessments/reliability/application.md) | [Service](assessments/reliability/service.md) | [Scenario](assessments/reliability/scenario.md) |
| [**Operational Excellence**](./assessments/operationalexcellence/overview.md) | [Application](./assessments/operationalexcellence/application.md) | [Service](./assessments/operationalexcellence/service.md) | Scenario |
| **Security** | Application | Service | Scenario |
| [**Cost Optimization**](./assessments/costoptimization/overview.md) | [Application](./assessments/costoptimization/application.md) | [Service](./assessments/costoptimization/service.md) | Scenario |
| **Performance Efficiency** | Application | Service | Scenario |
|||||

# Repository Structure

* **data**:
This directory contains all the raw assessment content within a JSON format. New content to supplement the guidance provided should be submitted to this directory through a Pull Request.

* **templates**:
A directory that contains the templates for rendering data files into ready-to-consume formats for end-users.

* **assessments**:
This directory contains the Well-Architected assessment scopes. This is where all of the best-practice guidance is presented to end-users. Do not attempt to modify these files directly since they are auto-generated.

# Contributing

There are several ways to contribute to this project.

## Add Content

This is a community maintained inner-source project with active members across the field and engineering. We welcome all contributions to the content, from additional questions and guidance to fixes for spelling errors and typos.

If you have content you would like to add, please feel free to contribute by creating a Pull Request, or by making the wider team aware of potential gaps by creating an Issue.

### How to add/edit content

For a detailed guide on how to edit/add content, please head over the [Contributing.md](./Contributing.md)

## Create Custom Output Formats

By default the content is generated into Markdown using [Hugo](https://gohugo.io/templates/introduction/) templates located within the `templates` directory. To create additional output formats, such as CSV, you can simply adapt the templates and restructure the content - it's just text at the end of the day.

## Build Your Own Output

Assessment markdown guidance for each individual tenet and all tenets combined is generated automatically using GitHub Actions. However, if you wish to build the content on a local machine, you can do so using the Hugo generator with proper configuration; see the Action definition for inspiration.

## TODO: Community

## Disclaimer

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
