import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  final PostEntity post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('분실물 상세 정보'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '작성자: ${post.author.name}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '분실물 종류: ${context.t.category(context: post.category)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (post.type == PostType.found) ...[
                Text(
                  '발견 위치: ${post.location}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Text(
                  '예상 분실 위치: ${post.location}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                post.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              for (final image in post.images)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(child: Image.network(image)),
                ),
              if (post.type == PostType.found) ...[
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(child: Text('지도 영역')),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
