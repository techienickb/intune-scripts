$RegistryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin"
$keyName = "BlockAADWorkplaceJoin"

# Check if the key is already in place; if so, exit
$existingKey = Get-ItemProperty -Path $RegistryLocation -Name $keyName -ErrorAction SilentlyContinue
if ($existingKey -and $existingKey.$keyName -eq 1) {
    Write-Output "Registry key is already in place."
    Exit 0
}

# Create the registry path if it is missing
if (!(Test-Path -Path $RegistryLocation)) {
    Write-Output "Registry location is missing. Creating it now."
    New-Item -Path $RegistryLocation -Force | Out-Null
}

# Set the key value
New-ItemProperty -Path $RegistryLocation -Name $keyName -PropertyType DWord -Value 1 -Force | Out-Null

# Verify the key has been created successfully
$checkKey = Get-ItemProperty -Path $RegistryLocation -Name $keyName -ErrorAction SilentlyContinue
if ($checkKey -and $checkKey.$keyName -eq 1) {
    Write-Output "Registry key has been successfully set."
    Exit 0
} else {
    Write-Error "Failed to create registry key!"
    Exit 1
}