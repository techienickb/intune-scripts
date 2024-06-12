$path = Resolve-Path "$env:AppData\Zoom\Bin\Zoom.exe" -ErrorAction SilentlyContinue

if ($null -ne $path) {
    Write-Error "Zoom User Context Detected"
    Exit 1
} else {
    Write-Host "No zoom user context"
    Exit 0
}