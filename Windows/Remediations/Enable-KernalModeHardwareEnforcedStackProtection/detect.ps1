$kp = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"

if (-not (Test-Path $kp)) {
    Write-host "KernelShadowStacks key missing"
    Exit 1
}

$value = Get-ItemPropertyValue -Path $kp -Name "Enabled"
if ($null -eq $value) {
    Write-Host "Not enabled"
    Exit 1
} else {
    if ($value -eq 1) {
        Write-Host "KernelShadowStacks is enabled."
        Exit 0
    } else {
        Write-Error "KernelShadowStacks is not enabled. Expected value: 1, but found: $value"
        Exit 1
    }
}