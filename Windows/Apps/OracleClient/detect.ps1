#Source: https://github.com/Eduserv/intune-scripts

$paths = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "instantclient*")

if ($paths.Length -eq 0) {
    Write-Host "Not installed"
    Exit 0
} else {
    $currentversion = [System.Version](Select-String -InputObject (Get-Content (Resolve-Path "$paths\BASIC_README")) -Pattern "(\d+\.){2,3}\d").Matches.Value
    $req = Invoke-WebRequest "https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html"
    $lines = $req.Content -split "\n"
    $i = -1
    foreach ($line in $lines) {
        if ($i -gt 0) {
            $i--
            if ($line -match "//download.oracle.com/.*\.zip") {
                $newvesion = [System.Version](Select-String -InputObject $line -Pattern "(\d+\.){2,3}\d").Matches.Value
                if ($currentversion -lt $newvesion) {
                    Write-Error "New version detected"
                    Exit 1
                } else {
                    Write-Host "No new version available"
                    Exit 0
                }
                break
            }
        } elseif ($line -match "<td>Basic Package </td>") {
            $i = 4
        }
    }
}


