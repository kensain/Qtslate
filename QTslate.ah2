#Include Translator.ah2
#SingleInstance Force

class Qtslate extends Translator {

    static TranslationMode := ["From Clipboard", "In Place", "User Input"]
    static CurrentModeIndex := 1

    static Languages := ["auto", "en", "ru", "de"]
    static SourceLanguageIndex := 1
    static TargetLanguageIndex := 3

    static SwitchMode() {
        if this.CurrentModeIndex = this.TranslationMode.Length
            this.CurrentModeIndex := 1
        else
            this.CurrentModeIndex++
        Info("'" this.TranslationMode[this.CurrentModeIndex] "' mode is activated.")
    }

    static SwitchTargetLanguage(backwards := false) {
        if backwards = true {
            if this.TargetLanguageIndex = 2
                this.TargetLanguageIndex := this.Languages.Length
            else
                this.TargetLanguageIndex--
        }
        else {
            if this.TargetLanguageIndex = this.Languages.Length
                this.TargetLanguageIndex := 2
            else
                this.TargetLanguageIndex++
        }
        Info("Target language = " StrUpper(this.Languages[this.TargetLanguageIndex]))
    }

    static SwitchSourceLanguage(backwards := false) {
        if backwards = true {
            if this.SourceLanguageIndex = 1
                this.SourceLanguageIndex := this.Languages.Length
            else
                this.SourceLanguageIndex--
        }
        else {
            if this.SourceLanguageIndex = this.Languages.Length
                this.SourceLanguageIndex := 1
            else
                this.SourceLanguageIndex++
        }
        Info("Source language = " StrUpper(this.Languages[this.SourceLanguageIndex]))
    }

    /**
     * Call a translation method based on the current translation mode.
     */
    static Activate() {
        switch this.CurrentModeIndex {
            case 1:
                this.FromClipboard()
            case 2:
                this.InPlace()
            case 3:
                this.UserInput()
            default:
                this.FromClipboard()
        }
    }

    /**
     * Method to display currently active translation mode and languages.
     */
    static ShowCurrentSettings() {
        Settings := "Mode: " this.TranslationMode[this.CurrentModeIndex]
        . "`nSource: " this.Languages[this.SourceLanguageIndex]
        . "`nTarget: " this.Languages[this.TargetLanguageIndex]
        Info(Settings)
    }

    /**
     * Method used by other translation modes for displaying the translated text in a new window. The 'Copy' button can be used to copy the translation result. Otherwise, `Escape` can be pressed to close the GUI.
     */
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
    
    /**
     * Used to translate text within a text editor. For example, in MS Word you can select a word or a whole paragraph and call this method. The selection will be copied, translated and pasted in place.
     */
    static InPlace() {
        A_Clipboard := ""
        Send("^c")
        ClipWait(1)
        translation := this.Translate(A_Clipboard, this.Languages[this.TargetLanguageIndex], this.Languages[this.SourceLanguageIndex])
        ClipSend(translation)
    }

    /**
     * Method to show an input box. The entered text will then be translated and displayed in a new window via Display method.
     */
    static UserInput() {
        ib := InputBox("Enter text to translate", "QTslate")
        if ib.Result = "Cancel"
            return
        if ib.Value = ""
            return
        translation := this.Translate(ib.Value, this.Languages[this.TargetLanguageIndex], this.Languages[this.SourceLanguageIndex])
        this.Display(translation)
    }

    /**
     * Method to translate text from the clipboard. The translation will the be displayed in a new window via Display method.
     */
    static FromClipboard() {
        translation := this.Translate(A_Clipboard, this.Languages[this.TargetLanguageIndex], this.Languages[this.SourceLanguageIndex])
        this.Display(translation)
    }

}

text := "The mind can go either direction under stress—toward positive or toward negative: on or off. Think of it as a spectrum whose extremes are unconsciousness at the negative end and hyperconsciousness at the positive end. The way the mind will lean under stress is strongly influenced by training."

; #t::QTslate.UserInput()