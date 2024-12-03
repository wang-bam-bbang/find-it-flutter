import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/content_type.dart';
import 'package:find_it/app/modules/post/domain/repositories/post_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'post_list_bloc.freezed.dart';

@injectable
class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostRepository _repository;

  PostListBloc(this._repository) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      try {
        final posts = await _repository.getPosts(type: event.type);
        emit(_Loaded(posts));
      } catch (e) {
        emit(_Error([], e.toString()));
      }
    });
  }
}

@freezed
class PostListEvent with _$PostListEvent {
  const factory PostListEvent.fetch(PostType type) = _Fetch;
}

@freezed
class PostListState with _$PostListState {
  const factory PostListState.initial([@Default([]) List<PostEntity> list]) =
      _Initial;
  const factory PostListState.loading([@Default([]) List<PostEntity> list]) =
      _Loading;
  const factory PostListState.loaded(List<PostEntity> list) = _Loaded;
  const factory PostListState.error(List<PostEntity> list, String error) =
      _Error;
}
