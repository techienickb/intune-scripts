#use this command to get the base64 encoded file for the $b64 param
#[convert]::ToBase64String((Get-Content -path xxx.pfx -Encoding byte)) | Set-Clipboard
#Source https://github.com/techienickb/intune-scripts

$b64 = "enter the base 64 encded PFX file from above"

$byteContent = [System.Convert]::FromBase64String($b64)
$byteContent | Set-Content (Join-Path $Env:TEMP -ChildPath "temp.pfx") -Encoding Byte -Force

try {
    Import-PfxCertificate -FilePath (Join-Path $Env:TEMP -ChildPath "temp.pfx") cert:\localmachine\my
} catch {
    Write-Error "Certificate Import Failed"
    Exit 1
}

Remove-Item (Join-Path $Env:TEMP -ChildPath "temp.pfx")

Write-Host "Cert Imported"
Exit 0