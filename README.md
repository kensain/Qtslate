# Introduction

I have been looking for a way to accelerate my workflow and somehow automate the translation process - opening a translator in browser is kinda slow. I was looking for some API options but large companies like Google and Yandex don't provide free APIs. I was lucky to stumble upon a free [Google Translate API](https://github.com/vitalets/google-translate-api) which I first converted to an AHK function. The biggest problem was to parse the translation result - as it returned a JSON string without any names, just arrays within arrays. I was trying to do it without external libraries, but it was too difficult so I managed to achieve the result using [TheArkive&#39;s JXON library](https://github.com/TheArkive/JXON_ahk2). I wrapped the function in a **Translator** class, because I already had in mind the need for future translation shortcuts and different translation modes. Then I wrote the **Qtslate** class to implement all the things I needed for the translation script. Below you will find more information on the classes.

# Translator

Translator is a static AutoHotkey V2 class based on a [Google Translate API](https://github.com/vitalets/google-translate-api) and uses [TheArkive&#39;s JXON library](https://github.com/TheArkive/JXON_ahk2) for JSON parsing and a [Clipsend function by Axlefublr](https://github.com/Axlefublr/lib-v2/blob/main/Utils/ClipSend.ahk). It consists of a single method and a couple of properties, used as settings.

## Class contents

Properties:

* `SourceLanguage`
* `TargetLanguage`

Methods:

* `Translate`

### Descriptions

`SourceLanguage` - self-explanatory. Defaulted to "auto", used as a parameter for the Translate method.

`TargetLanguage` - self-explanatory. Defaulted to "ru", feel free to fork and change to your liking.

`Translate(Text, TargetLanguage := this.TargetLanguage, SourceLanguage := this.SourceLanguage)` - the main method which does the translation. Just provide a text as a parameter, the `SourceLanguage` and `TargetLanguage` properties are optional and by default as the same as the class properties.

The basic working principle is the following:

1. Send a request to server
2. Parse the response JSON
3. Return translation

## Examples

Below you will find a couple of examples of possible use.

Basic translation using languages from the class properties (defaults are "ru" and "auto"):

```
translation := Translator.Translate(text)
MsgBox(translation)
```

Let's change the target language:

```
translation := Translator.Translate(text, "de")
MsgBox(translation)
```

Now let's try to change also the source:

```
translation := Translator.Translate(text, "de", "es")
MsgBox(translation)
```

# Qtslate

Qtslate is an extension class for the Translator which implements a few methods for a seamless integration of the Translator in your workflow. Using switch between multiple translation modes and change both source and target languages.

## Class contents

Properties:

* `TranslationMode`
* `CurrentModeIndex`
* `Languages`
* `SourceLanguageIndex`
* `TargetLanguageIndex`

Methods:

* `SwitchMode`
* `CycleTargetLanguage`
* `CycleSourceLanguage`
* `Activate`
* `ShowCurrentSettings`
* `Display`
* `InPlace`
* `UserInput`
* `FromClipboard`

### Descriptions

`TranslationMode` - internal array for switching between the translation modes (see corresponding methods).

`CurrentModeIndex` - index used to switch the translation mode.

`Languages` - internal array of language codes.

`SourceLanguageIndex` - index used to choose the source language of the text. Default is 1 ("auto").

`TargetLanguageIndex` - index used to choose the target language of the text. Default is 3 ("ru").

`SwitchMode(backwards := false)` - Method for switching Qtslate between translations methods - 'From Clipboard', 'In place' and 'User Input'.

`CycleTargetLanguage(backwards := false)` - Method for cycling target languages. Based on a counter to cycle through the array of languages. Skips the index #1 which is 'auto' because you must  specify the target language.

`CycleSourceLanguage(backwards := false)` - Method for cycling languages. Based on a counter to cycle through the array of languages.

`Activate()` - Call a translation method based on the current translation mode.

`ShowCurrentSettings()` - Method to display currently active translation mode and languages.

`Display(translation)` - Method used by other translation modes for displaying the translated text in a new window. The `Copy` button can be used to copy the translation result. Otherwise,  `Escape` button can be pressed to close the GUI.

`InPlace()` - Translation mode used to translate text within a text editor. For example, in MS Word you can select a word or a whole paragraph and call this method. The selection will be copied, translated and pasted in place.

`UserInput()` - Translation mode used to show an input box. The entered text will then be translated and displayed in a new window via Display method.

`FromClipboard()` - Translation mode used to translate text from the clipboard. The translation will then be displayed in a new window via Display method.

## Examples

As an example I have written a Qtslagent.ah2 which is basically the ready-to-go script. The shortcuts are following:

My default settings:

`#x::ExitApp` - Press `Win+X` to terminate script.

`^!r::Reload` - Press `Ctrl+Alt+R` to reload the script.

Translation forkflow:

`#t::QTslate.Activate()` - Press `Win+T` to translate text based on the default or chosen mode/languages.

`#MButton::QTslate.ShowCurrentSettings()` - Press `Win+Mousewheel` to display the currently selected mode and languages in a ToolTip.

`#+t::QTslate.SwitchMode()` - Press `Win+Shift+T` to switch between translation modes.

`#+WheelUp::QTslate.CycleSourceLanguage(true)` - Use `Win+Shift+Mouse wheel up` to cycle through source languages backwards.

`#+WheelDown::QTslate.CycleSourceLanguage()` - Use `Win+Shift+Mouse wheel down` to cycle through source languages forward.

`#WheelUp::QTslate.CycleTargetLanguage(true)` - Use `Win+Mouse wheel up` to cycle through source languages backwards.

`#WheelDown::QTslate.CycleTargetLanguage()` - Use `Win+Mouse wheel down` to cycle through source languages.
