import 'dart:async';
import 'dart:io';

import 'package:willshex/willshex.dart';
import 'package:test/test.dart';

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
  group("Storage Tests", () {
    Storage cached, uncached;

    Future<String> path() {
      return Future.value("./data");
    }

    setUpAll(() async {
      new Directory(await path()).delete(recursive: true);

      cached = StorageProvider.provide(path).cache(true)
        ..register(T1, () => Test1Type())
        ..register(T2, () => Test2Type())
        ..register(T3, () => Test3Type());

      uncached = StorageProvider.provide(path).cache(false)
        ..register(T4, () => Test4Type());
    });

    test("Store data with set id", () async {
      expect(await cached.save().entity(Test1Type(id: 1)).now(), 1);
      expect(await cached.save().entity(Test1Type(id: 4)).now(), 4);
    });

    test("Store data with unset ids (auto-increment)", () async {
      expect(await cached.save().entity(Test2Type()).now(), 1);
      expect(await cached.save().entity(Test2Type()).now(), 2);
    });

    test("Read object (cached)", () async {
      final Test3Type saved = Test3Type();
      expect(await cached.save().entity(saved).now(), 1);
      expect(await cached.load().id(T3, 1).now(), saved);
    });

    test("Read object (uncached)", () async {
      final Test4Type saved = Test4Type()..id = 3;
      expect(await uncached.save().entity(saved).now(), 3);
      expect((await uncached.load().type(T4).id(1).now()).id, saved.id);
    });
  });
}
