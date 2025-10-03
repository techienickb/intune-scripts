$sshServerCapability = Get-WindowsCapability -Online -Name OpenSSH.Server*
if ($sshServerCapability.State -eq 'Installed') {
    Write-Output "OpenSSH Server is installed."
    exit 1
}
else {
    Write-Output "OpenSSH Server is not installed."
    exit 0
}