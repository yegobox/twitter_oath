class Response {
  //  string|null API path from the most recent request
  String apiPath = "";
  // int HTTP status code from the most recent request
  int httpCode = 0;
  // array HTTP headers from the most recent request
  List<dynamic> headers = [];
  // array|object Response body from the most recent request
  dynamic body;
  //  HTTP headers from the most recent request that start with X
  Map<String, String> xHeaders = {};

  String setApiPath(String path) {
    return apiPath = path;
  }

  // getApiPath
  String getApiPath() {
    return apiPath;
  }

  // setBody
  dynamic setBody(dynamic body) {
    return this.body = body;
  }

  // getBody
  dynamic getBody() {
    return body;
  }

  // setHttpCode
  int setHttpCode(int code) {
    return httpCode = code;
  }

  // getHttpCode
  int getHttpCode() {
    return httpCode;
  }

  // setHeaders
  dynamic setHeaders(List<dynamic> heads) {
    return headers = heads;
  }

  // getsHeaders
  List<dynamic> getHeaders() {
    return headers;
  }

  // setXHeaders
  Map<String, String> setXHeaders(Map<String, String> xHeaders) {
    return xHeaders = xHeaders;
  }

  // getXHeaders
  Map<String, String> getXHeaders() {
    return xHeaders;
  }
}
