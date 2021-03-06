
# Contributing

This guide details on how to the editing process works to contribute content to the repository.

First of all it is important to understand that you should **not modify** any of the output files (i.e. the markdown files) in the `assessments/` directory directly. Those files will be automatically generated using [Hugo](https://gohugo.io/templates/introduction/) as a static-site generator. Instead you only need to add your content to the data JSON files in the `data/` directory.

### How to add/edit content

In the `data/` directory, you will find various JSON files. Most of the files have the suffix **.data.json** which contain the actual content. Furthermore there is one **categories.json** file which contains the categories and subcategories we use to structure the content. In most cases you will only need to work in the `.data.json` files.

During the rendering operations, automatically triggered via a GitHub Workflow, all the `.data.json` files are merged as a first step. Hence, the split of content between those files is only to provide an easier way to structure it. If you are not completely sure in which file to add new content (or maybe even to add a new `.data.json` file): Don't worry about this too much. Your content will still be used for rendering in any case.

There are currently the following content types:

- assessment questions (`Questions`)
- design considerations (`Design Considerations`)
- configuration recommendations (`Configuration Recommendations`)
- supporting source artifacts (`Supporting Source Artifacts`)

### JSON structure

While each content type might have some distinct attributes, mostly they share a common (and mandatory) set. Let's look at one example question to explore the attributes and their meaning:

```json
{
    "type": "Questions",
    "pillars": [
      "operationalexcellence",
      "reliability"
    ],
    "lens": "application",
    "category": "Application Design",
    "subCategory": "Design",
    "title": "Is the application deployed across multiple Azure regions and/or utilizing Availability Zones?",
    "context": "Understanding the global operational footprint, for failover or performance purposes, is critical to evaluating overall operations. Generally speaking, multiple Azure regions should be used for disaster recovery procedures, as part of either re-deployment, warm-spare active-passive, or hot-spare active-active recovery strategies. ([Failover strategies](https://docs.microsoft.com/azure/architecture/framework/resiliency/backup-and-recovery))",
    "recommendation": "Consider multi-region deployment and the use of Availability Zones.",
    "children": [
      {
        "title": "Is the application deployed in either active-active, active-passive, or isolated configurations across leveraged regions?",
        "context": "The regional deployment strategy will partly shape operational boundaries, particularly where operational procedures for recovery and scale are concerned",
        "id": "82894085-5a65-4aa4-b943-9275dcbf99c4"
      }
    ],
    "id": "25ac58d3-622d-4869-970f-0962c7a89033"
}
```

### Attributes

First of all: The order of the attributes in a JSON file is not important.

- The attribute `type` determines what kind of content this artifact represents (see above for the available types) and in which output the artifact will be used. Questions are used for assessments (Application lens) while the others are used in more specific guidance (Service and Scenario lenses).
- The `pillars` attribute is an array and indicates for which pillars (one or more) this artifact is applicable. There is often an overlap between the different WAF pillars, so when adding new content, think about which pillars this could be useful for.
- `lens` is either `application` (this will be mostly applicable for type Question), `service` (for Service-specific guidance) or `scenario`.
- `category` and `subCategory` are important attributes. To drive unification across all the content, there is a curated list of available categories and subcategories in the `categories.json` In most cases we expect that new content will fit into an existing subcategory. Only if that is really not that case, add a new (sub-)category to the `categories.json` and add this in your Pull Request. **Important: Any content which references a (sub)category that does not exist in the categories.json file, will not be rendered in the output!**
- `title` is the main part of the content that gets rendered. In the case of a Question, this is the question itself. For Design Considerations and Configuration Recommendations, this is the guidance text.
- `context` is an optional attribute - although it should be filled in most cases to provide more clarity and details to the question/guidance. Ideally this contains a link to some Microsoft/Azure documentation which provides more details.
- `children` is an optional array of artifacts that will be rendered as sub-elements of the artifact. They share all the attributes like type and category with their parents so those do not need to be specified again.
- `id` contains a unique GUID to identify items and refer to them. This field is automatically set via a GitHub workflow.

Some artifacts might have more (optional) attributes but for the main content contributions those mentioned above should be sufficient. Also, when adding new content, it is often the easiest approach to take existing artifacts as examples and start from there.

## Build process and Pull Requests

Whenever you want to add or edit content, you have to do so on your own fork of the repo.

**Important: After you forked the repo, you need to enable the GitHub Action as it is not automatically enabled in the Fork. To do so, head over to "Action" in your forked repo and click on "Enable Workflow". This only has to be done once. If you haven't done this before editing content, you need to make make another commit/push to trigger the workflow to run.**

As soon as you push a commit (on a new branch) to the repo, a GitHub Action is triggered and the output files are automatically regenerated - including your newly added content. If you are interested on how the Action work, you can take a look at the workflow yaml file in **.github/workflows/**

The GitHub Action performs a couple of validations (e.g. that the data files are still valid JSON) and will then run Hugo to render the output files. If successful, the updated output will be added **to your branch** in the assessments folder. Please make sure you check if the your new content shows up like you expected before you create a Pull Request!

Once you are satisfied with the result, you can open a Pull Request to get your branch merged into the **main** branch - which makes the content accessible to everybody once approved.

## Generate output locally

When you want to add or edit a larger amount of content, or want to work on the [templates](./templates), pushing every time just to generate the output can be a bit cumbersome. That's why there is a `tools` branch which contains a PowerShell script to run Hugo locally and generate the output on your PC. You can find the script and instructions [here](https://github.com/Azure/WellArchitected-Assessment/tree/tools/tools/run-local).

For this to run, you need to [install Hugo](https://gohugo.io/getting-started/installing/) locally. Don't worry, you don't need any Go knowledge.
