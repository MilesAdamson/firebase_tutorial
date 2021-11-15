typedef LanguageIdentifier = String;

/// https://docs.microsoft.com/en-us/cpp/c-runtime-library/language-strings?view=msvc-170
class Languages {
  static const LanguageIdentifier english = "en-US";
  static const LanguageIdentifier frenchCanadian = "fr-CA";
  static const LanguageIdentifier chinese = "zh";
  static const LanguageIdentifier norwegian = "no";

  static const all = <LanguageIdentifier>[
    english,
    frenchCanadian,
    chinese,
    norwegian,
  ];

  Languages._();
}

extension LanguageExtensions on LanguageIdentifier {
  String get displayString {
    switch (this) {
      case Languages.english:
        return "English";
      case Languages.frenchCanadian:
        return "French Canadian";
      case Languages.chinese:
        return "Chinese";
      case Languages.norwegian:
        return "Norwegian";
      default:
        throw UnimplementedError("Display string not implemented for $this");
    }
  }
}
