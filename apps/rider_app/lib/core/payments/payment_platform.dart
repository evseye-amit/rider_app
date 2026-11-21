import 'package:flutter/foundation.dart';

String get paymentPlatform => defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';
