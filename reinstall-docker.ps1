winget uninstall --id=Docker.DockerDesktop
winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
