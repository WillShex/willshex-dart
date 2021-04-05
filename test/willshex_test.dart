import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:willshex/willshex.dart';

class Test1Type extends DataType {
  Test1Type({int id, DateTime created, bool deleted})
      : super(id: id, created: created, deleted: deleted);
}

class Test2Type extends DataType {}

class Test3Type extends DataType {}

class Test4Type extends DataType {}

const Class<Test1Type> T1 = Class<Test1Type>(Test1Type);
const Class<Test2Type> T2 = Class<Test2Type>(Test2Type);
const Class<Test3Type> T3 = Class<Test3Type>(Test3Type);
const Class<Test4Type> T4 = Class<Test4Type>(Test4Type);

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Logger log = Logger("test:main");

  group("Storage Tests", () {
    Storage cached, uncached;

    Future<String> path() => Future.value("./data");

    setUpAll(() async {
      Directory(await path()).delete(
        recursive: true,
      );

      cached = StorageProvider.provide(path).cache(true);

      cached.register(T1, () => Test1Type());
      cached.register(T2, () => Test2Type());
      cached.register(T3, () => Test3Type());

      uncached = StorageProvider.provide(path).cache(false);
      uncached.register(T4, () => Test4Type());
    });

    test("Store data with set id", () async {
      expect(await cached.save.entity(Test1Type(id: 1)), 1);
      expect(await cached.save.entity(Test1Type(id: 4)), 4);
    });

    test("Store data with unset ids (auto-increment)", () async {
      expect(await cached.save.entity(Test2Type()), 1);
      expect(await cached.save.entity(Test2Type()), 2);
    });

    test("Read object (cached)", () async {
      final Test3Type saved = Test3Type();
      expect(await cached.save.entity(saved), 1);
      expect(await cached.load.id(T3, 1), saved);
    });

    test("Read object (uncached)", () async {
      int id = 3;
      final Test4Type saved = Test4Type()..id = id;
      expect(await uncached.save.entity(saved), id);

      Test4Type loaded;
      expect((loaded = await uncached.load.type(T4).id(id)).id, saved.id);
      expect(false, saved == loaded);
    });
  });
}
