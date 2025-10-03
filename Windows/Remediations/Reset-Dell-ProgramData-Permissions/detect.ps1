$path = Join-Path $env:ProgramData "Dell"
if (Test-Path $path) {
    $acl = Get-Acl $path
    if (($acl.Access.IsInherited | Select-Object -last 1) -eq $true) {
        Write-Host "Dell ProgramData permissions are inherited."
        Exit 0
    } else {
        Write-Error "Dell ProgramData permissions are not inherited."
        Exit 1
    }
}

Exit 0