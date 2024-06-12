function Invoke-CheckFile {
    param (
        [String]$Identity
    )
    if (Test-Path $Identity -eq $false) {
        return $false
    }
    $current = Get-Item (Join-Path C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\ $Identity)
    $new = Get-Item (Join-Path ".\" $Identity)
    if ($current.Length -eq $new.Length) {
        return $true
    }
    return $false
}

if (Test-Path C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\) {
    If ((Invoke-CheckFile tablet.jpg) -and (Invoke-CheckFile 2023ThemingTemplateMicrosoftTeamsRoom.jpg)) {
        Write-Output "Teams Room Customizations installed"
        Exit 0
    }
    Else {
        Write-Output "Teams Rooms Customizations missing/not up-to-date"
        Exit 1
    }    
} else {
    Write-Output "Teams Room not installed"
    Exit 0
}