#Source: https://github.com/techienickb/intune-scripts

$Path_local = "$Env:Programdata\Microsoft\IntuneManagementExtension\Logs"
Start-Transcript -Path "$Path_local\AppX-install.log" -Force

$removeList = 'Microsoft.GamingApp', 'MicrosoftCorporationII.QuickAssist', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.MixedReality.Portal', 'Microsoft.MicrosoftOfficeHub', 'Microsoft.Xbox', 'Microsoft.SkypeApp', 'Microsoft.People', 'microsoft.windowscommunicationsapps', 'MicrosoftTeams', 'MicrosoftCorporationII.MicrosoftFamily', 'Microsoft.MSPaint', 'Microsoft.Microsoft3DViewer', 'Microsoft.Windows.DevHome'

$errored = $false

$system = (& whoami) -like '*SYSTEM'

foreach ($item in $removeList) {
    if ($null -ne (Get-AppxPackage -Name $item)) {
        Write-Error "$item found"
        $errored = $true
    }
    if ($system -eq $true) {
        if ($null -ne (Get-AppxPackage -AllUsers -Name $item)) {
            Write-Host "$item found, removing"
            $errored = $true
        }        
        if ($null -ne (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $item)) {
            Write-Host "$item found in ProvisionedPackage, removing"
            $errored = $true
        }
    }
}

if ($errored -eq $true) {
    Write-Error "Issue found"
}
else {
    Write-Output "No issues found"
}

Stop-Transcript
if ($errored -eq $true) {
    exit 1
} else {
    exit 0
}