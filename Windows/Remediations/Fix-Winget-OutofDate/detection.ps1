#Source: https://github.com/Eduserv/intune-scripts
$allinstallers = Get-AppxPackage -AllUsers Microsoft.DesktopAppInstaller
if ($allinstallers.Length -gt 1) {
    Write-Error "Multiple Wingets"
    Exit 1
} elseif ($allinstallers.Length -eq 1) {
    $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }
    $Winget = $WingetPath + "\winget.exe"
    $wgsource = & $Winget source list winget
    if ($wgsource -like "*https://cdn.winget.microsoft.com/cache*") {
        Write-Host "All good"
        Exit 0
    } else {
        Write-Error "Winget no up to date"
        Exit 1
    }
} else {
    Write-Error "Winget missing"
    Exit 1
}