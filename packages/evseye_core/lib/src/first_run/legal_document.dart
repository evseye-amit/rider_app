final class LegalDocument {
  const LegalDocument(this.url);

  final Uri url;
}

abstract final class LegalDocuments {
  static final LegalDocument terms = LegalDocument(Uri.parse('https://www.linkedin.com/legal/privacy-policy'));

  const LegalDocuments._();
}
