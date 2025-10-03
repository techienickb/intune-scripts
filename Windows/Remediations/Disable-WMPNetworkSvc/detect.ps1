$service = Get-Service -Name 'WMPNetworkSvc' -ErrorAction SilentlyContinue

if ($service -and $service.Status -eq 'Disabled') {
    Write-Host "WMPNetworkSvc service is disabled."
    exit 0
}
else {
    Write-Host "WMPNetworkSvc service is not disabled."
    exit 1
}