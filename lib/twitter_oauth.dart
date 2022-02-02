library twitter_oauth;

import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_oauth/isar_export.dart';
import 'package:twitter_oauth/request.dart';
import 'package:twitter_oauth/response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:convert' as J;
import 'config.dart';
import 'consumer.dart';
import 'hmac_sha1.dart';
import 'token.dart';
import 'package:http/http.dart' as http;

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  ExtendedClient(this._inner);
  // final log = getLogger('ExtendedClient');
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Content-Type'] = 'application/json';
    return _inner.send(request);
  }
}

/// A Calculator.
class TwitterOAuth extends Config {
  // ignore: constant_identifier_names
  static const String API_HOST = "https://api.twitter.com";
  // ignore: constant_identifier_names
  static const String UPLOAD_HOST = "https://upload.twitter.com";
  ExtendedClient client = ExtendedClient(http.Client());
  // final
  Response? response;
  Consumer? consumer;
  Token? token;
  HmacSha1? signatureMethod;
  int attempts = 0;
  String? oauthToken;
  String? oauthTokenSecret;
  String consumerKey;
  String? bearer;
  String? consumerSecret;
  late GetStorage box;

  TwitterOAuth(
      {required this.consumerKey,
      required this.consumerSecret,
      this.oauthToken,
      this.oauthTokenSecret}) {
    resetLastResponse();
    signatureMethod = HmacSha1();
    consumer = Consumer(key: consumerKey, secret: consumerSecret!);
    //if is not empty oauthToken and oauthTokenSecret then setOauthToken
    if (oauthToken != null && oauthTokenSecret != null) {
      setOauthToken(oauthToken!, oauthTokenSecret!);
    }
    if (oauthToken == null && oauthTokenSecret != null) {
      setBearer(oauthTokenSecret!);
    }
    // init built-in db to track rate limit and other things
    // TODOfor web use something else:
    box = GetStorage();
    if (!kIsWeb) {
      initDb();
    }
  }
  Future<void> iniStorage() async {
    await GetStorage.init();
  }

  Future<void> initDb() async {
    final dir = await getApplicationSupportDirectory(); // path_provider package
    final isar = await Isar.open(
      schemas: [SettingsSchema],
      directory: dir.path,
      inspector: true, // if you want to enable the inspector for debug builds
    );
  }

  setOauthToken(String oauthToken, String oauthTokenSecret) {
    token = Token(key: oauthToken, secret: oauthTokenSecret);
    bearer = null;
  }

  String setBearer(String bearer) {
    this.bearer = bearer;
    token = null;
    return bearer;
  }

  String? getLastApiPath() {
    return response?.getApiPath();
  }

  int? getLastHttpCode() {
    return response?.getHttpCode();
  }

  Map<String, String>? getLastXHeaders() {
    return response?.getXHeaders();
  }

  getLastBody() {
    return response?.getBody();
  }

  resetLastResponse() {
    response = Response();
  }

  void resetAttemptsNumber() {
    attempts = 0;
  }

  void sleepIfNeeded() {
    if (attempts > 0) {
      int delay = (attempts * attempts) * 100;
      sleep(Duration(milliseconds: delay));
    }
  }

  String url(String path, List<String> parameters) {
    resetLastResponse();
    response?.setApiPath(path);
    String query = parameters.join("&");
    return "$API_HOST/$path?$query";
  }

  Future<dynamic> oauth(String path, Map<String, String> parameters) async {
    resetLastResponse();
    response?.setApiPath(path);
    String host = "$API_HOST/$path";

    http.Response? result = await oAuthRequest(host, 'POST', parameters, false);

    Map<String, String> map = {};

    result?.body.split('&').forEach((element) {
      List<String> list = element.split('=');
      map[list[0]] = list[1];
    });
    String kUrl = url("oauth/authorize", [
      "oauth_token=${map['oauth_token']}",
    ]);
    if (!await launch(
      kUrl,
      forceSafariVC: false,
      forceWebView: false,
    )) {
      throw 'Could not launch $kUrl';
    }
    response?.setHttpCode(result!.statusCode);
    if (getLastHttpCode() != 200) {
      throw Exception("Error: ${getLastHttpCode()}");
    }
    return response?.setBody(result);
  }

  oAuthRequest(
      String url, String method, Map<String, String> parameters, bool json) {
    Request request = Request.fromConsumerAndToken(
      consumer: consumer,
      httpMethod: method,
      httpUrl: url,
      token: token,
      parameters: parameters,
    );

    if (parameters.containsKey("oauth_callback")) {
      // Twitter doesn't like oauth_callback as a parameter.
      parameters.remove("oauth_callback");
    }
    String authorization = "";
    if (bearer == null) {
      request.signRequest(signatureMethod!, consumer!, token);
      authorization = request.toHeader();
      if (parameters.containsKey("oauth_verifier")) {
        parameters.remove("oauth_verifier");
      }
    } else {
      authorization = "Authorization: Bearer $bearer";
    }
    return this.request(request.getNormalizedHttpUrl(), method, authorization,
        parameters, json);
  }

  Future<http.Response> request(String url, String method, String authorization,
      Map<String, dynamic> postfields, bool json) async {
    Map<String, String> headers = {
      'Accept': ' application/json',
    };
    late http.Response response;
    switch (method) {
      case "POST":
        response = await client.post(Uri.parse(url + "?" + authorization),
            headers: headers);
        break;
      default:
    }

    return response;
  }

  String encodeAppAuthorization(Consumer consumer) {
    String key = Uri.encodeQueryComponent(consumer.key);
    String secret = Uri.encodeQueryComponent(consumer.secret);
    return J.base64Encode(J.utf8.encode("$key:$secret"));
  }
}
