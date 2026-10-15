final RegExp _breaks = RegExp(r'<\s*(br|/p|/div|/h[1-6]|/tr)\s*/?\s*>', caseSensitive: false);
final RegExp _bullets = RegExp(r'<\s*li[^>]*>', caseSensitive: false);
final RegExp _hidden = RegExp(r'<\s*(script|style)[^>]*>.*?<\s*/\s*\1\s*>', caseSensitive: false, dotAll: true);
final RegExp _tags = RegExp(r'<[^>]*>');
final RegExp _blankLines = RegExp(r'\n{3,}');
final RegExp _numeric = RegExp(r'&#(x?)([0-9a-fA-F]+);');

const Map<String, String> _entities = {
  '&nbsp;': ' ',
  '&amp;': '&',
  '&lt;': '<',
  '&gt;': '>',
  '&quot;': '"',
  '&#39;': "'",
  '&apos;': "'",
  '&rsquo;': '’',
  '&lsquo;': '‘',
  '&rdquo;': '”',
  '&ldquo;': '“',
  '&ndash;': '–',
  '&mdash;': '—',
  '&hellip;': '…',
  '&rupee;': '₹',
};

String plainTextFromHtml(String source) {
  if (!source.contains('<') && !source.contains('&')) return source.trim();
  String text = source
      .replaceAll(_hidden, '')
      .replaceAll(_breaks, '\n')
      .replaceAll(_bullets, '\n• ')
      .replaceAll(_tags, '');
  text = text.replaceAllMapped(_numeric, (match) {
    final int? code = int.tryParse(match.group(2)!, radix: match.group(1)!.isEmpty ? 10 : 16);
    return code == null ? match.group(0)! : String.fromCharCode(code);
  });
  _entities.forEach((entity, value) => text = text.replaceAll(entity, value));
  return text.split('\n').map((line) => line.trim()).join('\n').replaceAll(_blankLines, '\n\n').trim();
}
