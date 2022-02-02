import 'package:flutter/material.dart';

import 'homeRoute.dart';

class HomeRouteInformationParser extends RouteInformationParser<HomeRoutePath> {
  @override
  Future<HomeRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return HomeRoutePath.home();
    }

    if (uri.pathSegments.length == 1) {
      final pathName = uri.pathSegments.elementAt(0).toString();
      if (pathName == "") return HomeRoutePath.unKown();
      return HomeRoutePath.otherPage(pathName);
    }

    return HomeRoutePath.unKown();
  }

  @override
  RouteInformation? restoreRouteInformation(HomeRoutePath homeRoutePath) {
    if (homeRoutePath.isUnkown) {
      return const RouteInformation(location: '/error');
    }
    if (homeRoutePath.isHomePage) {
      return const RouteInformation(location: '/callback?');
    }
    if (homeRoutePath.isOtherPage) {
      return RouteInformation(location: '/${homeRoutePath.pathName}');
    }

    return null;
  }
}
