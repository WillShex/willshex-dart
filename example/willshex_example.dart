import 'dart:async';

import 'package:willshex/willshex.dart';
import 'package:logging/logging.dart';

Future<String> path() {
  return Future.value("./data");
}

const Class<DataType> CLASS_DATA_TYPE = Class(DataType);

final Logger _log = Logger("main");

main() async {
  _setupLogging();

  var awesome = StorageProvider.provide(path).cache(true);

  awesome[CLASS_DATA_TYPE] = () => DataType();

  await awesome.save.entity(DataType(id: 1));
  DataType loaded = await awesome.load.type(CLASS_DATA_TYPE).first;
  _log.info('awesome: ${loaded?.id}');
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print("${record.level.name}: ${record.time}: ${record.message}");
  });
}
