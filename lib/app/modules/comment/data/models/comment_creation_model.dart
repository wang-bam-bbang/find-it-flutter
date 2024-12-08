import 'package:find_it/app/modules/comment/domain/enums/comment_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_creation_model.freezed.dart';
part 'comment_creation_model.g.dart';

@freezed
class CommentCreationModel with _$CommentCreationModel {
  const factory CommentCreationModel({
    required int postId,
    required String content,
    required CommentType type,
    int? parentId,
  }) = _CommentCreationModel;

  factory CommentCreationModel.fromJson(Map<String, dynamic> json) =>
      _$CommentCreationModelFromJson(json);
}
