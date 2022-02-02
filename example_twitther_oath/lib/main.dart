import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'callback.dart';
import 'home.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
    );
  }

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const Scaffold(
            body: HomePage(
              title: "flipper",
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/callback',
        name: 'callback',
        pageBuilder: (context, state) {
          // context.pop();
          // close the
          return MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: CallBackPage(),
            ),
          );
        },
      )
    ],
    errorPageBuilder: (context, error) => MaterialPage(
        key: error.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        )),
  );
}
