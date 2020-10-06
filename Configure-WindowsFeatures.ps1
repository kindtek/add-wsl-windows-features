Write-Host "Runnng this script will install/enable the optional Windows features of Hyper-V and Containers."
Write-Host "After the Windows features are enabled you will be prompted to reboot." -ForegroundColor Magenta

$(Get-WindowsOptionalFeature -FeatureName containers -Online).state == 'disabled' 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
$(Get-WindowsOptionalFeature -FeatureName containers -Online).state == 'disabled'
Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart

$confirmation = Read-Host "A restart is required for the changes to take effect. Restart now (y/n)?"
if ($confirmation -eq 'y') {
    Restart-Computer -Force
}
else {
    Write-Host "At a time convenient to you, restart the machine for the changes to take effect."
}


