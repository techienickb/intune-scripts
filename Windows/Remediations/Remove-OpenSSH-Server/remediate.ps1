$sshServerCapability = Get-WindowsCapability -Online -Name OpenSSH.Server*

$sshServerCapability | Remove-WindowsCapability -Online