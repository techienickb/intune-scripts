#Source: https://github.com/Eduserv/intune-scripts

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\ODAC.log" -Force -Append

Write-Host "Finding latest ODAC"

$req = Invoke-WebRequest "https://www.oracle.com/database/technologies/net-downloads.html" -UseBasicParsing
$lines = $req.Content -split "\n"
$i = -1
foreach ($line in $lines) {
    if ($i -gt 0) {
        $i--
        if ($line -match "//download.oracle.com/otn_software/odac/.*64-bit\.zip") {

            Write-Host "Downloading latest oracle client"

            $m = (Select-String -InputObject $line -Pattern "//download.oracle.com/.*64-bit\.zip").Matches[0].Value

            Invoke-WebRequest "https:$m" -OutFile "$($Env:temp)\odac.zip" -UseBasicParsing

            $path = "$($Env:SystemDrive)\odac\"


            Write-Host "Extracting oracle client to $path"

            Expand-Archive -Path "$($Env:temp)\odac.zip" -DestinationPath $path -force

            Write-Host "Extracted to $path"

            if (Test-Path -Path ./tnsnames.ora) {
                Write-Host "tnsnames.org found, copying"
                Copy-Item -Path ./tnsnames.ora -Destination (Join-Path "$path" "instantclient\network\admin\tnsnames.ora") -Force
                Copy-Item -Path ./tnsnames.ora -Destination (Join-Path "$path" "network\admin\tnsnames.ora") -Force

            }

            if (Test-Path -Path ./sqlnet.ora) {
                Write-Host "sqlnet.org found, copying"
                Copy-Item -Path ./sqlnet.ora -Destination (Join-Path "$path" "instantclient\network\admin\sqlnet.ora") -Force
                Copy-Item -Path ./sqlnet.ora -Destination (Join-Path "$path" "network\admin\sqlnet.ora") -Force

            }

            Write-Host "Running install.bat"

            & "$($Env:SystemDrive)\odac\install.bat" ALL c:\oracle myhome true true

            break;
        }
    } elseif ($line -match "<b>ODAC") {
        $i = 4
    }
}

Stop-Transcript