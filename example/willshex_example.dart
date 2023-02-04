import 'dart:async';
import 'dart:math';

import 'package:willshex/src/storage/impl/helper/indexhelper.dart';
import 'package:willshex/src/storage/impl/index/key.dart';
import 'package:willshex/src/storage/impl/storageimpl.dart';
import 'package:willshex/src/utility/logging.dart';
import 'package:willshex/willshex.dart';
import 'package:logging/logging.dart';

Future<String> path() {
  return Future<String>.value("./data");
}

Data data() => Data();
const Class<Data> CLASS_DATA_TYPE = Class<Data>("Data", data);

class Data extends DataType {
  Data({int? id})
      : super(
          sc: CLASS_DATA_TYPE,
          id: id,
        ) {}
}

final Logger _log = Logger("main");
final Random random = Random(1);

Future<void> main() async {
  setupLogging();

  Storage awesome = StorageProvider.provide(path).cache(false);

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
