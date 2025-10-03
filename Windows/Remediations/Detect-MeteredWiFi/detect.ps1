$profiles = netsh wlan show profiles
$profiles = $profiles | where-object { $_ -like "*All User Profile*" }
$pcount = 0
$m = @()
$mcount = 0
foreach ($wprofile in $profiles) { 
    $p = netsh wlan show profile "$($wprofile.substring($wprofile.indexOf(':') + 2).Trim())"
    $pcount++
    if ($p -like "* Cost  * : Fixed*") { 
        $m += "$($wprofile.substring($wprofile.indexOf(':') + 2).Trim())"
        $mcount++
    } 
}

if ($mcount -gt 0) {
    Write-Host "There are $mcount profiles metered out of $pcount total profiles. $($m -join ', ')"
    Exit 1
} else {
    Write-Host "All $pcount profiles are unmetered."
    Exit 0
}