import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:url_launcher/url_launcher.dart';

class TwitterOath {
  final oauth1.Platform platform = oauth1.Platform(
      'https://api.twitter.com/oauth/request_token', // temporary credentials request
      'https://api.twitter.com/oauth/authorize', // resource owner authorization
      'https://api.twitter.com/oauth/access_token', // token credentials request
      oauth1.SignatureMethods.hmacSha1 // signature method
      );
  final String apiKey;
  final String apiSecret;
  final String? callbackUrl;
  late oauth1.ClientCredentials clientCredentials;

  TwitterOath(
      {this.callbackUrl, required this.apiKey, required this.apiSecret}) {
    clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);
  }
  auth() async {
    final oauth1.Authorization auth =
        oauth1.Authorization(clientCredentials, platform);
    oauth1.AuthorizationResponse res =
        await auth.requestTemporaryCredentials(callbackUrl ?? 'oob');
    await launch(auth.getResourceOwnerAuthorizationURI(res.credentials.token));
  }
}
