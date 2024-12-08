import 'package:find_it/app/modules/comment/data/data_source/remote/comment_api.dart';
import 'package:find_it/app/modules/comment/data/models/comment_creation_model.dart';
import 'package:find_it/app/modules/comment/domain/entities/comment_entity.dart';
import 'package:find_it/app/modules/comment/domain/enums/comment_type.dart';
import 'package:find_it/app/modules/comment/domain/repositories/comment_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommentRepository)
class RestCommentRepository implements CommentRepository {
  final CommentApi _api;

  RestCommentRepository(this._api);

  @override
  Future<CommentEntity> create({
    required int postId,
    required String text,
    int? parentId,
  }) {
    return _api.createComment(CommentCreationModel(
      postId: postId,
      content: text,
      type: parentId == null ? CommentType.comment : CommentType.reply,
      parentId: parentId,
    ));
  }

  @override
  Future<void> delete(CommentEntity comment) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<CommentEntity>> getComments(int postId) {
    return _api.getComments(postId);
  }
}
