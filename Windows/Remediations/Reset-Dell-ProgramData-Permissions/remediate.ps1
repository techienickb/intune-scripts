$path = Join-Path $env:ProgramData "Dell"

TAKEOWN /R /F $path

ICACLS $path /T /Q /C /RESET

Restart-Service -Name "DCECMISvc" -Force -ErrorAction SilentlyContinue