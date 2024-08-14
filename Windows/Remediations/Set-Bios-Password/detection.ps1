<#
 .SYNOPSIS
  Detects if the BIOS password has been set on HP/Dell/Lenovo devices
 .DESCRIPTION
  Uses WMI/etc to see if the BIOS password has been set
  Source: https://github.com/techienickb/intune-scripts
 .EXAMPLE
  PS C:\> Detection.ps1
    BIOS Password Set
 .OUTPUTS
  0 BIOS Password Set
  1 BIOS Password Not Set
#>
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\BiosDetection.log" -Force -Append
function Write-Log {
    param(
        $MessageType,
        $Message
    )

    $MyDate = "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
    Write-Host  "$MyDate - $MessageType : $Message"
}

if (!(Get-PackageProvider | Where-Object Name -eq "Nuget")) {			
    Write-Log -MessageType "INFO" -Message "The package Nuget is not installed"							
    try {
        Write-Log -MessageType "INFO" -Message "The package Nuget is being installed"						
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force -Confirm:$False | out-null								
        Write-Log -MessageType "SUCCESS" -Message "The package Nuget has been successfully installed"	
    } catch {
        Write-Log -MessageType "ERROR" -Message "An issue occured while installing package Nuget"
        Write-Error "Error installing nuget package provider"
        Exit 1
    }
}

$Get_Manufacturer_Info = (Get-WmiObject win32_computersystem).Manufacturer
if ($Get_Manufacturer_Info -like "*HP*") {
    Write-Log -MessageType "INFO" -Message "Manufacturer: HP"	
    $IsPasswordSet = (Get-WmiObject -Namespace root/hp/instrumentedBIOS -Class HP_BIOSSetting | Where-Object Name -eq "Setup password").IsSet
} elseif ($Get_Manufacturer_Info -like "*Lenovo*") {
    Write-Log -MessageType "INFO" -Message "Manufacturer: Lenovo"
    $IsPasswordSet = (Get-WmiObject -Class Lenovo_BiosPasswordSettings -Namespace root\wmi).PasswordState
} elseif ($Get_Manufacturer_Info -like "*Dell*") {
    Write-Log -MessageType "INFO" -Message "Manufacturer: Dell"
    $module_name = "DellBIOSProvider"
    if (Get-Module -ListAvailable -Name $module_name) {
        Update-Module $Module_Name -Force -Confirm:$false
        Import-Module $module_name -Force
        Write-Log -MessageType "INFO" -Message "Module Dell imported"	
    } else {
        Write-Log -MessageType "INFO" -Message "Module Dell not installed"
        Install-Module -Name DellBIOSProvider -Force -Confirm:$false -Scope AllUsers
        Write-Log -MessageType "INFO" -Message "Module Dell has been installed"
    }	
    $IsPasswordSet = (Get-Item -Path DellSmbios:\Security\IsAdminPasswordSet).currentvalue 	
} 

if (($IsPasswordSet -eq 1) -or ($IsPasswordSet -eq "true") -or ($IsPasswordSet -eq $true) -or ($IsPasswordSet -eq 2)) {
    Write-Log -MessageType "SUCCESS" -Message "The device has the latest BIOS password"
    Write-Host "The device has the latest BIOS password"
    Stop-Transcript
    Exit 0	
} else {
    Write-Log -MessageType "ERROR" -Message "Your BIOS is not password protected"
    Write-Error "Your BIOS is not password protected"
    Stop-Transcript
    Exit 1
}