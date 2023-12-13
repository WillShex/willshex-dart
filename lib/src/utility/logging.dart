import 'package:logging/logging.dart';
import 'package:universal_file/universal_file.dart';

void setupLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord record) {
    writeLn(
      record.level == Level.SEVERE || record.level == Level.WARNING
          ? stderr
          : stdout,
      level: record.level,
      time: record.time,
      message: record.message,
    );
  });
}

void writeLn(
  Stdout out, {
  required Level level,
  required DateTime time,
  required String message,
}) {
  out.writeln(
      "${level.name}: ${time}: ${level == Level.SHOUT ? message.toUpperCase() : message}");
}
