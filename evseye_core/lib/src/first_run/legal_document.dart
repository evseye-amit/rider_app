sealed class LegalDocument {
  const LegalDocument();
}

final class BundledLegalDocument extends LegalDocument {
  const BundledLegalDocument(this.asset);

  final String asset;
}

final class HostedLegalDocument extends LegalDocument {
  const HostedLegalDocument(this.url);

  final Uri url;
}

abstract final class LegalDocuments {
  static const LegalDocument terms = BundledLegalDocument('packages/evseye_core/assets/legal/terms.html');

  const LegalDocuments._();
}
