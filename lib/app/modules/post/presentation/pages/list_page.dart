import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/post/domain/enums/content_type.dart';
import 'package:find_it/app/modules/post/presentation/bloc/post_list_bloc.dart';
import 'package:find_it/app/modules/post/presentation/pages/detail_page.dart';
import 'package:find_it/app/modules/user/presentation/pages/profile_page.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _selectedIndex = 1;
  PostType _currentContent = PostType.found;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return const Center(child: Text('지도 페이지'));
    } else if (_selectedIndex == 1) {
      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentContent = PostType.found;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentContent == PostType.found
                          ? Colors.blue
                          : Colors.grey[200],
                      foregroundColor: _currentContent == PostType.found
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
                        _currentContent = PostType.lost;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentContent == PostType.lost
                          ? Colors.blue
                          : Colors.grey[200],
                      foregroundColor: _currentContent == PostType.lost
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
          _ListView(type: _currentContent, key: Key(_currentContent.name)),
        ],
      );
    } else {
      return const Center(child: Text('페이지 없음'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('Find-it'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '메인'),
        ],
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    super.key,
    required PostType type,
  }) : _type = type;

  final PostType _type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostListBloc>()..add(PostListEvent.fetch(_type)),
      child: Expanded(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SectionTitle(
                title: _type == PostType.found
                    ? context.t.list.found.title
                    : context.t.list.lost.title,
              ),
            ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) => ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: state.list.length,
        itemBuilder: (context, index) {
          final item = state.list[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                '${item.location}\n${DateFormat.yMd().format(item.createdAt)}'),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    title: item.title,
                    author: item.author.name,
                    itemType: context.t.category(context: item.category),
                    location: item.location,
                    content: item.description,
                    contentType: _type,
                  ),
                ),
              );
            },
          );
        },
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
