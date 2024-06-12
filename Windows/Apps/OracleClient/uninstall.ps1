#Source: https://github.com/Eduserv/intune-scripts

$path = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "instantclient*")

if ($path.Length -gt 0) {
    $path | Remove-Item -Recurse -Confirm:$false -Force

    $existing = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' | Where-Object {$_ -notlike "$path*"}
    [System.Environment]::SetEnvironmentVariable('PATH', ($existing) -join ";", 'Machine')

    Write-Host "Uninstalled"

} else {
    Write-Error "Not Found"
}