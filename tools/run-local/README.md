# run-local tool

Adaptation of the series of generator scripts used in GitHub Action. Allows to generate assesment content based on data files locally without running the Action.

## Prerequisites

* This scipt expects you to have Hugo installed in PATH. Chocolatey is a nice way of achieving that: `choco install hugo`.
* PowerShell Core (7) is required.

## How to use with different branch

Since there's no data in this branch anymore, you have to store the script somewhere else and then switch to the branch you want to build.

1. Clone the repo (`tools` branch).
1. Copy the `run-local.ps1` file somewhere else - to your working directory.
1. Change branch.
1. Modify paths at the top of the `run-local.ps1` file to point to the repo.
1. Run the script.
