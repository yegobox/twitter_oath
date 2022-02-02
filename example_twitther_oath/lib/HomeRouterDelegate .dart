// ignore: file_names
import 'package:flutter/material.dart';

import 'home.dart';
import 'homeRoute.dart';

class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeRoutePath> {
  String pathName = "";
  bool isError = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
    if (isError) return HomeRoutePath.unKown();

    if (pathName == "") {
      return HomeRoutePath.home();
    }

    return HomeRoutePath.otherPage(pathName);
  }

  void onTapped(String path) {
    pathName = path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          const MaterialPage(
            key: ValueKey('HomePage'),
            child: HomePage(
              title: "flipper",
            ),
          ),
          if (isError)
            const MaterialPage(
                key: ValueKey('UnknownPage'),
                child: HomePage(
                  title: "flipper",
                ))
          else if (pathName != "")
            MaterialPage(
              key: ValueKey(pathName),
              child: const HomePage(
                title: "flipper",
              ),
            )
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          pathName = "";
          isError = false;
          notifyListeners();

          return true;
        });
  }

  @override
  Future<void> setNewRoutePath(HomeRoutePath homeRoutePath) async {
    if (homeRoutePath.isUnkown) {
      pathName = "";
      isError = true;
      return;
    }

    if (homeRoutePath.isOtherPage) {
      if (homeRoutePath.pathName != "") {
        pathName = homeRoutePath.pathName;
        isError = false;
        return;
      } else {
        isError = true;
        return;
      }
    } else {
      pathName = "";
    }
  }
}
