if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}

Read-Host "Hit ENTER to proceed with Docker Desktop re-install"
docker builder prune -af | Out-Null
docker system prune -af --volumes | Out-Null
wsl.exe --unregister docker-desktop | Out-Null
wsl.exe --unregister docker-desktop-data | Out-Null
Remove-Item "$env:APPDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.docker" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item "$env:PROGRAMDATA\Docker*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
winget uninstall --id=Docker.DockerDesktop
Remove-Item "$env:USERPROFILE/repos/kindtek/.docker-installed" -Force -ErrorAction SilentlyContinue
# sometimes hangs and needs an enter key for some reason
Write-Host "Hit ENTER to proceed with Docker Desktop installation"
# winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget install --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile DockerDesktopInstaller.exe
.\DockerDesktopInstaller.exe
# & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
# "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE/repos/kindtek" | Out-Null
Write-Host "Docker installed" | Out-File -FilePath "$env:USERPROFILE/repos/kindtek/.docker-installed"
Remove-Item "DockerDesktopInstaller.exe" -Force -ErrorAction SilentlyContinue