#Include <Info>
#SingleInstance Force
installKeybdHook
Persistent
#x::ExitApp ; Win+X to terminate script
^!r::Reload ; Ctrl+Alt+R to reload the script

modes := ["Mode 01", "Mode 02", "Mode 03"]
currentModeIndex := 1

F11::SwitchMode()
F12::translate()

SwitchMode() {
    global currentModeIndex
    if currentModeIndex = modes.Length
        currentModeIndex := 1
    else
        currentModeIndex++
    Info(modes[currentModeIndex] " is selected.")
}

translate() {
    currentMode := modes[currentModeIndex]
    Switch currentMode
    {
        Case "Mode 01":
            Function1()
        Case "Mode 02":
            Function2()
        Case "Mode 03":
            Function3()
        Default:
            MsgBox("DEFAULT")
    }
}

Function1() {
    MsgBox(A_ThisFunc)
}
Function2() {
    MsgBox(A_ThisFunc)
}
Function3() {
    MsgBox(A_ThisFunc)
}