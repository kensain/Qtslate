#Include <JXON_ahk2\_JXON>          ; https://github.com/TheArkive/JXON_ahk2

class Translator {

    static SourceLanguage := "auto"
    static TargetLanguage := "ru"

    /**
     * Translates text.
     * @param {string} Text The source text for translation.
     * @param {string} TargetLanguage The code for a language you would like to translate to. For example: "de", "en", "es", "it" and so on.
     * @param {string} SourceLanguage The code for a language you would like to translate from. Defaulted to "auto" (see SourceLanguage property). For example: "de", "en", "es", "it" and so on.
     * @returns {string} Output translation text.
     */
    static Translate(Text, TargetLanguage := this.TargetLanguage, SourceLanguage := this.SourceLanguage) {
        url := "https://translate.google.com/translate_a/single"
    
        _headers := Map(
            "User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
            "Referer", "https://translate.google.com/",
            "Accept", "application/json"
        )
        _params := Map(
            "client", "gtx",
            "sl", SourceLanguage,
            "tl", TargetLanguage,
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
            return output
        } else 
            MsgBox("Request failed with status code " response.Status)
    }

}

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