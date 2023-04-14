# Translator

Translator is a static AutoHotkey V2 class based on a [Google Translate API](https://github.com/vitalets/google-translate-api) and uses [TheArkive&#39;s JXON library](https://github.com/TheArkive/JXON_ahk2) for JSON parsing. It consists of a single method and a couple of properties, used as settings.

## Class contents

Properties:

* `SourceLanguage`
* `TargetLanguage`

Methods:

* `Translate`

### Descriptions

`SourceLanguage` - self-explanatory. Defaulted to "auto", used as a parameter for the Translate method.

`TargetLanguage` - self-explanatory. Defaulted to "ru", feel free to fork and change to your liking.

`Translate` - the main method which does the translation. Just provide a text as a parameter, the `SourceLanguage` and `TargetLanguage` properties are optional and by default as the same as the class properties. 

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
