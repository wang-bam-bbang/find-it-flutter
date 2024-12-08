import 'package:find_it/app/modules/comment/domain/entities/comment_entity.dart';
import 'package:find_it/app/modules/comment/domain/repositories/comment_repository.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'comment_bloc.freezed.dart';

@injectable
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _repository;

  CommentBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(const CommentState.loading());
      final comments = await _repository.getComments(event.post.id);
      emit(CommentState.loaded(comments));
    });
    on<_Create>((event, emit) async {
      emit(CommentState.loading(state.comments));
      final comment = await _repository.create(
        postId: event.postId,
        text: event.text,
        parentId: event.parentId,
      );
      final comments = await _repository.getComments(comment.postId);
      emit(CommentState.loaded(comments));
    });
    on<_Delete>((event, emit) async {
      emit(CommentState.loading(state.comments));
      await _repository.delete(event.comment);
      final comments = await _repository.getComments(event.comment.postId);
      emit(CommentState.loaded(comments));
    });
  }
}

@freezed
class CommentEvent with _$CommentEvent {
  const factory CommentEvent.load(PostEntity post) = _Load;
  const factory CommentEvent.create({
    required int postId,
    required String text,
    int? parentId,
  }) = _Create;
  const factory CommentEvent.delete(CommentEntity comment) = _Delete;
}

@freezed
class CommentState with _$CommentState {
  const factory CommentState.initial(
      [@Default([]) List<CommentEntity> comments]) = _Initial;
  const factory CommentState.loading(
      [@Default([]) List<CommentEntity> comments]) = _Loading;
  const factory CommentState.loaded(List<CommentEntity> comments) = _Loaded;
}
