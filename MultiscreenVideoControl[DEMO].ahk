; ============================================================
; Swap Screen Pause
; ============================================================
;
; INPUT LIST
;
; Toggle
;   F6              Enable / Disable Script
;   F7              Enable / Disable Repeat F
;
; Keyboard
;   G               Play / Pause Video
;   F               Repeat F while holding
;   Left Arrow      Seek Backward
;   Right Arrow     Seek Forward
;
; Mouse
;   XButton1        Same as Left Arrow
;   XButton2        Same as Right Arrow
;
; MODE
;   MODE := 1       Multi Monitor
;                   Genshin <-> Chrome are on different screens.
;                   Uses Alt+Tab before and after sending keys.
;
;   MODE := 2       Single Monitor
;                   Genshin and Chrome share one monitor.
;                   Detects the active application automatically.
;
; DEBUG
;   F1              Show active process and window title.
;
; REPEAT F
;   F7              Enable / Disable Repeat F
;   Hold F          Repeatedly send F
;   Release F       Stop repeating
;
; SAFETY
;   Does NOT use BlockInput.
;   SendInput is used to send keyboard input.
;
; ============================================================


#UseHook
#InstallKeybdHook
#SingleInstance Force
#MaxThreadsPerHotkey 1


; ============================================================
; USER SETTINGS
; ============================================================

MODE := 1
; 1 = Multi Monitor
; 2 = Single Monitor


KEY_TOGGLE_STATE := "F6"
KEY_TOGGLE_REPEAT_F := "F7"


TOOLTIP_DURATION := 1500

SWAP_DELAY := 150

COOLDOWN := 500

; Repeat F interval
;
; 100 ms = approximately 10 F presses / second
; 200 ms = approximately 5 F presses / second
; 50 ms  = approximately 20 F presses / second

REPEAT_F_DELAY := 100


; Change this if your Genshin executable has a different name.

GENSHIN_PROCESS := "GenshinImpact.exe"


; ============================================================
; STATE
; ============================================================

state := false

repeatFState := false

lastRun := 0


; ============================================================
; REGISTER HOTKEYS
; ============================================================

Hotkey, %KEY_TOGGLE_STATE%, ToggleState
Hotkey, %KEY_TOGGLE_REPEAT_F%, ToggleRepeatF

return


; ============================================================
; DEBUG
; ============================================================

F1::
WinGet, process, ProcessName, A
WinGetTitle, title, A

MsgBox % "Process: " process
      . "`n`nTitle:`n" title
return


; ============================================================
; MAIN HOTKEYS
; ============================================================

#If (state)


; ------------------------------------------------------------
; G
; ------------------------------------------------------------

g::
    HandleInput("g")
return


; ------------------------------------------------------------
; LEFT
; ------------------------------------------------------------

Left::
XButton1::
    HandleInput("left")
return


; ------------------------------------------------------------
; RIGHT
; ------------------------------------------------------------

Right::
XButton2::
    HandleInput("right")
return


; ============================================================
; REPEAT F
; ============================================================

$F::

    ; --------------------------------------------------------
    ; Repeat F is OFF
    ;
    ; Send F normally once.
    ; --------------------------------------------------------

    if (!repeatFState)
    {
        SendInput, {F}
        return
    }


    ; --------------------------------------------------------
    ; Repeat F is ON
    ;
    ; Keep sending F while physical F is held.
    ; --------------------------------------------------------

    while GetKeyState("F", "P")
    {
        SendInput, {F}

        Sleep, %REPEAT_F_DELAY%
    }

return


#If


; ============================================================
; INPUT HANDLER
; ============================================================

HandleInput(button)
{
    global MODE
    global COOLDOWN
    global lastRun

    ; --------------------------------------------------------
    ; Cooldown
    ; --------------------------------------------------------

    if (A_TickCount - lastRun < COOLDOWN)
        return


    lastRun := A_TickCount


    ; --------------------------------------------------------
    ; Select mode
    ; --------------------------------------------------------

    if (MODE = 1)
        MultiMonitor(button)
    else
        SingleMonitor(button)
}


; ============================================================
; MODE 1
; Multi Monitor
; ============================================================

MultiMonitor(button)
{
    global SWAP_DELAY


    ; --------------------------------------------------------
    ; Switch to the other monitor / application
    ; --------------------------------------------------------

    SendInput, !{Tab}

    Sleep, %SWAP_DELAY%


    ; --------------------------------------------------------
    ; Send the requested button
    ; --------------------------------------------------------

    SendButton(button)


    ; --------------------------------------------------------
    ; Wait before switching back
    ; --------------------------------------------------------

    Sleep, %SWAP_DELAY%


    ; --------------------------------------------------------
    ; Switch back
    ; --------------------------------------------------------

    SendInput, !{Tab}
}


; ============================================================
; MODE 2
; Single Monitor
; ============================================================

SingleMonitor(button)
{
    global GENSHIN_PROCESS


    ; --------------------------------------------------------
    ; Get currently active process
    ; --------------------------------------------------------

    WinGet, process, ProcessName, A


    ; ========================================================
    ; Currently playing Genshin
    ; ========================================================

    if (process = GENSHIN_PROCESS)
    {
        SendInput, !{Tab}

        Sleep, 300

        SendButton(button)
    }


    ; ========================================================
    ; Currently on Chrome
    ; ========================================================

    else if (process = "chrome.exe")
    {

        ; ----------------------------------------------------
        ; G = Play / Pause
        ; ----------------------------------------------------

        if (button = "g")
        {
            SendInput, {Space}

            Sleep, 100

            SendInput, !{Tab}
        }


        ; ----------------------------------------------------
        ; Left
        ; ----------------------------------------------------

        else if (button = "left")
        {
            SendInput, {Left}
        }


        ; ----------------------------------------------------
        ; Right
        ; ----------------------------------------------------

        else if (button = "right")
        {
            SendInput, {Right}
        }
    }
}


; ============================================================
; SHARED BUTTON HANDLER
; ============================================================

SendButton(button)
{
    if (button = "g")
    {
        SendInput, {Space}
    }

    else if (button = "left")
    {
        SendInput, {Left}
    }

    else if (button = "right")
    {
        SendInput, {Right}
    }
}


; ============================================================
; TOGGLE SCRIPT
; ============================================================

ToggleState:

state := !state

Tooltip, % "STATE : " (state ? "ON" : "OFF")

SetTimer, HideTooltip, -%TOOLTIP_DURATION%

return


; ============================================================
; TOGGLE REPEAT F
; ============================================================

ToggleRepeatF:

repeatFState := !repeatFState

Tooltip, % "REPEAT F : " (repeatFState ? "ON" : "OFF")

SetTimer, HideTooltip, -%TOOLTIP_DURATION%

return


; ============================================================
; HIDE TOOLTIP
; ============================================================

HideTooltip:

Tooltip

return