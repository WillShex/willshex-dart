import 'package:willshex/src/io_exception.dart';

class HttpException implements IoException {
  final String message;
  final Uri? uri;

  const HttpException(
    this.message, {
    this.uri,
  });

  String toString() {
    StringBuffer b = StringBuffer()
      ..write("HttpException: ")
      ..write(message);

    Uri? uri = this.uri;
    if (uri != null) {
      b.write(", uri = $uri");
    }

    return b.toString();
  }
}
