import 'consumer.dart';
import 'request.dart';
import 'token.dart';

abstract class SignatureMethod {
  String getName();

  String buildSignature(Request request, Consumer consumer, Token? token);

  bool checkSignature(request, consumer, token, signature) {
    String built = buildSignature(request, consumer, token);
    if (built.isEmpty || signature == null) {
      return false;
    }
    // Avoid a timing leak with a (hopefully) time insensitive compare
    int result = 0;
    for (int i = 0; i < built.length; i++) {
      result |= built.codeUnitAt(i) ^ signature.codeUnitAt(i);
    }
    return result == 0;
  }
}
