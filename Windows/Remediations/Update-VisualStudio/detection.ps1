#Source: https://github.com/Eduserv/intune-scripts

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\VisualStudioUpdate.log" -Force -Append

function Write-Log {
    param(
        $MessageType,
        $Message
    )

    $MyDate = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    Write-Host  "$MyDate - $MessageType : $Message"
}

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if ($ResolveWingetPath){
    $WingetPath = $ResolveWingetPath[-1].Path
}

$Winget = $WingetPath + "\winget.exe"

$vsinstalled = & "$winget" list --id "Microsoft.VisualStudio.2022.Professional" --exact

if ($vsinstalled.Length -lt 5) {
    Write-Log -MessageType "INFO" -Message "VS not installed"
    exit 0
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

$module_name = "VSSetup"
if (Get-Module -ListAvailable -Name $module_name) {
    Update-Module $Module_Name -Force -Confirm:$false
    Import-Module $module_name -Force
    Write-Log -MessageType "INFO" -Message "Module $module_name imported"	
} else {
    Write-Log -MessageType "INFO" -Message "Module $module_name not installed"
    Install-Module -Name $module_name -Force -Confirm:$false -Scope AllUsers
    Write-Log -MessageType "INFO" -Message "Module $module_name has been installed"
}

$vspath = (Get-VsSetupInstance).InstallationPath

Write-Log -MessageType "INFO" -Message "Found VS at $vspath"

$installer_path = Resolve-Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe"

$process = Start-Process -FilePath $installer_path -ArgumentList "updateall", "--quiet", "--norestart", "--force" -Wait -PassThru
Write-Output $process.ExitCode 

if ($null -ne $process.StandardError) {
    if ($process.StandardError.ReadToEnd() -ilike "0x80131500") { 
        & "$winget" install --id "Microsoft.VisualStudio.2022.Professional" --exact --custom updateall --quiet
    }
}

Stop-Transcript
Exit $process.ExitCode