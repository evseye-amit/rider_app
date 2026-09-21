import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class LegalLink {
  static final Uri document = Uri.parse(
    'https://docs.google.com/document/d/1po2iWjdAUXXRl5BBYvv5VcVWTouIhovHSGeoz92ZbUs/edit?usp=sharing',
  );

  static Future<void> open(BuildContext context) async {
    final bool ok = await launchUrl(
      document,
      mode: LaunchMode.externalApplication,
    );
    if (ok || !context.mounted) return;
    AppSnack.error(context, 'Could not open the document. Try again.');
  }

  const LegalLink._();
}
