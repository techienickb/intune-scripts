# Disable the Windows Media Player Network Sharing Service (WMPNetworkSvc)

$serviceName = "WMPNetworkSvc"

# Stop the service if it's running
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
    Set-Service -Name $serviceName -StartupType Disabled
}