$registryPath = "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Conf"
$Name = "EnableCertPaddingCheck"
$value = "1"

if (!(Test-Path $registryPath)) {
    Write-Host "Fix needed blah"
    Exit 1
}
else {
    try {
        $cu = Get-ItemPropertyValue -Path $registryPath -Name $Name
        if ($value -ne $cu) {
            Write-Host "$value = $cu"
            Write-Host "Fix needed"
            Exit 1
        }
    }
    catch { 
        Write-Host "Fix needed"
        Exit 1
    }
}

$registryPath = "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Conf"

if (!(Test-Path $registryPath)) {
    Write-Host "Fix needed"
    Exit 1
}
else {
    try {
        $cu = Get-ItemPropertyValue -Path $registryPath -Name $Name
        if ($value -ne $cu) {
            Write-Host "Fix needed"
            Exit 1
        }
    }
    catch { 
        Write-Host "Fix needed"
        Exit 1
    }
}

Write-Host "Fix not needed"
Exit 0