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
      return new Future.value("./data");
    }

    setUp(() {
      awesome = StorageProvider.provide(path).cache(true)
        ..register(new Class<TestType>(TestType), () => new TestType());
    });

    test('First Test', () async {
      expect(await awesome.save().entity(new TestType(id: 1)).now(), 1);
    });
  });
}
