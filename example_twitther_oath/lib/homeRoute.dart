class HomeRoutePath {
  final String pathName;
  final bool isUnkown;

  HomeRoutePath.home()
      : pathName = "",
        isUnkown = false;

  HomeRoutePath.otherPage(this.pathName) : isUnkown = false;

  HomeRoutePath.unKown()
      : pathName = "",
        isUnkown = true;

  bool get isHomePage => pathName == "";
  bool get isOtherPage => pathName != "";
}
