#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; AutoHotkey v1 Script - Numpad Plus to toggle mute focused app
; Requires SoundVolumeView.exe in the same folder

; Track mute state for each process
mutedApps := {}

; Numpad Plus: Toggle mute for focused app
NumpadAdd::
    ; Get the currently active window info
    WinGet, activeWindow, ID, A
    WinGet, processName, ProcessName, ahk_id %activeWindow%
    
    ; Check if this app is currently muted (tracked in our object)
    if (mutedApps[processName]) {
        ; App is muted, so unmute it
        RunWait, %A_ScriptDir%\SoundVolumeView.exe /Unmute "%processName%", , Hide
        mutedApps[processName] := false
        ToolTip, Unmuted: %processName%, 10, 10, 1
    } else {
        ; App is not muted, so mute it
        RunWait, %A_ScriptDir%\SoundVolumeView.exe /Mute "%processName%", , Hide
        mutedApps[processName] := true
        ToolTip, Muted: %processName%, 10, 10, 1
    }
    
    ; Remove tooltip after 1.5 seconds
    SetTimer, RemoveToolTip, 1500
return

; Optional: Reset all tracked mute states (Ctrl+Numpad Plus)
^NumpadAdd::
    mutedApps := {}
    ToolTip, Cleared all mute states, 10, 10, 1
    SetTimer, RemoveToolTip, 1500
return

; Optional: Show current app mute status (Shift+Numpad Plus)
+NumpadAdd::
    WinGet, activeWindow, ID, A
    WinGet, processName, ProcessName, ahk_id %activeWindow%
    
    if (mutedApps[processName]) {
        status := "MUTED"
    } else {
        status := "NOT MUTED"
    }
    
    ToolTip, %processName%: %status%, 10, 10, 1
    SetTimer, RemoveToolTip, 2000
return

RemoveToolTip:
    ToolTip
return
