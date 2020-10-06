Write-Host "Runnng this script will install/enable the optional Windows features of Hyper-V and Containers."
Write-Host "After the Windows features are enabled this script will force a system reboot." -ForegroundColor Magenta

if($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online).State -ieq 'disabled')
{
    Write-Host "Installing Microsoft Hyper V feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
} 

if($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled')
{
    Write-Host "Installing Containers feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
}

$confirmation = Read-Host "A restart is required for the changes to take effect. Restart now (y/n)?"
if ($confirmation -ieq 'y') {
    Restart-Computer -Force
}
else {
    Write-Host "At a time convenient to you, restart the machine for the changes to take effect."
}