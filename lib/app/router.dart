import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class FindItRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        RedirectRoute(path: '/', redirectTo: '/list'),
        AutoRoute(path: '/', page: MainNavigatorRoute.page, children: [
          AutoRoute(path: 'map', page: MapRoute.page),
          AutoRoute(path: 'list', page: ListRoute.page),
        ]),
        AutoRoute(path: '/profile', page: ProfileRoute.page),
        AutoRoute(path: '/splash', page: SplashRoute.page),
        AutoRoute(path: '/create', page: CreatePostRoute.page),
        AutoRoute(path: '/detail/:id', page: DetailRoute.page),
      ];
}
