/// Twitter config
class Config {
  // ignore: non_constant_identifier_names
  static List<String> SUPPORTED_VERSION = ['1.1', '2'];
  static Duration timeout = const Duration(seconds: 10);
  static const connectionTimeout = Duration(seconds: 10);
  static const maxRetries = 3;
  static const retriesDelay = Duration(seconds: 1);
  static String apiVersion = '1.1';
  static const decodeJsonArray = true;
  static const userAgent = 'Twitter for Dart';
  static Map<String, dynamic> proxy = {};
  static const gzipEncoding = true;
  static const chunkSize = 250000; // 0.25 MegaByte
  void setApiVersion(String version) {
    if (SUPPORTED_VERSION.contains(version)) {
      apiVersion = version;
    } else {
      throw Exception('Unsupported API version: $version');
    }
  }

  void setTimeOuts(Duration timeout, Duration connectionTimeout) {
    timeout = timeout;
    connectionTimeout = connectionTimeout;
  }

  void setRetries(int maxRetries, Duration retriesDelay) {
    maxRetries = maxRetries;
    retriesDelay = retriesDelay;
  }

  void setDecodeJsonAsArray(bool decodeJsonArray) {
    decodeJsonArray = decodeJsonArray;
  }

  void setUserAgent(String userAgent) {
    userAgent = userAgent;
  }

  void setProxy(Map<String, dynamic> proxy) {
    proxy = proxy;
  }

  void setGzipEncoding(bool gzipEncoding) {
    gzipEncoding = gzipEncoding;
  }

  void setChunkSize(int chunkSize) {
    chunkSize = chunkSize;
  }
}
