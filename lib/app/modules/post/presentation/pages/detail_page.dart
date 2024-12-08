import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';

class Comment {
  final String text;
  final List<Comment> replies;

  Comment(this.text, [List<Comment>? replies]) : replies = replies ?? [];
}

@RoutePage()
class DetailPage extends StatefulWidget {
  final PostEntity post;

  const DetailPage({super.key, required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final Map<int, TextEditingController> _replyControllers = {};
  final List<Comment> _comments = [];

  void _addComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      setState(() {
        _comments.add(Comment(comment));
      });
      _commentController.clear();
    }
  }

  void _addReply(int commentIndex) {
    final replyController = _replyControllers[commentIndex];
    if (replyController == null) return;

    final reply = replyController.text.trim();
    if (reply.isNotEmpty) {
      setState(() {
        final comment = _comments[commentIndex];
        final updatedReplies = List<Comment>.from(comment.replies)
          ..add(Comment(reply));
        _comments[commentIndex] = Comment(comment.text, updatedReplies);
      });
      replyController.clear();
    }
  }

  Widget _buildComment(Comment comment, int commentIndex,
      {bool isReply = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, left: isReply ? 16 : 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.text),
          const SizedBox(height: 8),
          if (!isReply)
            TextButton(
              onPressed: () {
                setState(() {
                  _replyControllers[commentIndex] ??= TextEditingController();
                });
              },
              child: const Text('답글 달기'),
            ),
          if (comment.replies.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comment.replies
                  .asMap()
                  .entries
                  .map((entry) =>
                      _buildComment(entry.value, commentIndex, isReply: true))
                  .toList(),
            ),
          if (!isReply && _replyControllers.containsKey(commentIndex))
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyControllers[commentIndex],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '답글을 입력하세요',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addReply(commentIndex),
                      child: const Text('작성'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
        ],
      ),
    );
  }

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
                widget.post.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '작성자: ${widget.post.author.name}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '분실물 종류: ${context.t.category(context: widget.post.category)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (widget.post.type == PostType.found) ...[
                Text(
                  '발견 위치: ${widget.post.location}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Text(
                  '예상 분실 위치: ${widget.post.location}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                widget.post.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              for (final image in widget.post.images)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(child: Image.network(image)),
                ),
              if (widget.post.type == PostType.found) ...[
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
              const Divider(),
              const Text(
                '댓글',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (final entry in _comments.asMap().entries)
                _buildComment(entry.value, entry.key),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '댓글을 입력하세요',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addComment,
                    child: const Text('작성'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
