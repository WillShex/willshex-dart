import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:willshex/src/api/request.dart';
import 'package:willshex/src/api/response.dart';
import 'package:willshex/src/http_exception.dart';
import 'package:willshex/src/utility/typedef.dart';

typedef void SuccessCallback<S extends Request, T extends Response>(
    S input, T? output);
typedef void FailureCallback<T extends Request>(T input, Exception caught);

abstract class AbstractJsonServiceClient {
  static final Logger _log = Logger("AbstractJsonServiceClient");
  final String? url;

  AbstractJsonServiceClient({this.url});

  Future<void> call<S extends Request, T extends Response>(
      String callName,
      S input,
      SuccessCallback<S, T>? onSuccess,
      FailureCallback<S>? onFailure,
      CreateFromStringFunction<T> creator) async {
    try {
      onCallStart(this, callName, input);
      http.Response response = await sendRequest(callName, input);
      try {
        T? output = parseResponse(response, creator);
        if (onSuccess != null) {
          onSuccess(input, output);
        }
        onCallSuccess(this, callName, input, output);
      } on Exception catch (e) {
        if (onFailure != null) {
          onFailure(input, e);
        }
        onCallFailure(this, callName, input, e);
      }
    } on Exception catch (e) {
      if (onFailure != null) {
        onFailure(input, e);
      }
      onCallFailure(this, callName, input, e);
    }
  }

  T? parseResponse<T extends Response>(
      http.Response response, CreateFromStringFunction<T> create) {
    String responseText;
    T? output;
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        (responseText = response.body).isNotEmpty &&
        "null" != responseText.toLowerCase()) {
      output = create(responseText);

      _log.info(
          "Recieved body [$responseText] and status [${response.statusCode}] to [${response.request?.url}");
    } else if (response.statusCode >= 400) {
      _log.info(
          "Recieved status [${response.statusCode}] to [${response.request?.url}");

      throw HttpException("${response.statusCode}: ${response.reasonPhrase}",
          uri: response.request?.url);
    }

    return output;
  }

  Future<http.Response> sendRequest<T>(String action, Request input) async {
    String requestData = "action=$action&request=";
    requestData += Uri.encodeComponent(input.toString());

    _log.info("Sending [$input] to [$url] with action [$action]");

    return await http.post(Uri.parse(url!),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: requestData);
  }

  void onCallStart<T extends Response>(
      AbstractJsonServiceClient origin, String callName, Request input) {}

  void onCallSuccess<T extends Response>(AbstractJsonServiceClient origin,
      String callName, Request input, T? output) {}

  void onCallFailure(AbstractJsonServiceClient origin, String callName,
      Request input, Exception caught) {}
}
