import 'package:dio/dio.dart';
import 'package:find_it/app/values/strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @singleton
  Dio getDio() => Dio(BaseOptions(baseUrl: Strings.idpBaseUrl));

  FlutterSecureStorage getFlutterSecureStorage() => const FlutterSecureStorage(
      // aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
}
