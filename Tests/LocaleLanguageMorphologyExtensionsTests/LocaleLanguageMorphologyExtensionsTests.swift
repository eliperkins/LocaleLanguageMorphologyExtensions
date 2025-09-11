import Foundation
import LocaleLanguageMorphologyExtensions
import Testing

@Test(arguments: [
  Locale.LanguageCode.english: Set<Morphology.GrammaticalNumber>([.singular, .plural]),
  Locale.LanguageCode.chinese: Set<Morphology.GrammaticalNumber>([.plural]),
  Locale.LanguageCode.french: Set<Morphology.GrammaticalNumber>([.singular, .plural, .pluralMany]),
  Locale.LanguageCode.ukrainian: Set<Morphology.GrammaticalNumber>([
    .singular, .plural, .pluralFew, .pluralMany,
  ]),
])
func languageCodeSmokeTest(
  languageCode: Locale.LanguageCode, expectedPlurals: Set<Morphology.GrammaticalNumber>
) async throws {
  #expect(
    languageCode.supportedGrammaticalNumberPlurals == expectedPlurals,
    """
    Failed for \(languageCode.identifier):
    expected \(expectedPlurals), got \(languageCode.supportedGrammaticalNumberPlurals)
    """
  )
}

@Test(arguments: [
  Locale.Language(identifier: "en-US"): Set<Morphology.GrammaticalNumber>([.singular, .plural]),
  Locale.Language(identifier: "zh-CN"): Set<Morphology.GrammaticalNumber>([.plural]),
  Locale.Language(identifier: "fr-FR"): Set<Morphology.GrammaticalNumber>([
    .singular, .plural, .pluralMany,
  ]),
  Locale.Language(identifier: "uk-UA"): Set<Morphology.GrammaticalNumber>([
    .singular, .plural, .pluralFew, .pluralMany,
  ]),
])
func languageSmokeTest(
  language: Locale.Language, expectedPlurals: Set<Morphology.GrammaticalNumber>
) async throws {
  #expect(
    language.supportedGrammaticalNumberPlurals == expectedPlurals,
    """
    Failed for \(language.minimalIdentifier):
    expected \(expectedPlurals), got \(language.supportedGrammaticalNumberPlurals)
    """
  )
}
