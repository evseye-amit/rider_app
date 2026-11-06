import 'package:evseye_core/evseye_core.dart';
import 'package:material_ui/material_ui.dart';

abstract final class LegalLink {
  static Future<void> open(BuildContext context, LegalKind kind) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => LegalDocumentPage(audience: LegalAudience.rider, kind: kind),
    ),
  );

  const LegalLink._();
}
