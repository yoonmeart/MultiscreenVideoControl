#UseHook
#InstallKeybdHook
#SingleInstance Force
#MaxThreadsPerHotkey 1

KEY_TOGGLE_STATE := "F6"

TOOLTIP_DURATION := 1500
SWAP_DELAY       := 150
COOLDOWN         := 500

state   := false
lastRun := 0

Hotkey, %KEY_TOGGLE_STATE%, ToggleState
return


#If (state)

g::
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    BlockInput, On

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Space}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}

    BlockInput, Off
return


Left::
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    BlockInput, On

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Left}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}

    BlockInput, Off
return


Right::
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    BlockInput, On

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Right}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}

    BlockInput, Off
return

#If


ToggleState:
    state := !state
    Tooltip, % "STATE : " (state ? "ON" : "OFF")
    SetTimer, HideTooltip, -%TOOLTIP_DURATION%
return


HideTooltip:
    Tooltip
return