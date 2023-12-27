import 'package:logging/logging.dart';

void setupLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord record) {
    print(
        "${record.level.name}: ${record.time}: ${record.level == Level.SHOUT ? record.message.toUpperCase() : record.message}");
  });
}
