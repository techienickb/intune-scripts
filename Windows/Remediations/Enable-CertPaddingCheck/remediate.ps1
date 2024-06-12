$registryPath = "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Conf"
$Name = "EnableCertPaddingCheck"
$value = "1"

if (!(Test-Path $registryPath))
{
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
} else {
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
}

$registryPath = "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Conf"
$Name = "EnableCertPaddingCheck"
$value = "1"

if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
} else {
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force | Out-Null
}