#Include Translator.ahk
#Include <AHKv2_Scripts\ClipSend> ; https://github.com/Axlefublr/lib-v2/blob/03f0bd71ec1e73753f33631b25e17d1fd81889e8/Utils/ClipSend.ahk

class Qtslate extends Translator {

    static TranslationMode := ["From Clipboard", "In Place", "User Input"]
    static CurrentModeIndex := 1

    static Languages := ["auto", "en", "ru", "de"]
    static SourceLanguageIndex := 1
    static TargetLanguageIndex := 3

    /**
     * Method for switching Qtslate between translations methods - 'From Clipboard', 'In place' and 'User Input'.
     * @param {number} backwards Used when you need to cycle backwards, for example with mouse. Purely optional, as there is only 3 methods available as of 04.2023.
     */
    static SwitchMode(backwards := false) {
        if backwards = true {
            if this.SourceLanguageIndex = 1
                this.SourceLanguageIndex := this.Languages.Length
            else
                this.SourceLanguageIndex--
        }
        else {
            if this.CurrentModeIndex = this.TranslationMode.Length
                this.CurrentModeIndex := 1
            else
                this.CurrentModeIndex++
        }
        ToolTip("'" this.TranslationMode[this.CurrentModeIndex] "' mode is activated.")
        SetTimer () => ToolTip(), -2000
    }

    /**
     * Method for cycling target languages. Based on a counter to cycle through the array of languages. Skips the index #1 which is 'auto' because you must  specify the target language.
     * @param {Boolean} backwards Used when you need to cycle backwards, for example with mouse.
     */
    static CycleTargetLanguage(backwards := false) {
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
        ToolTip("Target language = " StrUpper(this.Languages[this.TargetLanguageIndex]))
        SetTimer () => ToolTip(), -1500
    }

    /**
     * Method for cycling languages. Based on a counter to cycle through the array of languages.
     * @param {Boolean} backwards Used when you need to cycle backwards, for example with mouse.
     */
    static CycleSourceLanguage(backwards := false) {
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
        ToolTip("Source language = " StrUpper(this.Languages[this.SourceLanguageIndex]))
        SetTimer () => ToolTip(), -1500
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
        ToolTip(Settings)
        SetTimer () => ToolTip(), -1500
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

    /**
     * GUI for selecting mode, source and target languages.
     */
    static Controls(*) {
        
        controls := Gui()
        controls.Opt("AlwaysOnTop ToolWindow")
        controls.Title := "QTslate"
        controls.AddText(, "Mode")
        controls.AddListBox("vMode r4 Choose2 AltSubmit", this.TranslationMode)
        controls.AddText("ym", "Source language")
        controls.AddListBox("r4 vSource Choose2 AltSubmit", this.Languages)
        Selector := controls.AddButton("vSelect Default w120", "Select")
        Selector.OnEvent("Click", Update)
        controls.AddText("ym", "Target language")
        controls.AddListBox("r4 vTarget Choose3 AltSubmit", this.Languages)
        controls.OnEvent("Escape", (*) => close_gui())
        controls.OnEvent("Close", (*) => close_gui())
        controls.Show()

        Update(*) {
            this.CurrentModeIndex := controls.Submit().Mode
            this.SourceLanguageIndex := controls.Submit().Source
            this.TargetLanguageIndex := controls.Submit().Target
        }

        close_gui() {
            controls.Destroy()
            Exit()
        }

    }
}