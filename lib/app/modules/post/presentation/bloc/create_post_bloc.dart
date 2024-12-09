import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_modification_entity.dart';
import 'package:find_it/app/modules/post/domain/repositories/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'create_post_bloc.freezed.dart';

@injectable
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository _repository;
  CreatePostBloc(this._repository) : super(const _Initial()) {
    on<_Create>((event, emit) async {
      emit(const _Loading());
      try {
        final post = await _repository.createPost(post: event.entity);
        emit(_Loaded(post));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_Modify>((event, emit) async {
      emit(const _Loading());
      try {
        final post =
            await _repository.modifyPost(id: event.id, post: event.entity);
        emit(_Loaded(post));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}

@freezed
class CreatePostEvent with _$CreatePostEvent {
  const factory CreatePostEvent.create(PostCreationEntity entity) = _Create;
  const factory CreatePostEvent.modify(int id, PostModificationEntity entity) =
      _Modify;
}

@freezed
class CreatePostState with _$CreatePostState {
  const CreatePostState._();

  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.loading() = _Loading;
  const factory CreatePostState.loaded(PostEntity post) = _Loaded;
  const factory CreatePostState.error(String error) = _Error;

  bool get isLoaded => this is _Loaded;
  PostEntity get post => (this as _Loaded).post;
}
