import 'dart:async';

import 'package:willshex/willshex.dart';

Future<String> path() {
  return Future.value("./data");
}

const Class<DataType> CLASS_DATA_TYPE = Class(DataType);

main() async {
  var awesome = StorageProvider.provide(path).cache(true);

  awesome[CLASS_DATA_TYPE] = () => DataType();

  await awesome.save.entity(DataType(id: 1));
  DataType loaded = await awesome.load.type(CLASS_DATA_TYPE).first;
  print('awesome: ${loaded?.id}');
}
