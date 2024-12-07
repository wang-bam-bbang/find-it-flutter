import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
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
        await _repository.createPost(post: event.entity);
        emit(const _Loaded());
      } catch (e) {
        emit(const _Error());
      }
    });
  }
}

@freezed
class CreatePostEvent with _$CreatePostEvent {
  const factory CreatePostEvent.create(PostCreationEntity entity) = _Create;
}

@freezed
class CreatePostState with _$CreatePostState {
  const CreatePostState._();

  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.loading() = _Loading;
  const factory CreatePostState.loaded() = _Loaded;
  const factory CreatePostState.error() = _Error;

  bool get isLoaded => this is _Loaded;
}
