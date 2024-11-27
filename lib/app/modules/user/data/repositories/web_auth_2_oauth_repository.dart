import 'package:find_it/app/values/strings.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/oauth_entity.dart';
import '../../domain/exceptions/invalid_authorization_code_exception.dart';
import '../../domain/repositories/oauth_repository.dart';

@Injectable(as: OAuthRepository)
class WebAuth2OAuthRepository implements OAuthRepository {
  bool recentLogout = false;

  String get path =>
      recentLogout ? Strings.findItIdpReLoginPath : Strings.findItIdpPath;

  @override
  Future<OAuthEntity> getAuthorizationCode() async {
    final result = await FlutterWebAuth2.authenticate(
      url: '${Strings.idpBaseUrl}$path',
      callbackUrlScheme: Strings.idpRedirectScheme,
    );
    final uri = Uri.parse(result);
    final authCode = uri.queryParameters['code'];
    if (authCode == null) throw InvalidAuthorizationCodeException();
    return OAuthEntity(authCode);
  }

  @override
  Future<void> setRecentLogout([bool value = true]) async {
    recentLogout = value;
  }
}
