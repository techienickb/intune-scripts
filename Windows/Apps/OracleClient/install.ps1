#Source: https://github.com/Eduserv/intune-scripts

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\OracleClient-install.log" -Force -Append

Write-Host "Finding latest oracle client"

$req = Invoke-WebRequest "https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html" -UseBasicParsing
$lines = $req.Content -split "\n"
$i = -1
foreach ($line in $lines) {
    if ($i -gt 0) {
        $i--
        if ($line -match "//download.oracle.com/.*\.zip") {

            Write-Host "Downloading latest oracle client"

            $m = (Select-String -InputObject $line -Pattern "//download.oracle.com/.*\.zip'").Matches[0].Value
            $m = $m.Substring(0, $m.Length - 1)

            Invoke-WebRequest "https:$m" -OutFile "$($Env:temp)\ic.zip" -UseBasicParsing

            Write-Host "Extracting oracle client to $($Env:SystemDrive)"

            Expand-Archive -Path "$($Env:temp)\ic.zip" -DestinationPath "$($Env:SystemDrive)\" -force

            $path = (Get-ChildItem "$($Env:SystemDrive)\" -Directory -Filter "instantclient*").FullName

            Write-Host "Extracted to $($path)"

            if (Test-Path -Path ./tnsnames.ora) {
                Write-Host "tnsnames.org found, copying"
                Copy-Item -Path ./tnsnames.ora -Destination (Join-Path "$path" "network\admin\tnsnames.ora") -Force
            }

            if (Test-Path -Path ./sqlnet.ora) {
                Write-Host "sqlnet.org found, copying"
                Copy-Item -Path ./sqlnet.ora -Destination (Join-Path "$path" "network\admin\sqlnet.ora") -Force
            }

            Write-Host "Setting Environment Variable"

            $existing = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' | Where-Object {$_ -notlike "$path*"}
            [System.Environment]::SetEnvironmentVariable('PATH', ($existing + $path) -join ";", 'Machine')
            break;
        }
    } elseif ($line -match "<td>Basic Package </td>") {
        $i = 4
    }
}

Stop-Transcript