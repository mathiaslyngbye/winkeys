; Switch desktops with Win+1 through Win+9
#1::SwitchToDesktop(0)
#2::SwitchToDesktop(1)
#3::SwitchToDesktop(2)
#4::SwitchToDesktop(3)
#5::SwitchToDesktop(4)
#6::SwitchToDesktop(5)
#7::SwitchToDesktop(6)
#8::SwitchToDesktop(7)
#9::SwitchToDesktop(8)

; Move active window to a desktop with Win+Shift+1..9
#+1::MoveActiveWindowToDesktop(0)
#+2::MoveActiveWindowToDesktop(1)
#+3::MoveActiveWindowToDesktop(2)
#+4::MoveActiveWindowToDesktop(3)
#+5::MoveActiveWindowToDesktop(4)
#+6::MoveActiveWindowToDesktop(5)
#+7::MoveActiveWindowToDesktop(6)
#+8::MoveActiveWindowToDesktop(7)
#+9::MoveActiveWindowToDesktop(8)

; Misc hotkeys
#+c::CloseActiveWindow()
#+q::LogOut()
#m::MaximizeWindow()
#f::RestoreWindow()
#+Enter::LaunchTerminal()
#j::CycleForward()
#p::Send "{LWin}"
