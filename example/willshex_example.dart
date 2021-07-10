import 'dart:async';
import 'dart:math';

import 'package:willshex/src/storage/impl/helper/indexhelper.dart';
import 'package:willshex/src/storage/impl/index/key.dart';
import 'package:willshex/src/storage/impl/storageimpl.dart';
import 'package:willshex/willshex.dart';
import 'package:logging/logging.dart';

Future<String> path() {
  return Future.value("./data");
}

const Class<Data> CLASS_DATA_TYPE = Class(Data, "Data");

class Data extends DataType<Data> {
  Data({int? id})
      : super(
          sc: CLASS_DATA_TYPE,
          id: id,
        ) {}
}

final Logger _log = Logger("main");
final Random random = Random(1);

main() async {
  _setupLogging();

  Storage awesome = StorageProvider.provide(path).cache(false);

  awesome.register(
    CLASS_DATA_TYPE,
    () => Data(),
  );

  Key key = Key.createKey(100);

  _log.info("Creating entities");
  for (int i = 0; i < 1000; i++) {
    DataType e = Data(id: random.nextInt(Key.max));
    await awesome.save.entity(e);
    key.add(e.id!);
  }

  // DataType loaded = await awesome.load.type(CLASS_DATA_TYPE).first;
  // _log.info('awesome: ${loaded?.id}');

  _log.info("Saving index");
  await IndexHelper.saveKey(
    storage: awesome as StorageImpl<Storage>,
    key: key,
    type: CLASS_DATA_TYPE,
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print("${record.level.name}: ${record.time}: ${record.message}");
  });
}
