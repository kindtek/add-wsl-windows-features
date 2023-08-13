Write-Host "`r`nThe following Windows features will now be removed:" -ForegroundColor Magenta
Write-Host "`t- Hyper-V`r`n`t- Virtual Machine Platform`r`n`t- Powershell 2.0`r`n`t- Containers`r`n`t- Windows Linux Subsystem`r`n`t" -ForegroundColor Magenta

$remove = Read-Host "`r`nPress ENTER to continue or enter `"q`" to quit"
if ($remove -ieq 'quit' -Or $remove -ieq 'q') { 
    Write-Host "skipping feature removal and exiting..."
    exit
}

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'enabled') {
    write-host "`r`n"
    Write-Host -nonewline "Removing Hyper-V ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart;exit}" -Wait
} 
else {
    Write-Host "Hyper-V is already disabled." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName HyperVisorPlatform -Online).State -ieq 'enabled') {
    Write-Host "`r`nRemoving Hyper-V Platform..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName HyperVisorPlatform -NoRestart;exit}" -Wait
} 
else {
    Write-Host "Hypervisor Platform is already disabled." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'enabled') {
    Write-Host "Removing VirtualMachinePlatform ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart;exit}" -Wait
} 
else {
    Write-Host "VirtualMachinePlatform features are already disabled." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'enabled') {
    Write-Host "Removing PowerShell 2.0 ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart;exit}" -Wait
}
else {
    Write-Host "PowerShell 2.0 is already disabled." -ForegroundColor DarkCyan
}


if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'enabled') {
    Write-Host "Removing Containers ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName Containers -NoRestart;exit}" -Wait
}
else {
    Write-Host "Containers are already disabled." -ForegroundColor DarkCyan
}

# probably don't need this - will leave here jic
# if ($(Get-WindowsOptionalFeature -FeatureName GuardedHost -Online).State -ieq 'enabled')  {
#     Write-Host "Removing Guarded Host ..." -ForegroundColor DarkCyan
#     Disable-WindowsOptionalFeature -Online -FeatureName GuardedHost -NoRestart
# } 
# else {
#     Write-Host "Guarded Host is already disabled or not required" -ForegroundColor DarkCyan
# }

# if (($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'enabled') -Or ($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'EnabledWithPayloadRemoved')) {
#     Write-Host "Removing .NET Framework 3.5 ..." -ForegroundColor DarkCyan
#     Disable-WindowsOptionalFeature -Online -FeatureName NetFx3 -NoRestart

#     $new_install = $true
# } 
# else {
#     Write-Host ".NET Framework 3.5 is already disabled." -ForegroundColor DarkCyan
# }

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'enabled') {
    Write-Host "Removing Windows Subsystem for Linux ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart;exit}" -Wait
} 
else {
    Write-Host "Windows Subsystem for Linux is already disabled." -ForegroundColor DarkCyan
}

if ([string]::IsNullOrEmpty($args[0])){
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor Yellow
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip`r`n" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
}
