# install.ps1
param (
    [string]$ScriptPath = "$PSScriptRoot\..\src\main.ahk",
    [string]$ShortcutName = "winkeys.lnk"
)

# Resolve paths
$StartupFolder = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $StartupFolder $ShortcutName

# Remove old shortcut if it exists
if (Test-Path $ShortcutPath) {
    Remove-Item $ShortcutPath -Force
}

# Create shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# Path to AutoHotkey executable (edit this if using portable version)
$AhkPath = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"

$Shortcut.TargetPath = $AhkPath
$Shortcut.Arguments = "`"$ScriptPath`""
$Shortcut.WorkingDirectory = Split-Path -Path $ScriptPath
$Shortcut.IconLocation = $AhkPath
$Shortcut.Save()

Write-Host "Startup shortcut created: $ShortcutPath"
