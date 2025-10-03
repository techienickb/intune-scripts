
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location") {
    $locationConsent = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -ErrorAction SilentlyContinue
    if ($null -ne $locationConsent) {
        Write-Host "Location Services setting found: $locationConsent"
        if ($locationConsent -eq "Allow") {
            Write-Host "Location Services are enabled."
            Exit 0
        }
        elseif ($locationConsent -eq "Deny") {
            Write-Host "Location Services are disabled."
            Exit 1
        }
        else {
            Write-Host "Location Services setting is in an unknown state: $locationConsent"
            Exit 1
        }
    }
    else {
        Write-Host "Location Services setting not found."
        Exit 1
    }
}