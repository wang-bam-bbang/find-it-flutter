import 'dart:async';

import 'package:find_it/app/modules/user/data/data_sources/models/user_model.dart';
import 'package:find_it/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';
import 'package:find_it/app/modules/user/domain/repositories/auth_repository.dart';
import 'package:find_it/app/modules/user/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Singleton(as: UserRepository)
class RestUserRepository implements UserRepository {
  final UserApi _api;
  final AuthRepository _authRepository;
  final _subject = BehaviorSubject<UserModel?>();

  static dispose(UserRepository inst) {
    final instance = inst as RestUserRepository;
    instance._subject.close();
  }

  RestUserRepository(this._api, this._authRepository) {
    _authRepository.isSignedIn.listen((signedIn) async {
      if (!signedIn) {
        _subject.add(null);
        return;
      }
      try {
        // final user = await _api.info();
        // _subject.add(user);
      } catch (_) {
        _subject.add(null);
      }
    });
  }

  @override
  Stream<UserModel?> get me => _subject.stream;

  @override
  Future<UserEntity?> refetchMe() async {
    try {
      // final user = await _api.info();
      // _subject.add(user);
      // return user;
    } catch (_) {
      _subject.add(null);
      return null;
    }
    return null;
  }
}
