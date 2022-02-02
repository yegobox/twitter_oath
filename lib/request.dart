import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:twitter_oauth/consumer.dart';

import 'signature_method.dart';
import 'token.dart';

class Request {
  Map<String, dynamic> parameters = {};
  String httpMethod = "GET";
  String httpUrl = "";
  String jjson = "";
  String version = "1.0";

  Request(
    this.httpMethod,
    this.httpUrl,
    this.parameters,
  );
  static fromConsumerAndToken({
    Consumer? consumer,
    Token? token,
    String? httpMethod,
    String? httpUrl,
    Map<String, dynamic> parameters = const {},
    jjson = false,
  }) {
    Map<String, String> defaults = {
      'oauth_version': '1.0',
      'oauth_nonce': generateNonce(),
      'oauth_timestamp': 1643696722.toString(),
      'oauth_consumer_key': consumer!.key,
    };
    if (token != null) {
      defaults['oauth_token'] = token.key;
    }
    // The jjson payload is not included in the signature on jjson requests,
    // therefore it shouldn't be included in the parameters array.
    if (jjson) {
      // parameters = defaults;
      parameters.addAll(defaults);
    } else {
      parameters.addAll(defaults);
    }
    return Request(httpMethod!, httpUrl!, parameters);
  }

  // generate a nonce compliant with twitter's requirements
  static String generateNonce() {
    // Random rnd = Random();

    // List<int> values = List<int>.generate(32, (i) => rnd.nextInt(256));
    // print(base64Encode(values).replaceAll(RegExp('[=/+]'), ''));
    // return base64Encode(values).replaceAll(RegExp('[=/+]'), '');
    return "3wcdsyqTQ7tZITlCYfjNpEusyI4XFXzE";
  }

  setParameter(String name, String value) {
    parameters[name] = value;
  }

  String getParameter(String name) {
    return parameters[name];
  }

  Map<String, dynamic> getParameters() {
    return parameters;
  }

  void removeParameter(String name) {
    parameters.remove(name);
  }

  String getSignableParameters() {
    return parameters.keys.map((key) => '$key=${parameters[key]}').join('&');
  }

  String getSignatureBaseString() {
    var url = json.encode(httpUrl.toString());
    var sigString = json.encode(getSignableParameters());
    var signatureBaseString = "${httpMethod.toUpperCase()}&$url&$sigString";
    return signatureBaseString;
  }

  String getNormalizedHttpMethod() {
    return httpMethod.toUpperCase();
  }

  String getNormalizedHttpUrl() {
    Uri parts = Uri.parse(httpUrl);
    String scheme = parts.scheme.toLowerCase();
    String host = parts.host.toLowerCase();
    String path = parts.path;
    return "$scheme://$host$path";
  }

  String toUrl() {
    var postData = toPostdata();
    var out = getNormalizedHttpUrl();
    if (postData.isNotEmpty) {
      out += '?' + postData;
    }
    return out;
  }

  String toPostdata() {
    var data = getSignableParameters();
    return data;
  }

  String toHeader() {
    var items = parameters.keys.map((k) => "$k=${parameters[k]}").toList();
    items.sort();

    return items.join("&");
  }

  // implement __toString
  @override
  String toString() {
    return toUrl();
  }

  signRequest(
      SignatureMethod signatureMethod, Consumer consumer, Token? token) {
    setParameter('oauth_signature_method', signatureMethod.getName());
    String signature = buildSignature(signatureMethod, consumer, token);
    setParameter('oauth_signature', signature);
  }

  String buildSignature(
      SignatureMethod signatureMethod, Consumer consumer, Token? token) {
    return signatureMethod.buildSignature(this, consumer, token);
  }
}
