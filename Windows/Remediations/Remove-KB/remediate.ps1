Get-WindowsPackage -Online -PackageName "Package_for_RollupFix~*22621.3672*" | ForEach-Object {
    Remove-WindowsPackage -Online -NoRestart -PackageName $_.PackageName
}