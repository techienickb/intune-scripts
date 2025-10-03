# Remediation script to disable IIS on Windows 11

# Stop IIS services if running
$services = @('W3SVC', 'WAS', 'IISADMIN')
foreach ($svc in $services) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
}

$features = Get-WindowsOptionalFeature -FeatureName IIS* -Online | Where-Object State -eq 'Enabled'
foreach ($feature in $features) {
    Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
}

# Optionally, remove IIS via DISM (for completeness)
dism.exe /Online /Disable-Feature /FeatureName:IIS-WebServerRole /NoRestart