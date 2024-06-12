if ((Get-WindowsPackage -Online -PackageName "Package_for_RollupFix*22621.3672*").Count -eq 0) {
    Write-Host "All good"
    Exit 0
} else {
    Write-Host "Found it!"
    Exit 1
}