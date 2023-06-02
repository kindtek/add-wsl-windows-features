docker builder prune -af
docker system prune -af --volumes
winget uninstall --id=Docker.DockerDesktop
Remove-Item "$env:APPDATA\Docker" -Force -Confirm:$false 
Remove-Item "$env:LOCALAPPDATA\Docker" -Force -Confirm:$false 
Remove-Item "$env:USERPROFILE\.docker" -Force -Confirm:$false
winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
