import 'package:dio/dio.dart';
import 'package:find_it/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:find_it/app/values/strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @singleton
  Dio getDio(AuthorizeInterceptor authorizeInterceptor) {
    final dio = Dio(BaseOptions(baseUrl: Strings.baseUrl));
    dio.interceptors.add(authorizeInterceptor);
    return dio;
  }

  FlutterSecureStorage getFlutterSecureStorage() =>
      const FlutterSecureStorage();
}
