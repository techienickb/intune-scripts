#Source: https://github.com/Eduserv/intune-scripts

$path = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "odac*")

if ($path.Length -gt 0) {

    & "$($Env:SystemDrive)\odac\uninstall.bat" ALL c:\oracle myhome true

    Remove-Item "$($Env:SystemDrive)\odac" -Recurse -Force

    Write-Host "Uninstalled"

} else {
    Write-Error "Not Found"
}