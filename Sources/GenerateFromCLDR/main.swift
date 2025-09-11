import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

enum GenerationError: Error {
  case invalidData
}

extension Locale.LanguageCode: @retroactive CodingKeyRepresentable {
  public init?<T>(codingKey: T) where T: CodingKey {
    self.init(codingKey.stringValue)
  }

  public var codingKey: CodingKey {
    identifier.codingKey
  }
}

struct CLDRPluralMap: Codable, Sendable {
  let supplemental: Supplemental

  struct Supplemental: Codable, Sendable {
    let version: Version

    let cardinal: [Locale.LanguageCode: [Pluralization: String]]

    struct Version: Codable, Sendable {
      let unicodeVersion: String
      let cldrVersion: String

      enum CodingKeys: String, CodingKey {
        case unicodeVersion = "_unicodeVersion"
        case cldrVersion = "_cldrVersion"
      }
    }

    public enum Pluralization: String, Codable, Sendable, CodingKeyRepresentable {
      case zero = "pluralRule-count-zero"
      case one = "pluralRule-count-one"
      case two = "pluralRule-count-two"
      case few = "pluralRule-count-few"
      case many = "pluralRule-count-many"
      case other = "pluralRule-count-other"

      var grammaticalNumber: Morphology.GrammaticalNumber {
        switch self {
        case .zero: return .zero
        case .one: return .singular
        case .two: return .pluralTwo
        case .few: return .pluralFew
        case .many: return .pluralMany
        case .other: return .plural
        }
      }

      var grammaticalNumberAsString: String {
        switch self {
        case .zero: return ".zero"
        case .one: return ".singular"
        case .two: return ".pluralTwo"
        case .few: return ".pluralFew"
        case .many: return ".pluralMany"
        case .other: return ".plural"
        }
      }
    }

    enum CodingKeys: String, CodingKey {
      case version
      case cardinal = "plurals-type-cardinal"
    }
  }
}

let downloadURL = URL(
  string:
    // swiftlint:disable:next line_length
    "https://raw.githubusercontent.com/unicode-org/cldr-json/refs/heads/main/cldr-json/cldr-core/supplemental/plurals.json"
)!

do {
  let (data, _) = try await URLSession.shared.data(from: downloadURL)
  let decoder = JSONDecoder()
  let map = try decoder.decode(CLDRPluralMap.self, from: data)
  guard
    let outputURL = URL(filePath: #filePath)?
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .appending(
        path: "LocaleLanguageMorphologyExtensions/LocaleLanguageMorphologyExtensions.swift")
  else {
    fatalError("Failed to create output URL")
  }

  let lookupMap = map.supplemental.cardinal
    .sorted(by: { $0.key.identifier < $1.key.identifier })
    .map { key, value in
      let values = value.keys
        .sorted(by: {
          $0.grammaticalNumber.rawValue < $1.grammaticalNumber.rawValue
        })
        .map(\.grammaticalNumberAsString)
        .joined(separator: ", ")
      return
        "\"\(key)\": Set<Morphology.GrammaticalNumber>([\(values)]),"
    }
    .joined(separator: "\n  ")

  let outputString = """
    import Foundation

    extension Locale.LanguageCode {
      public var supportedGrammaticalNumberPlurals: Set<Morphology.GrammaticalNumber> {
        morphologyLookupMap[self.identifier] ?? []
      }
    }

    extension Locale.Language {
      public var supportedGrammaticalNumberPlurals: Set<Morphology.GrammaticalNumber> {
        self.languageCode?.supportedGrammaticalNumberPlurals
          ?? morphologyLookupMap[self.minimalIdentifier]
          ?? []
      }
    }

    private let morphologyLookupMap: [String: Set<Morphology.GrammaticalNumber>] = [
      \(lookupMap)
    ]

    """
  try outputString.write(to: outputURL, atomically: true, encoding: .utf8)

} catch {
  print(error)
}
