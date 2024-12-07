import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String itemType;
  final String location;
  final String content;
  final PostType contentType;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.itemType,
    required this.location,
    required this.content,
    required this.contentType,
  });

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
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '작성자: $author',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '분실물 종류: $itemType',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (contentType == PostType.found) ...[
                Text(
                  '발견 위치: $location',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Text(
                  '예상 분실 위치: $location',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(child: Text('사진 영역')),
              ),
              if (contentType == PostType.found) ...[
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
