class Util {
  urlencodeRfc3986(input) {
    String output = '';
    // if in input in array
    if (input is List) {
      for (int i = 0; i < input.length; i++) {
        output += urlencodeRfc3986(input[i]);
        if (i < input.length - 1) {
          output += '&';
        }
      }
      return output;
    }
  }

  String buildHttpQuery(List<dynamic> params) {
    String output = '';
    if (params.isEmpty) {
      return '';
    }

    params.sort((a, b) => a.toString().compareTo(b.toString()));
    for (int i = 0; i < params.length; i++) {
      output += urlencodeRfc3986(params[i]);
      if (i < params.length - 1) {
        output += '&';
      }
    }
    return output;
  }
}
