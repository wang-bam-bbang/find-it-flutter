import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/values/palette.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Palette.white,
    );
  }
}