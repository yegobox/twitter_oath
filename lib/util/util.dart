class Util {
  static urlencodeRfc3986(input) {
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

  static String buildHttpQuery(Map<String, dynamic> params) {
    String output = '';
    if (params.isEmpty) {
      return '';
    }

    // Urlencode both keys and values
    // $keys = Util::urlencodeRfc3986(array_keys($params));
    var keys = params.keys.map((key) => urlencodeRfc3986(key)).toList();
    // $values = Util::urlencodeRfc3986(array_values($params));
    var values = params.values.map((value) => urlencodeRfc3986(value)).toList();
    // $params = array_combine($keys, $values);
    List<dynamic> pp = List.generate(keys.length, (i) => [keys[i], values[i]]);

    // Parameters are sorted by name, using lexicographical byte value ordering.
    // Ref: Spec: 9.1.1 (1)
    // uksort($params, 'strcmp');
    // pp.sort((a, b) => a[0].compareTo(b[0]));

    var pairs = <String>[];

    for (var i = 0; i < pp.length; i++) {
      var parameter = pp[i][0];
      var value = pp[i][1];
      if (value is List) {
        // value.sort((a, b) => a.compareTo(b));
        // for (var j = 0; j < value.length; j++) {
        //   pairs.add('$parameter=$value[$j]');
        // }
      } else {
        pairs.add('$parameter=$value');
      }
    }
    // For each parameter, the name is separated from the corresponding value by an '=' character (ASCII code 61)
    // Each name-value pair is separated by an '&' character (ASCII code 38)
    // return implode('&', $pairs);
    pp.sort((a, b) => a.toString().compareTo(b.toString()));

    for (int i = 0; i < params.length; i++) {
      output += urlencodeRfc3986(params[i]);
      if (i < params.length - 1) {
        output += '&';
      }
    }
    return output;
  }
}
