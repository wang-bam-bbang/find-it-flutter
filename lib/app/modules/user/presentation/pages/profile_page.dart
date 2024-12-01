import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';
import 'package:find_it/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
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
    return const Scaffold(
      body: SingleChildScrollView(
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
            TextButton(
              child: const Text("Test Button_1"),
              onPressed: () {},
            ),
            if (authenticated) ...[
              const SizedBox(height: 20),
              TextButton(
                child: const Text("로그인됨"),
                onPressed: () {},
              ),
            ],
            const SizedBox(height: 20),
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: const Text("Test Button_2"),
              onPressed: () {},
            ),
            const SizedBox(height: 40),
            if (authenticated)
              TextButton(
                onPressed: () {},
                child: const Text("Hello"),
              ),
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
        Text(
          user.email,
          style: const TextStyle(
            color: Palette.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.login());
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 0.3),
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



// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: SafeArea(
  //         child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 const Text(
  //                   '로그인',
  //                   style: TextStyle(
  //                     fontSize: 24,
  //                     color: Palette.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const Text(
  //                   "GSA IDP 서비스를 통해 계정에 로그인하세요.",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Palette.black,
  //                     fontWeight: FontWeight.normal,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 ElevatedButton(
  //                   onPressed: () {},
  //                   style: ElevatedButton.styleFrom(
  //                     side: const BorderSide(width: 0.3),
  //                     minimumSize: const Size(double.infinity, 50),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     "로그인하기",
  //                     style: TextStyle(fontSize: 18),
  //                   ),
  //                 ),
  //               ],
  //             )),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 48),
  //               const Text(
  //                 "로그인",
  //                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 16),
  //               const Text(
  //                 "계정에 로그인하세요.",
  //                 style: TextStyle(fontSize: 16, color: Colors.grey),
  //               ),
  //               const SizedBox(height: 48),
  //               TextFormField(
  //                 decoration: InputDecoration(
  //                   labelText: '이메일',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   prefixIcon: const Icon(Icons.email),
  //                 ),
  //                 keyboardType: TextInputType.emailAddress,
  //               ),
  //               const SizedBox(height: 24),
  //               TextFormField(
  //                 obscureText: true,
  //                 decoration: InputDecoration(
  //                   labelText: '비밀번호',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   prefixIcon: const Icon(Icons.lock),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: TextButton(
  //                   onPressed: () {},
  //                   child: const Text(
  //                     "비밀번호를 잊으셨나요?",
  //                     style: TextStyle(color: Colors.blue),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 32),
  //               ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   side: const BorderSide(width: 0.3),
  //                   minimumSize: const Size(double.infinity, 50),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   "로그인",
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text("계정이 없으신가요?"),
  //                   TextButton(
  //                     onPressed: () {},
  //                     child: const Text(
  //                       "회원가입",
  //                       style: TextStyle(color: Colors.blue),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }