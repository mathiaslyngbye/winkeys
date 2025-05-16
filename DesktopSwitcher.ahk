#Requires AutoHotkey v2.0

; --- Load VirtualDesktopAccessor DLL ---
if !DllCall("LoadLibrary", "Str", "VirtualDesktopAccessor.dll", "Ptr")
    MsgBox "Could not load VirtualDesktopAccessor.dll", "Error", 48

; --- Globals ---
global FocusCache := Map()
global CurrentDesktop := DllCall("VirtualDesktopAccessor.dll\GetCurrentDesktopNumber", "Int")

; --- Helper Functions ---

EnsureDesktopExists(index) {
    while (DllCall("VirtualDesktopAccessor.dll\GetDesktopCount", "Int") <= index)
        DllCall("VirtualDesktopAccessor.dll\CreateDesktop")
}

IsWindow(hwnd) {
    return hwnd && DllCall("IsWindow", "Ptr", hwnd)
}

SwitchToDesktop(index) {
    global FocusCache, CurrentDesktop

    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if hwnd
        FocusCache[CurrentDesktop] := hwnd

    EnsureDesktopExists(index)
    DllCall("VirtualDesktopAccessor.dll\GoToDesktopNumber", "Int", index)
    CurrentDesktop := index

    if FocusCache.Has(index) {
        targetHwnd := FocusCache[index]
        if IsWindow(targetHwnd)
            DllCall("SetForegroundWindow", "Ptr", targetHwnd)
    }
}

MoveActiveWindowToDesktop(index) {
    EnsureDesktopExists(index)
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if hwnd
        DllCall("VirtualDesktopAccessor.dll\MoveWindowToDesktopNumber", "Ptr", hwnd, "Int", index)
}

CloseActiveWindow() {
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if hwnd
        PostMessage(0x0010, 0, 0, hwnd)
}

LogOut() {
    DllCall("User32.dll\ExitWindowsEx", "UInt", 0, "UInt", 0)
}

MaximizeWindow() {
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if hwnd
        DllCall("ShowWindow", "Ptr", hwnd, "Int", 3)
}

RestoreWindow() {
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if hwnd
        DllCall("ShowWindow", "Ptr", hwnd, "Int", 9)
}

LaunchTerminal() {
    Run "wt.exe"
}

GetWindowDesktopGuid(hwnd) {
    buf := Buffer(16, 0)
    success := DllCall("VirtualDesktopAccessor.dll\GetWindowDesktopId", "Ptr", hwnd, "Ptr", buf)
    return success ? buf : 0
}

memcmp(buf1, buf2, len) {
    Loop len {
        if NumGet(buf1, A_Index - 1, "UChar") != NumGet(buf2, A_Index - 1, "UChar")
            return false
    }
    return true
}

CycleForward() {
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if !hwnd
        return

    ; Move current window to bottom
    DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0,
        "UInt", 0x0001 | 0x0002 | 0x0010)

    next := hwnd
    loop {
        next := DllCall("GetWindow", "Ptr", next, "UInt", 2) ; GW_HWNDNEXT
        if !next
            next := DllCall("GetTopWindow", "Ptr", 0)

        if next = hwnd
            break

        if !DllCall("IsWindowVisible", "Ptr", next)
            continue

        cloaked := 0
        DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", next, "UInt", 14, "Int*", &cloaked, "UInt", 4)
        if cloaked
            continue

        exStyle := DllCall("GetWindowLongPtrW", "Ptr", next, "Int", -20, "Ptr")
        if (exStyle & 0x80)  ; WS_EX_TOOLWINDOW
            continue

        if DllCall("GetWindow", "Ptr", next, "UInt", 4)  ; GW_OWNER
            continue

        DllCall("SetForegroundWindow", "Ptr", next)
        break
    }
}

; --- Win+1 to Win+9: Switch desktops ---
#1::SwitchToDesktop(0)
#2::SwitchToDesktop(1)
#3::SwitchToDesktop(2)
#4::SwitchToDesktop(3)
#5::SwitchToDesktop(4)
#6::SwitchToDesktop(5)
#7::SwitchToDesktop(6)
#8::SwitchToDesktop(7)
#9::SwitchToDesktop(8)

; --- Win+Shift+1 to Win+Shift+9: Move active window ---
#+1::MoveActiveWindowToDesktop(0)
#+2::MoveActiveWindowToDesktop(1)
#+3::MoveActiveWindowToDesktop(2)
#+4::MoveActiveWindowToDesktop(3)
#+5::MoveActiveWindowToDesktop(4)
#+6::MoveActiveWindowToDesktop(5)
#+7::MoveActiveWindowToDesktop(6)
#+8::MoveActiveWindowToDesktop(7)
#+9::MoveActiveWindowToDesktop(8)

; --- Misc hotkeys ---
#+c::CloseActiveWindow()
#+q::LogOut()
#m::MaximizeWindow()
#f::RestoreWindow()
#+Enter::LaunchTerminal()
#p::Send "{LWin}"

; --- Win+J: Cycle forward ---
#j::CycleForward()
