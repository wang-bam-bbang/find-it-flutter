import 'package:find_it/app/app.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app_bloc_observer.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await configureDependencies();
  LocaleSettings.useDeviceLocale();
  _initBloc();
  runApp(TranslationProvider(child: const FindItApp()));
}

void _initBloc() {
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
}
