$dest = "../lib/VirtualDesktopAccessor.dll"
if (-Not (Test-Path $dest)) {
    Write-Host "Downloading VirtualDesktopAccessor.dll..."
    Invoke-WebRequest `
        -Uri "https://github.com/Ciantic/VirtualDesktopAccessor/releases/latest/download/VirtualDesktopAccessor.dll" `
        -OutFile $dest
}
