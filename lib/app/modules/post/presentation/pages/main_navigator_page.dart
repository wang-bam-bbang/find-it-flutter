import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainNavigatorPage extends StatelessWidget {
  const MainNavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        MapRoute(),
        ListRoute(),
      ],
      builder: (context, tabsRouter, controller) {
        return Scaffold(
          body: tabsRouter,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: '지도',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '목록',
              ),
            ],
            currentIndex: controller.index,
            onTap: controller.animateTo,
          ),
        );
      },
    );
  }
}
