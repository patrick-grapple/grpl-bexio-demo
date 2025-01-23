# grapple-template


## getting started

> [!TIP]
> create the secret "bexio-config" first
> k create secret generic bexio-config --from-literal=ExternalOperations=./config bexio-options.json --from-literal=BEXIO_TOKEN=${YOUR_BEXIO_TOKEN}

### dev mode in kubernetes (mac)
    grpl dev ns ${YOUR_NAMESPACE}
    grpl dev

### dev mode in kubernetes (windows)
    devspace use namespace ${YOUR_NAMESPACE}
    devspace dev


## folder structure

    .                   -> application base directory
    ├── src                 -> application src directory
        ├── index.html          -> 
        ├── index.ts            -> 
        ├── App.svelte          -> 
    ├── grapi               -> grapi (grapple API) injections
        ├── controllers          -> grapi controllers
            ├── ping2.controller.ts     -> example controller injection
    ├── gruim               -> gruim (grapple UI modules) injections
        ├── shared          -> gruim shared UI modules 
            ├── *.svelte    -> example gruim UI module injection
    ├── chart               -> helm chart directory ==> https://helm.sh/docs/topics/charts/
        ├── values.yaml         -> the default configuration values for this chart
        ├── values*.yaml        -> values files for different profiles / environments
        ├── Chart.yaml          -> A YAML file containing information about the chart
        ├── templates           -> folder for all yaml manifest templates
        ├── charts              -> folder for sub-charts
    ├── test                -> application test cases directory
        ├── *.sh                -> test cases
    ├── .dockerignore       -> You can use a .dockerignore file to exclude files or directories from the build context.
    ├── .gitignore          -> Specifies intentionally untracked files to ignore
    ├── Dockerfile          -> Dockerfile is a text document containing all the commands the user requires to call on the command line to assemble an image.
    ├── Dockerfile.test     -> Dockerfile for the test cases (optional)
    ├── package.json        -> Dockerfile for the test cases (optional)
    ├── README.md           -> this file
    ├── skaffold.yaml       -> Skaffold contains configuration for all phases of the application delivery process
    ├── webpack.config.js   -> webpack configuration file ==> https://webpack.js.org/concepts/configuration/


## environment variables

APP: define the name of the APP
NAMESPACE: define a namespace extension to the deplyoment

SKAFFOLD_CACHE_ARTIFACTS: "false" - to disable cached artifacts
