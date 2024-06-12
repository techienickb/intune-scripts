$Uninstallers = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty
$Dell = $Uninstallers | Where-Object DisplayName -match "*Dell*" | Where-Object DisplayName -NotMatch "*Configure*"

if ($Dell.Length -gt 0) {
    Write-Host "Dell stuff found - Cleanup needed"
    exit 1
} else {
    Write-Host "All ok"
    exit 0
}