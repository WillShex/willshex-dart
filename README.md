# willshex

All the base classes usually used for calling willshex apis plus the storage library for local persistence.

## Usage

A simple usage example:

    import 'dart:async';

    import 'package:willshex/willshex.dart';

    Future<String> path() {
      return Future.value(".");
    }

    Class<DataType> CLASS_DATA_TYPE = new Class(DataType);

    main() async {
      var awesome = StorageProvider.provide(path).cache(true)
        ..register(CLASS_DATA_TYPE, () => new DataType());
      await awesome.save().entity(new DataType(id: 1));
      DataType loaded = await awesome.load().type(CLASS_DATA_TYPE).first().now();
      print('awesome: ${loaded.id}');
    }


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://gihub.com/willshex/willshex-dart
