docker builder prune -af
docker system prune -af --volumes
winget uninstall --id=Docker.DockerDesktop
Remove-Item "$env:APPDATA\Docker"
Remove-Item "$env:LOCALAPPDATA\Docker"
winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
