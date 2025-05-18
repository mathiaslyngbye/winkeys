#Requires AutoHotkey v2.0
#Include vd.ahk
#Include hotkeys.ahk


; Load DLL
if !DllCall("LoadLibrary", "Str", A_ScriptDir "\..\lib\VirtualDesktopAccessor.dll", "Ptr")
    MsgBox "Could not load VirtualDesktopAccessor.dll", "Error", 48

; Initialize globals
global FocusCache := Map()
global CurrentDesktop := GetCurrentDesktop()

; Hotkeys are defined in hotkeys.ahk
