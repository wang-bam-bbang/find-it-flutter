import 'package:find_it/app/app.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const FindItApp()));
}
