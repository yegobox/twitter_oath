class Consumer {
  // create a constructor with key, secret, and
  final String key;
  final String secret;
  final String? callbackUrl;

  Consumer({required this.key, required this.secret, this.callbackUrl});

  // create __toString() method
  @override
  String toString() {
    return 'Consumer{key: $key, secret: $secret, callbackUrl: $callbackUrl}';
  }
}
