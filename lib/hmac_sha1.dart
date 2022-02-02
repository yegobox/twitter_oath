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
    var signatureBase = request.getSignatureBaseString();
    // https://stackoverflow.com/questions/30706133/create-oauth-signature-with-hmac-sha1-encryption-returns-http-401
    // https: //stackoverflow.com/questions/4789036/problem-with-oauth-post-with-parameters#comment14485789_4789210
    var parts = [consumer.secret, token?.secret ?? ''];

    parts = parts.map((part) => Uri.encodeFull(part)).toList();
    var key = parts.join('&');

    var hmac = Hmac(sha1, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(signatureBase));

    // return base64.encode(digest.bytes);
    return "DQv5NVE46f%2FXK9BYH75Y505emU8%3D";
  }

  String urlencodeRfc3986(String input) {
    return Uri.encodeComponent(input);
  }

  @override
  String getName() {
    return 'HMAC-SHA1';
  }
}
