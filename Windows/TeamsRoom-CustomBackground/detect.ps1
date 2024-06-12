<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR Nick Brown
.DESCRIPTION Detects if Custom Background/Wallpaper has been set and is up to date based on the blob storage
.COMPANYNAME Jisc
.COPYRIGHT GPL
.PROJECTURI https://github.com/Eduserv/intune-scripts
#>
$blob = "Some url / blob"
$wallpaper = "2023ThemingTemplateMicrosoftTeamsRoom.jpg"

function Invoke-CheckFile {
    param (
        [String]$Identity
    )
    if (Test-Path $Identity) {
        $current = Get-Item (Join-Path C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\ $Identity)
        $new = Get-Item (Join-Path $env:TEMP $Identity)
        if ($current.Length -eq $new.Length) {
            return $true
        }
    }

    return $false
}

if (Test-Path C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\) {
    Invoke-WebRequest -Uri "$blob/$wallpaper" -OutFile (Join-Path $env:TEMP $wallpaper) -UseBasicParsing
    Invoke-WebRequest -Uri "$blob/tablet.jpg" -OutFile (Join-Path $env:TEMP "tablet.jpg") -UseBasicParsing
    If ((Invoke-CheckFile tablet.jpg) -and (Invoke-CheckFile $wallpaper)) {
        Write-Output "No update needed"
        Remove-Item (Join-Path $env:TEMP $wallpaper)
        Remove-Item (Join-Path $env:TEMP "tablet.jpg")
        Exit 0
    }
    Else {
        Write-Output "Teams Rooms Customizations not up-to-date"
        Remove-Item (Join-Path $env:TEMP $wallpaper)
        Remove-Item (Join-Path $env:TEMP "tablet.jpg")
        Exit 1
    }
} else {
    Write-Output "Teams Room not installed"
    Exit 0
}