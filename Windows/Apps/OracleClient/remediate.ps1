#Source: https://github.com/Eduserv/intune-scripts

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\OracleClient-install.log" -Force -Append

Write-Host "Removing existing version"

$path = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "instantclient*")

foreach ($p in $path) {
    Get-ChildItem -Path $p -Filter "network" | Copy-Item -Destination "$($Env:temp)\instantclientnetwork\" -Recurse -Force
}

$path | Remove-Item -Recurse -Confirm:$false -Force

Write-Host "Removing existing path variable"

$existing = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' | Where-Object {$_ -notlike "$path*"}
[System.Environment]::SetEnvironmentVariable('PATH', ($existing) -join ";", 'Machine')

Write-Host "Finding latest oracle client"

$req = Invoke-WebRequest "https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html"
$lines = $req.Content -split "\n"
$i = -1
foreach ($line in $lines) {
    if ($i -gt 0) {
        $i--
        if ($line -match "//download.oracle.com/.*\.zip") {

            Write-Host "Downloading latest oracle client"

            $m = (Select-String -InputObject $line -Pattern "//download.oracle.com/.*\.zip'").Matches[0].Value
            $m = $m.Substring(0, $m.Length - 1)

            Invoke-WebRequest "https:$m" -OutFile "$($Env:temp)\ic.zip"

            Write-Host "Extracting oracle client to $($Env:SystemDrive)"

            Expand-Archive -Path "$($Env:temp)\ic.zip" -DestinationPath "$($Env:SystemDrive)\" -force

            $path = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "instantclient*").FullName

            Write-Host "Extracted to $($path)"

            Move-Item -Path "$($Env:temp)\instantclientnetwork\network" -Destination $path -Force

            Write-Host "Setting Environment Variable"

            [System.Environment]::SetEnvironmentVariable('PATH', ($existing + $path) -join ";", 'Machine')
            break;
        }
    } elseif ($line -match "<td>Basic Package </td>") {
        $i = 4
    }
}

Stop-Transcript