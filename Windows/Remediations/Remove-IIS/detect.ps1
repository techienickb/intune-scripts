$iisFeatures = Get-WindowsOptionalFeature -FeatureName IIS* -Online

if (($iisFeatures.State -ne "Disabled").Count -gt 0) {
    Write-Host "IIS is installed."
    exit 1
}
else {
    Write-Host "IIS is not installed."
    exit 0
}