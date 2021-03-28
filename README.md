# willshex

All the base classes usually used for calling willshex APIs plus the storage library for local persistence.

## Usage

A simple usage example:

    import 'dart:async';

    import 'package:willshex/willshex.dart';

    Future<String> path() {
      return Future.value(".");
    }

    const Class<DataType> CLASS_DATA_TYPE = const Class(DataType);
    const Class<DataType> CLASS_DATA_TYPE_2 = const Class(DataType2);

    main() async {
      var awesome = StorageProvider.provide(path).cache(true)
        ..register(CLASS_DATA_TYPE, () => DataType());
      awesome.register(CLASS_DATA_TYPE_2, () => DataType2());
      await awesome.save().entity(DataType(id: 1));
      DataType loaded = await awesome.load().type(CLASS_DATA_TYPE).first().now();
      _log.info('awesome: ${loaded.id}');
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/WillShex/willshex-dart/issues
