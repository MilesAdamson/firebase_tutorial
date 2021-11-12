typedef LanguageIdentifier = String;

/// https://docs.microsoft.com/en-us/cpp/c-runtime-library/language-strings?view=msvc-170
class Languages {
  static const LanguageIdentifier english = "en-US";
  static const LanguageIdentifier frenchCanadian = "fr-CA";
  static const LanguageIdentifier chinese = "zh";
  static const LanguageIdentifier norwegian = "en-US";

  static const all = <LanguageIdentifier>[
    english,
    frenchCanadian,
    chinese,
    norwegian,
  ];

  Languages._();
}
