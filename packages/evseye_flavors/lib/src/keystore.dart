import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

import 'templates.dart';
import 'workspace.dart';

const int _validityDays = 10000;

const String _passwordVariable = 'EVSEYE_KEYSTORE_PASSWORD';

const String _passwordChars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789';

final RegExp _country = RegExp(r'^[A-Z]{2}$');

final RegExp _alias = RegExp(r'^[A-Za-z0-9._-]+$');

final RegExp _passwordFormat = RegExp(r'^[^\s\\]{6,}$');

Future<int> createKeystore(
  Workspace workspace,
  String flavor, {
  required String organisation,
  required String country,
  String commonName = '',
  String alias = 'upload',
  String password = '',
}) async {
  if (!workspace.flavorNames.contains(flavor)) {
    stderr.writeln('No flavor called "$flavor". Available: ${workspace.flavorNames.join(', ')}');
    return 65;
  }
  final String org = organisation.trim();
  if (org.isEmpty) {
    stderr.writeln('--org is required with --create-keystore, e.g. --org EvsEye');
    return 64;
  }
  final String countryCode = country.trim().toUpperCase();
  if (!_country.hasMatch(countryCode)) {
    stderr.writeln('--country must be a two-letter code such as IN.');
    return 64;
  }
  final String keyAlias = alias.trim();
  if (!_alias.hasMatch(keyAlias)) {
    stderr.writeln('--alias may only use letters, digits, dots, dashes and underscores.');
    return 64;
  }
  if (password.isNotEmpty && !_passwordFormat.hasMatch(password)) {
    stderr.writeln('--password needs at least 6 characters, with no spaces or backslashes.');
    return 64;
  }

  final String dir = workspace.signingDir(flavor);
  final String relativeDir = p.relative(dir, from: workspace.root);
  final File keystore = File(p.join(dir, keystoreName));
  final File properties = File(p.join(dir, signingPropertiesName));
  if (keystore.existsSync() || properties.existsSync()) {
    stderr.writeln('$relativeDir already has a keystore. It was left unchanged.');
    return 73;
  }

  final String name = commonName.trim().isEmpty ? org : commonName.trim();
  final String dname = 'CN=${_dnValue(name)}, O=${_dnValue(org)}, C=$countryCode';
  final String storePassword = password.isEmpty ? _password() : password;
  Directory(dir).createSync(recursive: true);

  final ProcessResult result;
  try {
    result = await Process.run(
      _keytool(),
      [
        '-genkeypair',
        '-noprompt',
        '-keystore',
        keystore.path,
        '-storetype',
        'PKCS12',
        '-alias',
        keyAlias,
        '-keyalg',
        'RSA',
        '-keysize',
        '2048',
        '-validity',
        '$_validityDays',
        '-dname',
        dname,
        '-storepass:env',
        _passwordVariable,
        '-keypass:env',
        _passwordVariable,
      ],
      environment: {_passwordVariable: storePassword},
    );
  } on ProcessException {
    _removeIfEmpty(Directory(dir));
    stderr.writeln('keytool was not found. Install Android Studio or set JAVA_HOME to a JDK.');
    return 69;
  }
  if (result.exitCode != 0 || !keystore.existsSync()) {
    if (keystore.existsSync()) keystore.deleteSync();
    _removeIfEmpty(Directory(dir));
    stderr
      ..writeln('keytool could not create the keystore.')
      ..write(result.stderr);
    return 70;
  }

  properties.writeAsStringSync(
    signingPropertiesSource(
      storeFile: keystoreName,
      storePassword: storePassword,
      keyAlias: keyAlias,
      keyPassword: storePassword,
    ),
  );

  stdout
    ..writeln('Created $relativeDir/$keystoreName')
    ..writeln('  $dname, alias $keyAlias, RSA 2048, valid $_validityDays days')
    ..writeln('  Passwords are in $relativeDir/$signingPropertiesName')
    ..writeln()
    ..writeln('$relativeDir is not committed to git. Back it up somewhere safe:')
    ..writeln('Play only accepts updates signed with this key.')
    ..writeln()
    ..writeln('Apply the flavor to sign release builds with it: dart run evseye_flavors --flavor $flavor');
  return 0;
}

String _keytool() {
  final String exe = Platform.isWindows ? 'keytool.exe' : 'keytool';
  final String javaHome = Platform.environment['JAVA_HOME'] ?? '';
  final List<String> candidates = [
    if (javaHome.isNotEmpty) p.join(javaHome, 'bin', exe),
    if (Platform.isMacOS) '/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/$exe',
    if (Platform.isWindows) r'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe',
    if (Platform.isLinux) '/opt/android-studio/jbr/bin/$exe',
  ];
  return candidates.firstWhere((path) => File(path).existsSync(), orElse: () => exe);
}

void _removeIfEmpty(Directory dir) {
  if (dir.existsSync() && dir.listSync().isEmpty) dir.deleteSync();
}

String _password() {
  final Random random = Random.secure();
  return String.fromCharCodes([
    for (int i = 0; i < 32; i++) _passwordChars.codeUnitAt(random.nextInt(_passwordChars.length)),
  ]);
}

String _dnValue(String value) => value.replaceAllMapped(RegExp(r'[,+"\\<>;=]'), (match) => '\\${match[0]}');
