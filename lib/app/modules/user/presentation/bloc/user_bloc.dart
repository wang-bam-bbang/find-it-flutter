import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';
import 'package:find_it/app/modules/user/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_bloc.freezed.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(
    this._repository,
  ) : super(const _Initial()) {
    on<_Init>((event, emit) async {
      return emit.forEach(
        onData: (data) => data == null ? const _Initial() : _Done(data),
        _repository.me,
        onError: (_, __) => const _Initial(),
      );
    });
    on<_Fetch>((event, emit) async {
      _repository.refetchMe();
    });
  }

  static UserEntity? userOrNull(BuildContext context) =>
      context.read<UserBloc>().state.user;
}

@freezed
sealed class UserEvent with _$UserEvent {
  const factory UserEvent.init() = _Init;
  const factory UserEvent.fetch() = _Fetch;
}

@freezed
sealed class UserState with _$UserState {
  const UserState._();

  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.done(UserEntity? user) = _Done;

  bool get isLoading => whenOrNull(loading: () => true) ?? false;
  UserEntity? get user => mapOrNull(done: (e) => e.user);
}
