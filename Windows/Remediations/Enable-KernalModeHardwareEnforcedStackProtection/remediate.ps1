$kp = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"

if (-not (Test-Path $kp)) {
    New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios" -Name "KernelShadowStacks"
}

New-ItemProperty -Path $kp -Name "Enabled" -Value 1 -PropertyType "dword" -Force
New-ItemProperty -Path $kp -Name "WasEnabledBy" -Value 2 -PropertyType "dword" -Force