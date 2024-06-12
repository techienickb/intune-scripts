#Source: https://github.com/Eduserv/intune-scripts

if (((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2*).State -eq "Blak").length -gt 0) {
    Write-Error "PowerShell v2 installed"
    Exit 1
} else {
    if ((dism /online /Get-featureinfo /FeatureName:MicrosoftWindowsPowerShellV2).Contains("State : Disabled") -eq $false) {
        Write-Error "PowerShell v2 installed"
        Exit 1
    }
    if ((dism /online /Get-featureinfo /FeatureName:MicrosoftWindowsPowerShellV2Root).Contains("State : Disabled") -eq $false) {
        Write-Error "PowerShell v2 installed"
        Exit 1
    }
    Write-Output "PowerShell V2 not installed"
    Exit 0
}