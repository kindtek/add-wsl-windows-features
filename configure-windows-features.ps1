Write-Host "`r`nRunning this script will install/enable the optional Windows features required for running Virtual Machines, WSL, and Powershell 2.0...`r`n" -ForegroundColor Magenta
# Write-Host "After the Windows features are enabled you will need to reboot your system for changes to take effect." -ForegroundColor Magenta

$new_install = $false

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'disabled') {
    Write-Host "Installing Microsoft Hyper-V features." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
$new_install = $true
} 
else {
    Write-Host "Hyper-V feature already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'disabled') {
    Write-Host "Installing VM features." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    $new_install = $true


} 
else {
    Write-Host "VM features already installed." -ForegroundColor DarkCyan
}
if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled') {
    Write-Host "Installing VM features." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    $new_install = $true


} 
else {
    Write-Host "Container features already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "Installing WSL feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    $new_install = $true

} 
else {
    Write-Host "WSL feature already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "Installing PowerShell 2.0 feature." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart
    $new_install = $true

}
else {
    Write-Host "PowerShell 2.0 feature already installed." -ForegroundColor DarkCyan
}

if ($new_install -eq $true){
    Write-Host "A restart is required for the changes to take effect. " -ForegroundColor Magenta
    $confirmation = Read-Host "`r`nRestart now (y/[n])?" -ForegroundColor Magenta
    if ($confirmation -ieq 'y') {
        Restart-Computer -Force
    }
}
