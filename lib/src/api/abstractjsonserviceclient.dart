import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'request.dart';
import 'response.dart';

abstract class AbstractJsonServiceClient {
  String url;

  AbstractJsonServiceClient({this.url});

  T parseResponse<T extends Response>(http.Response response, T create()) {
    String responseText;
    T output;
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        (responseText = response.body) != null &&
        "" != responseText &&
        "null" != responseText.toLowerCase()) {
      output = create()..fromString(responseText);

      print("Recieved [$responseText] to [${response.request.url}");
    } else if (response.statusCode >= 400)
      throw HttpException("$response.statusCode: $response.reasonPhrase",
          uri: response.request.url);

    return output;
  }

  Future<http.Response> sendRequest<T>(String action, Request input) async {
    String requestData = "action=$action&request=";
    requestData += Uri.encodeComponent(input.toString());

    print("Sending [$input] to [$url] with action [$action]");

    return await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: requestData);
  }

  void onCallStart<T extends Response>(
      AbstractJsonServiceClient origin, String callName, Request input) {}

  void onCallSuccess(AbstractJsonServiceClient origin, String callName,
      Request input, Response output) {}

  void onCallFailure(AbstractJsonServiceClient origin, String callName,
      Request input, Exception caught) {}
}
