class Token {
  final String key;
  final String secret;

  Token({required this.key, required this.secret});

  //implement __toString
  @override
  String toString() {
    return 'oauth_token=$key&oauth_token_secret=$secret';
  }
}
