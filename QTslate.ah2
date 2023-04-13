#Include Translator.ah2
#SingleInstance Force

class QTslate extends Translator {

    static TranslationMode := "Simple"

    static SwitchMode() {
        modes := ["From Clipboard", "In Place", "User Input"]
        currentModeIndex := 0
    }

    static Display(translation) {
        g := Gui()
        g.Title := "QTslate"
        g.Opt("ToolWindow")
        g.AddText("vTranslationText w300", translation)
        button := g.AddButton("vCopy Default", "Copy")
        button.OnEvent("Click", CopyTranslation)
        g.OnEvent("Escape", CloseWindow)
        g.Show()

        CopyTranslation(*) {
            A_Clipboard := translation
            g.Destroy()
        }

        CloseWindow(*) {
            g.Destroy()
        }
    }
    
    static InPlace() {
        A_Clipboard := ""
        Send("^c")
        ClipWait(1)
        translation := this.Translate(A_Clipboard)
        ClipSend(translation)
    }

    static UserInput() {
        ib := InputBox("Enter text to translate", "QTslate")
        if ib.Result = "Cancel"
            return
        if ib.Value = ""
            return
        translation := this.Translate(ib.Value)
        this.Display(translation)
    }

    static FromClipboard() {
        translation := this.Translate(A_Clipboard)
        this.Display(translation)
    }

}

text := "The mind can go either direction under stress—toward positive or toward negative: on or off. Think of it as a spectrum whose extremes are unconsciousness at the negative end and hyperconsciousness at the positive end. The way the mind will lean under stress is strongly influenced by training."

#t::QTslate.UserInput()