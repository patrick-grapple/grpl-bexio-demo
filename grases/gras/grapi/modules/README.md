# Backend modules

Add custom backend modules in subdirectories here. They are packaged by `Dockerfile.modules`, copied into `/opt/custom-modules` by the backend init container, and installed by Grapi at startup. DevSpace also syncs module sources and reinstalls them after upload.
