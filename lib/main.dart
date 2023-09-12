import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/bootstrap.dart';
import 'package:pdpa/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  bootstrap();
}
