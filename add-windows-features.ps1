Write-Host "`r`nThe following Windows features will now be installed:" -ForegroundColor Magenta
Write-Host "`t- Hyper-V`r`n`t- Virtual Machine Platform`r`n`t- Powershell 2.0`r`n`t- Containers`r`n`t-.NET Framework 3.5`r`n`t- Windows Linux Subsystem`r`n`t" -ForegroundColor Magenta


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
    Write-Host "`r`nInstalling Hyper-V ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart 
    $new_install = $true
} 
else {
    Write-Host "Hyper-V already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName HyperVisorPlatform -Online).State -ieq 'disabled') {
    Write-Host "`r`nInstalling Hyper-V Platform..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName HyperVisorPlatform -NoRestart 
    $new_install = $true
    # for virtual windows machines, stop the VM and enable nested virtualization on the host:
    # Set-VMProcessor -VMName <VM Name> -ExposeVirtualizationExtensions $true
} 
else {
    Write-Host "Hypervisor Platform already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'disabled') {
    Write-Host "Installing VirtualMachinePlatform ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    $new_install = $true
} 
else {
    Write-Host "VirtualMachinePlatform features already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "Installing PowerShell 2.0 ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart
    $new_install = $true
}
else {
    Write-Host "PowerShell 2.0 already installed." -ForegroundColor DarkCyan
}


if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled') {
    Write-Host "Installing Containers ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    $new_install = $true
}
else {
    Write-Host "Containers already installed." -ForegroundColor DarkCyan
}

# probably don't need this - will leave here jic
# if ($(Get-WindowsOptionalFeature -FeatureName GuardedHost -Online).State -ieq 'disabled')  {
#     Write-Host "Installing Guarded Host ..." -ForegroundColor DarkCyan
#     Enable-WindowsOptionalFeature -Online -FeatureName GuardedHost -All -NoRestart
#     $new_install = $true
# } 
# else {
#     Write-Host "Guarded Host already installed or not required" -ForegroundColor DarkCyan
# }

if (($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'disabled') -Or ($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'DisabledWithPayloadRemoved')) {
    Write-Host "Installing .NET Framework 3.5 ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart

    $new_install = $true
} 
else {
    Write-Host ".NET Framework 3.5 already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "Installing Windows Subsystem for Linux ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
    $new_install = $true
    try {
        Write-Host "`r`nInstalling Ubuntu as your WSL 1 source. Want version 2? Copy/pasta this:`r`n`t`twsl --set-version Ubuntu 2`r`n`r`n" -ForegroundColor Yellow
        wsl.exe --set-default-version $wsl_default_version
        wsl.exe --install --distribution Ubuntu --inbox --no-launch 
        Set-VMProcessor -VMName Ubuntu -ExposeVirtualizationExtensions $true
    }
    catch {}

} 
else {
    Write-Host "`tWindows Subsystem for Linux already installed." -ForegroundColor DarkCyan
    # Write-Host "`r`n`r`n`tPlease manually install Ubuntu if you don't have a Linux OS installed yet.`r`n`r`n`tCopy/pasta this:`r`n`t`twsl --install --distribution Ubuntu --no-launch`r`n`t`twsl --set-version Ubuntu 1`r`n" -ForegroundColor Yellow
}

if ($new_install -eq $true) {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor Yellow
    # $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip`r`n" 
    # if ($confirmation -ieq 'reboot now') {
    #     Restart-Computer -Force
    # }
}
