# LocaleLanguageMorphologyExtensions

- Ever wondered which languages support different pluralizations? Me too!
- Trying to figure out why some languages in your `xcstrings` file create certain pluralizations, but others don't. _Me too!_
- Trying to codegen an `xcstrings` file and need to know what languages should have different pluralizations? **_Me too!_**

(Wow, we must be so alike.)

Turns out the Unicode CLDR (Common Locale Data Repository) provides this information for us! While consuming the entirety of the CLDR data isn't super practical, generating some code that makes accesses to the pluralization data seems entirely feasible to do.

The [`Morphology` type within Foundation](https://developer.apple.com/documentation/foundation/morphology) contains a helpful type in [`Morphology.GrammaticalNumber`](https://developer.apple.com/documentation/foundation/morphology/grammaticalnumber), but this type doesn't do much beyond runtime string inflection.

This project aims to provide a Swift package for accessing the pluralization data from the Unicode CLDR in constant time, with the Foundation types you might already be familiar with.

## Usage

```swift
import Foundation
import LocaleLanguageMorphologyExtensions

let myLocaleLanguageCode = Locale.LanguageCode.english
print(myLocaleLanguageCode.supportedGrammaticalNumberPlurals)
// ⮑ Set<Morphology.GrammaticalNumber>([.singular, .plural])

let myLocaleLanguage = Locale.Language(identifier: "uk-UA")
print(myLocaleLanguage.supportedGrammaticalNumberPlurals)
// ⮑ Set<Morphology.GrammaticalNumber>([.singular, .plural, .pluralFew, .pluralMany])
```

## Credits / Further Reading

- [Unicode CLDR](https://cldr.unicode.org/)
- [Lickability: "Morphology in Swift" by Michael Liberatore](https://lickability.com/blog/morphology-in-swift/)
- [Lingohub: "Pluralization (p11n) - the many of plurals"](https://lingohub.com/blog/pluralization)
