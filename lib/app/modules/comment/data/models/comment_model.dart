import 'package:find_it/app/modules/comment/domain/entities/comment_entity.dart';
import 'package:find_it/app/modules/comment/domain/enums/comment_type.dart';
import 'package:find_it/app/modules/post/data/models/public_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel implements CommentEntity {
  const factory CommentModel({
    required int id,
    required String content,
    required CommentType type,
    required int postId,
    required PublicUserModel author,
    required DateTime createdAt,
    required bool isDeleted,
    required List<CommentModel> children,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
