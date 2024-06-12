#Source: https://github.com/Eduserv/intune-scripts

$paths = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "odac")

if ($paths.Length -eq 0) {
    Write-Error "Not detected!"
} else {
    Write-Host "Found it!"
}