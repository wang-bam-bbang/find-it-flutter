import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:find_it/app/router.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final _router = FindItRouter();

class FindItApp extends StatelessWidget {
  const FindItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router.config(),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => _Providers(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _Providers extends StatelessWidget {
  const _Providers({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => sl<AuthBloc>()..add(const AuthEvent.load()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<UserBloc>()..add(const UserEvent.init()),
        ),
      ],
      child: child,
    );
  }
}
