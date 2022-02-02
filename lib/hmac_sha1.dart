import 'package:twitter_oauth/request.dart';
import 'package:twitter_oauth/signature_method.dart';
import 'dart:convert';
import 'consumer.dart';
import 'token.dart';
import 'package:crypto/crypto.dart';

class HmacSha1 extends SignatureMethod {
  // build signature base string that works with twitter
  @override
  String buildSignature(Request request, Consumer consumer, Token? token) {
    // var baseString = request.httpMethod.toUpperCase() +
    //     '&' +
    //     Uri.encodeFull(request.httpUrl) +
    //     '&' +
    //     Uri.encodeFull(buildBaseString(request, consumer, token));
    // var key = Uri.encodeFull(consumer.secret) + '&';
    // if (token != null) {
    //   key += Uri.encodeFull(token.secret);
    // }
    // var hmac = Hmac(sha1, utf8.encode(key));
    // var digest = hmac.convert(utf8.encode(baseString));
    // return base64.encode(digest.bytes);
    // TODOwork on signature method later for now return this
    return "2%2FZcgPihNuYqmmvMto6XiHVee8Y%3D";
  }

  buildBaseString(Request request, Consumer consumer, Token? token) {
    var baseString = '';
    // Map<String, dynamic> parameters = request.parameters;

    return baseString;
  }

  String urlencodeRfc3986(String input) {
    return Uri.encodeComponent(input);
  }

  @override
  String getName() {
    return 'HMAC-SHA1';
  }
}
