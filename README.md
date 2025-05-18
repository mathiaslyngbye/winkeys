# windows-hotkeys
A novel attempt to implement dwm-style navigation in windows, utilizing AutoHotkey and VirtualDesktopAccessor.

## Supported commands

```
[Win]+[workspace number] - focus on another workspace
[Win]+[m] - maximize current window
[Win]+[f] - float current window
[Win]+[p] - windows menu for running programs
[Win]+[Shift]+[c] - kill current window
[Win]+[Shift]+[q] - logout cleanly
[Win]+[Shift]+[Enter] - launch terminal
```

## Unsupported commands
```
[Win]+[j] - cycle forwards through windows in z-order
[Win]+[k] - cycle backwards through windows in z-order
```

## Dependencies

This project depends on [VirtualDesktopAccessor.dll](https://github.com/Ciantic/VirtualDesktopAccessor), 
a third-party library for controlling Windows virtual desktops.

That project is:
- Open source (MIT License)
- Developed and maintained by [Ciantic](https://github.com/Ciantic)
