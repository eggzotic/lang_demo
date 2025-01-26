/// This should exactly cover the languages supported (i.e. those present under `assets/i18n/`)
enum SupportedLangs {
  // ignore: constant_identifier_names
  en_US("English (US)"), // American English
  // ignore: constant_identifier_names
  en_GB("English (UK)"), // British English
  en("English (other)"),
  es("español"), // Spanish
  mi("Te Reo Māori"); // NZ Māori

  final String fullName;
  const SupportedLangs(this.fullName);

  static List<String> get allCodes => values.map((l) => l.name).toList();
  static SupportedLangs fromCode(String code) =>
      values.firstWhere((l) => l.name == code);
}
