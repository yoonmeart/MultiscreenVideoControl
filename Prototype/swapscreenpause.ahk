#UseHook
#InstallKeybdHook
#SingleInstance Force

KEY_TOGGLE_STATE := "F6"

TOOLTIP_DURATION := 1500
SWAP_DELAY       := 150
COOLDOWN         := 500

state   := false
lastRun := 0

Hotkey, %KEY_TOGGLE_STATE%, ToggleState
return


#If (state)

; =========================
; G ACTION
; =========================
g::
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Space}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}
return


; =========================
; LEFT (Keyboard)
; =========================
Left::
    Gosub, DoLeftLike
return

; =========================
; RIGHT (Keyboard)
; =========================
Right::
    Gosub, DoRightLike
return

; =========================
; MOUSE BACK (XButton1)
; =========================
XButton1::
    Gosub, DoLeftLike
return

; =========================
; MOUSE FORWARD (XButton2)
; =========================
XButton2::
    Gosub, DoRightLike
return


; =========================
; SHARED LOGIC
; =========================
DoLeftLike:
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Left}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}
return


DoRightLike:
    if (A_TickCount - lastRun < COOLDOWN)
        return
    lastRun := A_TickCount

    SendInput, !{Tab}
    Sleep, %SWAP_DELAY%
    SendInput, {Right}
    Sleep, %SWAP_DELAY%
    SendInput, !{Tab}
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