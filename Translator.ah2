#Include <Info>                     ; https://github.com/Axlefublr/lib-v2/blob/main/Tools/Info.ahk
#Include <JXON_ahk2\_JXON>          ; https://github.com/TheArkive/JXON_ahk2
#Include <lib-v2\Utils\ClipSend>    ; https://github.com/Axlefublr/lib-v2/blob/main/Utils/ClipSend.ahk

#SingleInstance Force
class Translator {

    static SourceLanguage := "auto"
    static TargetLanguage := "ru"
    static TranslationText := ""

    static SwitchSource(LanguageCode) {
        this.SourceLanguage := LanguageCode
        Info("Source language is set to " LanguageCode, 2000)
    }

    static SwitchTarget(LanguageCode) {
        this.TargetLanguage := LanguageCode
        Info("Target language is set to " LanguageCode, 2000)
    }

    static Translate(Text) {
        url := "https://translate.google.com/translate_a/single"
    
        _headers := Map(
            "User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
            "Referer", "https://translate.google.com/",
            "Accept", "application/json"
        )
        _params := Map(
            "client", "gtx",
            "sl", this.SourceLanguage,
            "tl", this.TargetLanguage,
            "dt", "t",
            "q", Text
        )

        headers := ""
        params := ""
        for key, value in _headers
            headers .= key "=" value "&"
        for key, value in _params {
            if A_Index != _params.Count
                params .= key "=" value "&"
            else
                params .= key "=" value
        }
        response := ComObject("WinHttp.WinHttpRequest.5.1")
        response.Open("GET", url . "?" . headers . params, false)
        response.Send()
        if response.Status = 200 {
            Translation := response.ResponseText
            TranslationObject := Jxon_Load(&Translation)
            data := Jxon_Dump(TranslationObject)

            output := ""
            for k, v in TranslationObject[1]
                output .= TranslationObject[1][k][1]
            this.TranslationText := output
            return output
        } else 
            MsgBox("Request failed with status code " response.Status)
    }

    static CopyBox(Text) {
        translation := this.Translate(Text)
        g := Gui()
        g.Opt("ToolWindow")
        g.AddEdit("ReadOnly vTranslationText w300", translation)
        button := g.AddButton("vCopy Default", "Copy")
        button.OnEvent("Click", CopyTranslation)
        g.OnEvent("Escape", CloseWindow)
        g.Show()

        CopyTranslation(*) {
            A_Clipboard := g.Submit().TranslationText
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

    static Simple() {
        MsgBox(this.Translate(A_Clipboard), "Translation")
    }
}

#1::Translator.SwitchTarget("de")
#2::Translator.SwitchTarget("it")
#3::Translator.SwitchTarget("ru")
text := "The mind can go either direction under stress—toward positive or toward negative: on or off. Think of it as a spectrum whose extremes are unconsciousness at the negative end and hyperconsciousness at the positive end. The way the mind will lean under stress is strongly influenced by training."
; translated_text := 
; #t::MsgBox(Translator.Translate(text))
#y::Translator.Simple()
#r::Translator.InPlace
; #t::clipsave()


; #############################
; #############################
; #############################
; BACKUP FUNCTION BELOW:
; #############################
; #############################
; #############################
; translate(Text, SourceLanguage:="auto", TargetLanguage:="en") {
;     url := "https://translate.google.com/translate_a/single"
    
;     _headers := Map(
;         "User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
;         "Referer", "https://translate.google.com/",
;         "Accept", "application/json"
;     )
;     _params := Map(
;         "client", "gtx",
;         "sl", SourceLanguage,
;         "tl", TargetLanguage,
;         "dt", "t",
;         "q", Text
;     )

;     headers := ""
;     params := ""
;     for key, value in _headers
;         headers .= key "=" value "&"
;     for key, value in _params {
;         if A_Index != _params.Count
;             params .= key "=" value "&"
;         else
;             params .= key "=" value
;     }
;     response := ComObject("WinHttp.WinHttpRequest.5.1")
;     response.Open("GET", url . "?" . headers . params, false)
;     response.Send()
;     if response.Status = 200 {
;         Translation := response.ResponseText
;         TranslationObject := Jxon_Load(&Translation)
;         data := Jxon_Dump(TranslationObject)

;         output := ""
;         for k, v in TranslationObject[1]
;             output .= TranslationObject[1][k][1]
;         return output
;     } else 
;         MsgBox("Request failed with status code " response.Status)
; }

; Example usage
; text := "The mind can go either direction under stress—toward positive or toward negative: on or off. Think of it as a spectrum whose extremes are unconsciousness at the negative end and hyperconsciousness at the positive end. The way the mind will lean under stress is strongly influenced by training."
; translated_text := translate(text, "en", "ru")
; MsgBox(translated_text)