$blob = "some url / blob"
$wallpaper = "2023ThemingTemplateMicrosoftTeamsRoom.jpg"
$localstate = "C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\"
if (Test-Path C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\) {
    Invoke-WebRequest -Uri "$blob/$wallpaper" -OutFile (Join-Path $localstate $wallpaper) -UseBasicParsing
    Invoke-WebRequest -Uri "$blob/tablet.jpg" -OutFile (Join-Path $localstate "tablet.jpg") -UseBasicParsing
    Invoke-WebRequest -Uri "$blob/SkypeSettings.xml" -OutFile (Join-Path $localstate "SkypeSettings.xml") -UseBasicParsing
} else {
    Write-Error "Teams Room not installed"
}