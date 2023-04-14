#SingleInstance Force
installKeybdHook
Persistent
#x::ExitApp ; Win+X to terminate script
^!r::Reload ; Ctrl+Alt+R to reload the script

#Include QTslate.ah2

#t::QTslate.Activate()
#MButton::QTslate.ShowCurrentSettings()
#+t::QTslate.SwitchMode()
#+WheelUp::QTslate.CycleSourceLanguage(true)
#+WheelDown::QTslate.CycleSourceLanguage()
#WheelUp::QTslate.CycleTargetLanguage(true)
#WheelDown::QTslate.CycleTargetLanguage()