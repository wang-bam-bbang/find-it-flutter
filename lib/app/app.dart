import 'package:find_it/app/router.dart';
import 'package:flutter/material.dart';

final _router = FindItRouter();

class FindItApp extends StatelessWidget {
  const FindItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router.config(),
    );
  }
}
