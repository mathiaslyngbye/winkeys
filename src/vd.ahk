GetCurrentDesktop() {
    return DllCall("VirtualDesktopAccessor.dll\GetCurrentDesktopNumber", "Int")
}

EnsureDesktopExists(index) {
    while (DllCall("VirtualDesktopAccessor.dll\GetDesktopCount", "Int") <= index)
        DllCall("VirtualDesktopAccessor.dll\CreateDesktop")
}

IsWindow(hwnd) {
    return hwnd && DllCall("IsWindow", "Ptr", hwnd)
}

GetWindowDesktop(hwnd) {
    return DllCall("VirtualDesktopAccessor.dll\GetWindowDesktopNumber", "Ptr", hwnd, "Int")
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

        ; Verify it's still on the right desktop
        if IsWindow(targetHwnd) && GetWindowDesktop(targetHwnd) == index
            DllCall("SetForegroundWindow", "Ptr", targetHwnd)
        else
            FocusCache.Delete(index) ; clean up invalid entry
    }
}

MoveActiveWindowToDesktop(index) {
    global FocusCache

    EnsureDesktopExists(index)
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if !hwnd
        return

    ; Invalidate any cached entry pointing to this hwnd
    for k, v in FocusCache {
        if v = hwnd
            FocusCache.Delete(k)
    }

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

CycleForward() {
    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if !hwnd
        return

    DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 1, "Int", 0, "Int", 0, "Int", 0, "Int", 0,
        "UInt", 0x0001 | 0x0002 | 0x0010)

    next := hwnd
    loop {
        next := DllCall("GetWindow", "Ptr", next, "UInt", 2)
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
        if (exStyle & 0x80)
            continue

        if DllCall("GetWindow", "Ptr", next, "UInt", 4)
            continue

        DllCall("SetForegroundWindow", "Ptr", next)
        break
    }
}
