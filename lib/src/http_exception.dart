import 'package:universal_file/universal_file.dart';

class HttpException implements IOException {
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
