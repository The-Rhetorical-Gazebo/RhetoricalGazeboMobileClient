String querystring(Map<String, String> params) {
  var ret = "";
  for (String key in params.keys) {
    var param = params[key]!;
    if (key == 'q') {
      param = Uri.encodeQueryComponent(param);
    }
    ret += key + '=' + param + "&";
  }
  ;
  print("Query: $ret");
  return ret.substring(0, ret.length - 1);
}
