if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}

Write-Host "completely removing Docker installation"
docker builder prune -af
docker system prune -af --volumes
wsl --unregister docker-desktop
Remove-Item "$env:APPDATA\Docker*" -Recurse -Force -Confirm:$false 
Remove-Item "$env:LOCALAPPDATA\Docker*" -Recurse -Force -Confirm:$false 
Remove-Item "$env:USERPROFILE\.docker" -Recurse -Force -Confirm:$false
Remove-Item "$env:PROGRAMDATA\Docker*" -Recurse -Force -Confirm:$false
winget uninstall --id=Docker.DockerDesktop
Write-Host "Hit ENTER to proceed with Docker Desktop installation"
# winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget install --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile DockerDesktopInstaller.exe
.\DockerDesktopInstaller.exe
# & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
# "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
Remove-Item "$env:USERPROFILE/repos/kindtek/dvlw/.docker-installed" -Force -ErrorAction SilentlyContinue
Remove-Item "DockerDesktopInstaller.exe" -Force -ErrorAction SilentlyContinue