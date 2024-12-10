import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart' as domain;
import 'package:find_it/app/modules/post/presentation/bloc/post_list_bloc.dart';
import 'package:find_it/app/modules/post/presentation/widgets/post_item.dart';
import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';
import 'package:find_it/app/modules/user/presentation/bloc/auth_bloc.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:find_it/app/values/palette.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: _Layout(),
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
            if (authenticated) ...[
              _Profile(user: state.user!),
              const Expanded(child: _List()),
            ] else
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Palette.black,
          ),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: const TextStyle(
              color: Palette.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ]),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.logout());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.white,
            side: const BorderSide(width: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "로그아웃",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  domain.PostType _currentContent = domain.PostType.found;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('내가 작성한 게시글', style: TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentContent = domain.PostType.found;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentContent == domain.PostType.found
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _currentContent == domain.PostType.found
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(context.t.list.found.label),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentContent = domain.PostType.lost;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentContent == domain.PostType.lost
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _currentContent == domain.PostType.lost
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(context.t.list.lost.label),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              _ListView(type: _currentContent, key: Key(_currentContent.name)),
        )
      ],
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    super.key,
    required domain.PostType type,
  }) : _type = type;

  final domain.PostType _type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostListBloc>()..add(PostListEvent.fetchMyPost(_type)),
      child: Column(
        children: [
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) => ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: state.list.length,
        itemBuilder: (context, index) => PostItem(item: state.list[index]),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('더보기 >'),
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
