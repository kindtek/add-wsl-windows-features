if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}
docker builder prune -af
docker system prune -af --volumes
winget uninstall --id=Docker.DockerDesktop
Remove-Item "$env:APPDATA\Docker" -Force -Confirm:$false 
Remove-Item "$env:LOCALAPPDATA\Docker" -Force -Confirm:$false 
Remove-Item "$env:USERPROFILE\.docker" -Force -Confirm:$false
winget install --id=Docker.DockerDesktop --location="c:\docker" --locale en-US --accept-package-agreements --accept-source-agreements
winget upgrade --id=Docker.DockerDesktop --locale en-US --accept-package-agreements --accept-source-agreements
