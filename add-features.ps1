Write-Host "`r`nThe following Windows features will now be installed:" -ForegroundColor Magenta
Write-Host "`t- Hyper-V`r`n`t- Virtual Machine Platform`r`n`t- Containers`r`n`t- Windows Linux Subsystem`r`n`t- Powershell 2.0" -ForegroundColor Magenta

$new_install = $false
$install = Read-Host "`r`nPress ENTER to continue or enter `"q`" to quit"
if ($install -ieq 'quit' -Or $install -ieq 'q') { 
    Write-Host "skipping $software_name install and exiting..."
    exit
}
else { Write-Host "`r`n"}


if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'disabled') {
    Write-Host "`r`nInstalling Hyper-V ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    $new_install = $true
} 
else {
    Write-Host "Hyper-V already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'disabled') {
    Write-Host "Installing VirtualMachinePlatform ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    $new_install = $true
} 
else {
    Write-Host "VirtualMachinePlatform features already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled') {
    Write-Host "Installing Containers ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    $new_install = $true
} 
else {
    Write-Host "Containers already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "Installing Windows Subsystem for Linux ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    $new_install = $true

} 
else {
    Write-Host "Windows Subsystem for Linux already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "Installing PowerShell 2.0 ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart
    $new_install = $true

}
else {
    Write-Host "PowerShell 2.0 already installed." -ForegroundColor DarkCyan
}

if ($new_install -eq $true) {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
}
