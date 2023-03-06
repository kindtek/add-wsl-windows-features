Write-Host "`r`nThe following Windows features will now be installed:" -ForegroundColor Magenta
Write-Host "`t- Hyper-V`r`n`t- Virtual Machine Platform`r`n`t- Containers`r`n`t- Windows Linux Subsystem`r`n`t- Powershell 2.0" -ForegroundColor Magenta


$new_install = $false
$wsl_default_version = "1"
$installing_wsl_features = $false

# $install = Read-Host "`r`nPress ENTER to continue or enter `"q`" to quit"
if ($install -ieq 'quit' -Or $install -ieq 'q') { 
    Write-Host "skipping $software_name install and exiting..."
    exit
}
else { Write-Host "`r`n" }


if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'disabled') {
    Write-Host "`r`n`tInstalling Hyper-V ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart 
    $new_install = $true
} 
else {
    Write-Host "`tHyper-V already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'disabled') {
    Write-Host "`tInstalling VirtualMachinePlatform ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    $new_install = $true
} 
else {
    Write-Host "`tVirtualMachinePlatform features already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled') {
    Write-Host "`tInstalling Containers ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart 
    $new_install = $true
} 
else {
    Write-Host "`tContainers already installed." -ForegroundColor DarkCyan
}


if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "`tInstalling Windows Subsystem for Linux ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
    $new_install = $true
    try {
        Write-Host "`r`n`tInstalling Ubuntu as your WSL 1 source. Want version 2? Copy/pasta this:`r`n`t`twsl --set-version Ubuntu 2`r`n`r`n" -ForegroundColor Yellow
        wsl.exe --set-default-version $wsl_default_version
        wsl.exe --install --distribution Ubuntu --inbox --no-launch 
        Set-VMProcessor -VMName Ubuntu -ExposeVirtualizationExtensions $true
    }
    catch {}

} 
else {
    Write-Host "`tWindows Subsystem for Linux already installed." -ForegroundColor DarkCyan
    Write-Host "`r`n`r`n`tPlease manually install Ubuntu if you don't have a Linux OS installed yet.`r`n`r`n`tCopy/pasta this:`r`n`t`twsl --install --distribution Ubuntu --no-launch`r`n`t`twsl --set-version Ubuntu 1`r`n" -ForegroundColor Yellow
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "`tInstalling PowerShell 2.0 ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart
    $new_install = $true
}
else {
    Write-Host "`tPowerShell 2.0 already installed." -ForegroundColor DarkCyan
}

if ($new_install -eq $true) {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta
    # $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip`r`n" 
    # if ($confirmation -ieq 'reboot now') {
    #     Restart-Computer -Force
    # }
}
