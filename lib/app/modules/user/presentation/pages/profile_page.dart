import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';
import 'package:find_it/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:find_it/app/values/palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutoRouteAwareStateMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '프로필',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: _Layout(),
          ),
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (_, c) => c.mapOrNull(done: (v) => true) ?? false,
      builder: (context, state) {
        final authenticated = state.user != null;
        return Column(
          children: [
            if (authenticated)
              _Profile(user: state.user!)
            else
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) => Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageFiltered(
                      enabled: authState.isLoading,
                      imageFilter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                        tileMode: TileMode.decal,
                      ),
                      child: const _Login(),
                    ),
                    if (authState.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
              ),
            const SizedBox(height: 40),
            if (authenticated) ...[
              const SizedBox(height: 20),
              TextButton(
                child: const Text("로그아웃"),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.account_circle,
          size: 100,
          color: Palette.black,
        ),
        const SizedBox(height: 10),
        Text(
          user.name,
          style: const TextStyle(
            color: Palette.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Login extends StatelessWidget {
  const _Login();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '로그인해주세요',
          style: TextStyle(
            fontSize: 24,
            color: Palette.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'GSA IDP 서비스를 통해 계정에 로그인하세요.',
          style: TextStyle(
            fontSize: 14,
            color: Palette.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.login());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.white,
            side: const BorderSide(width: 0.2),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "로그인하기",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
