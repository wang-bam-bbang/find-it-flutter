import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/modules/post/domain/enums/content_type.dart';
import 'package:find_it/app/modules/post/presentation/pages/detail_page.dart';
import 'package:find_it/app/modules/user/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _selectedIndex = 1;
  ContentType _currentContent = ContentType.found;

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
                        _currentContent = ContentType.found;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentContent == ContentType.found
                          ? Colors.blue
                          : Colors.grey[200],
                      foregroundColor: _currentContent == ContentType.found
                          ? Colors.white
                          : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('찾았어요'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentContent = ContentType.lost;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentContent == ContentType.lost
                          ? Colors.blue
                          : Colors.grey[200],
                      foregroundColor: _currentContent == ContentType.lost
                          ? Colors.white
                          : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('잃어버렸어요'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SectionTitle(
              title: _currentContent == ContentType.found
                  ? '최근 찾은 분실물'
                  : '최근 잃어버린 분실물',
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 20,
              itemBuilder: (context, index) {
                String title = _currentContent == ContentType.found
                    ? '지갑 $index'
                    : '우산 $index';
                String location =
                    _currentContent == ContentType.found ? '생명과학동 1층' : '중앙도서관';
                String date =
                    _currentContent == ContentType.found ? '3일 전' : '1일 전';
                String itemType =
                    _currentContent == ContentType.found ? '지갑' : '우산';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('$location\n$date'),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          title: title,
                          author: '작성자 $index',
                          itemType: itemType,
                          location: location,
                          content: '여기에 분실물에 대한 상세 설명이 들어갑니다.',
                          contentType: _currentContent,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
