import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/comment/domain/entities/comment_entity.dart';
import 'package:find_it/app/modules/comment/presentation/bloc/comment_bloc.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:find_it/app/values/palette.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  final PostEntity post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentBloc>()..add(CommentEvent.load(post)),
      child: _Layout(post: post),
    );
  }
}

class _Layout extends StatefulWidget {
  final PostEntity post;

  const _Layout({required this.post});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  final TextEditingController _commentController = TextEditingController();
  final Map<int, TextEditingController> _replyControllers = {};
  final Map<int, bool> _showReplyField = {};

  void _addComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      context.read<CommentBloc>().add(CommentEvent.create(
            postId: widget.post.id,
            text: comment,
          ));
      _commentController.clear();
    }
  }

  void _addReply(int commentIndex) {
    final replyController = _replyControllers[commentIndex];
    if (replyController == null) return;

    final reply = replyController.text.trim();
    if (reply.isNotEmpty) {
      final bloc = context.read<CommentBloc>();
      bloc.add(CommentEvent.create(
        postId: widget.post.id,
        text: reply,
        parentId: bloc.state.comments[commentIndex].id,
      ));
      replyController.clear();
    }
  }

  Widget _buildComment(CommentEntity comment, int commentIndex,
      {bool isReply = false}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 4, left: isReply ? 12 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isReply)
            Container(
              margin: const EdgeInsets.only(right: 8, top: 6),
              child: const Icon(
                Icons.subdirectory_arrow_right,
                size: 24,
                color: Colors.grey,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[400]!, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            comment.author.name,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (!isReply && (_showReplyField[commentIndex] != true)) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _replyControllers[commentIndex] ??=
                              TextEditingController();
                          _showReplyField[commentIndex] = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '대댓글 달기',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (comment.children.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comment.children
                          .asMap()
                          .entries
                          .map((entry) => _buildComment(
                              entry.value, commentIndex,
                              isReply: true))
                          .toList(),
                    ),
                  ),
                if (!isReply && _showReplyField[commentIndex] == true) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 44),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyControllers[commentIndex],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              hintText: '대댓글을 입력하세요',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.grey[400]!, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.blue[300]!, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _addReply(commentIndex),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            '작성',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
                if (!isReply) const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        buildWhen: (_, c) => c.mapOrNull(done: (v) => true) ?? false,
        builder: (context, state) {
          final authenticated = state.user != null;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                if (state.user != null &&
                    state.user!.uuid == widget.post.author.uuid)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      CreatePostRoute(post: widget.post).push(context);
                    },
                  ),
              ],
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
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
                        '발견 위치: ${widget.post.building.displayName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      Text(
                        '예상 분실 위치: ${widget.post.building.displayName}',
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
                        child: const Center(
                          child: DetailMap(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '댓글',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (!authenticated) ...[
                            ElevatedButton(
                              onPressed: () {
                                const ProfileRoute().push(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.white,
                                side: const BorderSide(width: 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "로그인하고 댓글 작성하기",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<CommentBloc, CommentState>(
                      builder: (context, state) => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) =>
                            _buildComment(state.comments[index], index),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (authenticated) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                      )
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class DetailMap extends StatefulWidget {
  const DetailMap({super.key});

  @override
  State<DetailMap> createState() => _DetailMapState();
}

class _DetailMapState extends State<DetailMap> {
  final _controller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: _controller,
      osmOption: const OSMOption(
        zoomOption: ZoomOption(
          initZoom: 16,
          minZoomLevel: 10,
        ),
      ),
    );
  }
}
