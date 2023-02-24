Write-Host "Running this script will install/enable the optional Windows features for Virtual Machines, WSL, and Powershell 2.0..."
Write-Host "After the Windows features are enabled this script will force a system reboot." -ForegroundColor Magenta

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'disabled') {
    Write-Host "Installing Microsoft Hyper-V and VM features." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
} 

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "Installing WSL feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
} 

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "Installing PowerShell 2.0 feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart

}

$confirmation = Read-Host "A restart is required for the changes to take effect. Restart now (y/n)?"
if ($confirmation -ieq 'y') {
    Restart-Computer -Force
}
else {
    Write-Host "At a time convenient to you, restart the machine for the changes to take effect."
}