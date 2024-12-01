import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Strings {
  Strings._();

  static final idpRedirectScheme = dotenv.get('IDP_REDIRECT_SCHEME');
  static final idpBaseUrl = dotenv.get('IDP_BASE_URL');
  static final findItIdpClientId = dotenv.get('IDP_CLIENT_ID');
  static final findItIdpPath = dotenv.get('IDP_PATH');
  static final findItIdpReLoginPath = dotenv.get('IDP_RE_LOGIN_PATH');
  static final privacyPolicyUrl = dotenv.get('PRIVACY_POLICY_URL');
  static final termsOfServiceUrl = dotenv.get('TERMS_OF_SERVICE_URL');
}
