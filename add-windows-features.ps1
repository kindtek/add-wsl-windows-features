Write-Host "`r`nThe following Windows features will now be installed:" -ForegroundColor Magenta
Write-Host "`t- Hyper-V`r`n`t- Virtual Machine Platform`r`n`t- Powershell 2.0`r`n`t- Containers`r`n`t- Windows Linux Subsystem`r`n`t" -ForegroundColor Magenta

$new_install = $false
$wsl_default_version = "2"

# $install = Read-Host "`r`nPress ENTER to continue or enter `"q`" to quit"
if ($install -ieq 'quit' -Or $install -ieq 'q') { 
    Write-Host "skipping $software_name install and exiting..."
    exit
}

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -ieq 'disabled') {
    Write-Host "`r`nInstalling Hyper-V ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart;exit}" -Wait
    $new_install = $true
} 
else {
    Write-Host "Hyper-V already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName HyperVisorPlatform -Online).State -ieq 'disabled') {
    Write-Host "`r`nInstalling Hyper-V Platform..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Enable-WindowsOptionalFeature -Online -FeatureName HyperVisorPlatform -NoRestart;exit}" -Wait
    $new_install = $true
    # for virtual windows machines, stop the VM and enable nested virtualization on the host:
    # Set-VMProcessor -VMName <VM Name> -ExposeVirtualizationExtensions $true
} 
else {
    Write-Host "Hypervisor Platform already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -ieq 'disabled') {
    Write-Host "Installing VirtualMachinePlatform ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart;exit}" -Wait
    $new_install = $true
} 
else {
    Write-Host "VirtualMachinePlatform features already installed." -ForegroundColor DarkCyan
}

if ($(Get-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online).State -ieq 'disabled') {
    Write-Host "Installing PowerShell 2.0 ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Enable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -All -NoRestart;exit}" -Wait
    $new_install = $true
}
else {
    Write-Host "PowerShell 2.0 already installed." -ForegroundColor DarkCyan
}


if ($(Get-WindowsOptionalFeature -FeatureName Containers -Online).State -ieq 'disabled') {
    Write-Host "Installing Containers ..." -ForegroundColor DarkCyan
    Start-Process powershell -LoadUserProfile -WindowStyle minimized -ArgumentList "-command &{Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart;exit}" -Wait
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

# if (($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'disabled') -Or ($(Get-WindowsOptionalFeature -FeatureName NetFx3 -Online).State -ieq 'DisabledWithPayloadRemoved')) {
#     Write-Host "Installing .NET Framework 3.5 ..." -ForegroundColor DarkCyan
#     Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart

#     $new_install = $true
# } 
# else {
#     Write-Host ".NET Framework 3.5 already installed." -ForegroundColor DarkCyan
# }

if ($(Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -ieq 'disabled') {
    Write-Host "Installing Windows Subsystem for Linux ..." -ForegroundColor DarkCyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
    $new_install = $true
    
} else {
    try {
        wsl.exe --list | Out-Null
        if (!($?)){
            $new_install = $true
            # Write-Host "`r`nInstalling Kali Linux as underlying WSL2 distribution"
            # echo 'user' '' '' '' | wsl.exe --install --distribution kali-linux
            # https://aka.ms/wsl2kernelmsix64
            Invoke-WebRequest -Uri https://aka.ms/wsl2kernelmsix64 -OutFile "$env:USERPROFILE/wsl2kernelmsix64.msi" -TimeoutSec 1000
            Start-Process "$env:USERPROFILE/wsl2kernelmsix64.msi" 
            # Remove-Item "$env:USERPROFILE/wsl2kernelmsix64.msi" -Confirm:$false -Force -ErrorAction SilentlyContinue
            Write-Output 'user' '' '' '' 'exit' | wsl.exe --install --distribution kali-linux
            if ($?){
                # wsl --install command successful .. wait for a distribution to be added to the list
                do {
                    # keep checking
                    wsl.exe --list | Out-Null
                    start-sleep 5
                } while (!($?))
            }
            wsl.exe --set-default-version $wsl_default_version | Out-Null
            # # wsl.exe --list | Out-Null
            # # wsl.exe --install --distribution kali-linux --no-user
            # # if (Test-Path -Path "$env:USERPROFILE/kali-linux.AppxBundle" ) {
            # #     Add-AppxPackage "$env:USERPROFILE/kali-linux.AppxBundle" -UseBasicParsing
            # #     Add-AppxProvisionedPackage -Online -PackagePath "$env:USERPROFILE/kali-linux.AppxBundle" -UseBasicParsing
            # # } else {
            # #     throw
            # # }

            # # wsl.exe --status
            # if (!($?)){
            #     # try {
            #     #     # Remove-AppxPackage -package 'MicrosoftCorporationII.WindowsSubsystemForLinux'
            #     # } catch {}

            #     # if (Test-Path -Path "$env:USERPROFILE/kali-linux.AppxBundle" ) {
            #     #         Add-AppxPackage "$env:USERPROFILE/kali-linux.AppxBundle"
            #     #         Add-AppxProvisionedPackage -Online -PackagePath "$env:USERPROFILE/kali-linux.AppxBundle"
            #     #         Add-AppxProvisionedPackage -Online -PackagePath "$env:USERPROFILE/kali-linux.AppxBundle"
            #     # } else {
            #     #     throw
            #     # }    
            # } else {
            #     wsl.exe --update
            #     if (!($?)){
            #         throw
            #     }
            # }
        } else {
            Write-Host "Windows Subsystem for Linux already installed." -ForegroundColor DarkCyan
        }
    } catch {   
        Invoke-WebRequest -Uri https://aka.ms/wsl2kernelmsix64 -OutFile "$env:USERPROFILE/wsl2kernelmsix64.msi" -TimeoutSec 30000
        Start-Process "$env:USERPROFILE/wsl2kernelmsix64.msi"    
        wsl.exe --install --distribution kali-linux      
        # try {
        #     Invoke-WebRequest -Uri https://aka.ms/wsl-kali-linux-new -OutFile "$env:USERPROFILE/kali-linux.AppxBundle" -TimeoutSec 3000
        #     Add-AppxPackage "$env:USERPROFILE/kali-linux.AppxBundle"
        #     Add-AppxProvisionedPackage -Online -PackagePath "$env:USERPROFILE/kali-linux.AppxBundle"
        #     # Remove-Item -Path "$env:USERPROFILE/kali-linux.AppxBundle"
        # }  catch {
        #     Remove-AppxPackage -package 'kali-linux'
        #     Add-AppxPackage "MicrosoftCorporationII.WindowsSubsystemForLinux"
        #     Add-AppxProvisionedPackage -Online -PackagePath "$env:USERPROFILE/kali-linux.AppxBundle"
            
        # }

    }
}

# Write-Host "`r`n`r`n`tPlease manually install Kali if you don't have a Linux OS installed yet.`r`n`r`n`tCopy/pasta this:`r`n`t`twsl --install --distribution kali-linux --no-launch`r`n`t`twsl --set-version kali-linux 1`r`n" -ForegroundColor Yellow


if ($new_install -eq $true -and ([string]::IsNullOrEmpty($args[0]))) {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor Yellow
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip`r`n" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
    exit
}