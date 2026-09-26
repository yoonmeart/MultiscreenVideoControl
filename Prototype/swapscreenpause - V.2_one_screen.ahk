;Version2
#SingleInstance Force

F1::
    WinGet, process, ProcessName, A
    WinGetTitle, title, A

    MsgBox % "Process: " process
          . "`n`nTitle:`n" title
return


g::
    SwapScreen("g")
return

Left::
XButton1::
    SwapScreen("left")
return

Right::
XButton2::
    SwapScreen("right")
return


SwapScreen(button)
{
    global COOLDOWN, lastRun

    if (A_TickCount - lastRun < COOLDOWN)
        return

    lastRun := A_TickCount

    WinGet, process, ProcessName, A

    BlockInput, On

    ; =========================
    ; Chrome
    ; =========================
    if (process = "chrome.exe")
    {
        if (button = "g")
             {
            SendInput, {Space}
            Sleep, 100
            SendInput, !{Tab}
             }
        else if (button = "left")
            SendInput, {Left}
        else if (button = "right")
            SendInput, {Right}

    }

    ; =========================
    ; Genshin
    ; Replace this process name after pressing F1.
    ; =========================
    else if (process = "GenshinImpact.exe")
    {
        SendInput, !{Tab}
        Sleep, 300

        if (button = "g")
            SendInput, {Space}
        else if (button = "left")
            SendInput, {Left}
        else if (button = "right")
            SendInput, {Right}
    }

    BlockInput, Off
}