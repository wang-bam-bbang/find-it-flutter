import 'package:find_it/app/modules/comment/domain/enums/comment_type.dart';
import 'package:find_it/app/modules/user/domain/entities/public_user_entity.dart';

abstract class CommentEntity {
  int get id;
  String get content;
  CommentType get type;
  int get postId;
  PublicUserEntity get author;
  DateTime get createdAt;
  bool get isDeleted;
  List<CommentEntity> get children;
}
