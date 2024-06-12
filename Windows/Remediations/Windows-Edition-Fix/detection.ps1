$WindowsSKU = (Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU
if ($WindowsSKU -eq 4) {
    Write-Output "Windows edition is Enterprise ($WindowsSKU)"
    Exit 0
} elseif ($WindowsSKU -eq 175) {
    Write-Output "Windows edition is Mutli-user Enterprise ($WindowsSKU)"
    Exit 0
} else {
    Write-Output "Windows edition is not Enterprise ($WindowsSKU)"
    Exit 1
}