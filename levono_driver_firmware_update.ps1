##Install LSUClient Module

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-ExecutionPolicy Unrestricted -Force
Import-Module PowerShellGet
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name 'LSUClient'
Import-Module LSUClient

##Find updates and install, if Bios update create 

$updates = Get-LSUpdate 
$updates | Install-LSUpdate -SaveBIOSUpdateInfoToRegistry 

##Check registry to see if reboot or shutdown required, then action and clean up regsitry key 

$bios_action = Get-ItemPropertyValue -Path "HKLM:\Software\LSUClient\BIOSUpdate" -Name ActionNeeded
If($bios_action -eq "REBOOT") {
    Write-Host "Rebooting to apply Bios updates"
    Shutdown.exe /r /t 15
    Remove-ItemProperty -Path "HKLM:\Software\LSUClient\BIOSUpdate" -Name ActionNeeded -Force
}
    ElseIf($bios_action -eq "SHUTDOWN") {
        Write-Host "Shutting down to apply Bios Updates"
        Shutdown.exe /s /t 15
        Remove-ItemProperty -Path "HKLM:\Software\LSUClient\BIOSUpdate" -Name ActionNeeded -Force
        }
