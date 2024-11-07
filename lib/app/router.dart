import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class FindItRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        RedirectRoute(path: '/', redirectTo: '/splash'),
        AutoRoute(path: '/splash', page: SplashRoute.page),
        AutoRoute(path: '/login', page: LoginRoute.page),
      ];
}
