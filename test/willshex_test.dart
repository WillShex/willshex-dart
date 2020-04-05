import 'dart:async';

import 'package:willshex/willshex.dart';
import 'package:test/test.dart';

class TestType extends DataType {
  TestType({int id, DateTime created, bool deleted})
      : super(id: id, created: created, deleted: deleted);
}

void main() {
  group('A group of tests', () {
    Storage awesome;

    Future<String> path() {
      return Future.value("./data");
    }

    setUp(() {
      awesome = StorageProvider.provide(path).cache(true)
        ..register(Class<TestType>(TestType), () => TestType());
    });

    test('First Test', () async {
      expect(await awesome.save().entity(TestType(id: 1)).now(), 1);
    });
  });
}
