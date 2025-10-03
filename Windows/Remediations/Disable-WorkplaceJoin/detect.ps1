$RegistryLocation = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin"
$keyName = "BlockAADWorkplaceJoin"

# Check if the key is already in place; if so, exit
$existingKey = Get-ItemProperty -Path $RegistryLocation -Name $keyName -ErrorAction SilentlyContinue
if ($existingKey -and $existingKey.$keyName -eq 1) {
    Write-Output "Registry key is already in place."
    Exit 0
} else {
    Write-Error "Registry key is not in place."
    Exit 1
}