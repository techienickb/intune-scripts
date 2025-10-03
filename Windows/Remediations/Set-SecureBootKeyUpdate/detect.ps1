$value = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Secureboot\" -Name "MicrosoftUpdateManagedOptIn"
if ($null -eq $value) {
    Exit 1
} else {
    if ($value -eq 0x5944) {
        Write-Host "Secure boot update is enabled."
        Exit 0
    } else {
        Write-Error "Secure boot update is not enabled. Expected value: 0x5944, but found: $value"
        Exit 1
    }
}