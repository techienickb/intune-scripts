#Source: https://github.com/Eduserv/intune-scripts

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\AppX-install.log" -Force

$removeList = 'Microsoft.GamingApp', 'MicrosoftCorporationII.QuickAssist', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.MixedReality.Portal', 'Microsoft.MicrosoftOfficeHub', 'Microsoft.Xbox', 'Microsoft.SkypeApp', 'Microsoft.People', 'microsoft.windowscommunicationsapps', 'MicrosoftTeams', 'MicrosoftCorporationII.MicrosoftFamily', 'Microsoft.MSPaint', 'Microsoft.Microsoft3DViewer', 'Microsoft.Windows.DevHome'

$system = (& whoami) -like '*SYSTEM'

foreach ($item in $removeList) {
    if ($null -ne (Get-AppxPackage -Name $item)) {
        Write-Host "$item found, removing"
        Get-AppxPackage -Name $item | Remove-AppxPackage
    }
    if ($system -eq $true) {
        if ($null -ne (Get-AppxPackage -AllUsers -Name $item)) {
            Write-Host "$item found, removing"
            Get-AppxPackage -Name $item -AllUsers | Remove-AppxPackage -AllUsers
        }        
        if ($null -ne (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $item)) {
            Write-Host "$item found in ProvisionedPackage, removing"
            (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $item) | Remove-ProvisionedAppxPackage -AllUsers
        }
    }
}

Stop-Transcript