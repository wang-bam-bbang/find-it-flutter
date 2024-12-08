import 'package:find_it/app/modules/comment/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Future<List<CommentEntity>> getComments(int postId);
  Future<CommentEntity> create({
    required int postId,
    required String text,
    int? parentId,
  });
  Future<void> delete(CommentEntity comment);
}
