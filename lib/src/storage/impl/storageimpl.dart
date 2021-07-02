//
//  StorageImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/storage/class.dart';
import 'package:willshex/src/storage/cmd/compactor.dart';
import 'package:willshex/src/storage/cmd/deleter.dart';
import 'package:willshex/src/storage/cmd/loader.dart';
import 'package:willshex/src/storage/cmd/saver.dart';
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/utility/typedef.dart';

import 'compactorimpl.dart';
import 'deleterimpl.dart';
import 'loaderimpl.dart';
import 'saverimpl.dart';
import 'writeengine.dart';

typedef Future<String> PathProvider();

///
/// @author William Shakour (billy1380)
///
class StorageImpl<S extends Storage> extends Storage {
  Directory? _storageHandle;
  PathProvider _pathProvider;
  bool? _useCache;
  Map<Class<DataType>, Map<int, DataType>>? c;
  Map<Class<DataType>, CreateFunction<DataType>>? creators;

  bool get useCache {
    return _useCache ?? false;
  }

  set useCache(bool value) => _useCache = value;

  StorageImpl(this._pathProvider);

  Future<Directory> get folder async {
    if (_storageHandle == null) {
      String path = await _pathProvider();
      _storageHandle = Directory("$path");
      if (await _storageHandle!.exists()) {
        // do nothing
      } else {
        await _storageHandle!.create(recursive: true);
      }
    }

    return _storageHandle!;
  }

  Future<Directory> ensureFolder(String name) async {
    Directory parent = await this.folder;
    Directory folder = Directory("${parent.path}/$name");

    if (await folder.exists()) {
      // do nothing
    } else {
      await folder.create(recursive: true);
    }

    return folder;
  }

  @override
  Loader get load {
    return LoaderImpl<Loader>(this);
  }

  @override
  Saver get save {
    return SaverImpl(this);
  }

  @override
  Deleter get delete {
    return DeleterImpl(this);
  }

  @override
  Storage cache(bool value) {
    useCache = value;
    return this;
  }

  @override
  Compactor get compact {
    return CompactorImpl(this);
  }

  @override
  void register<T extends DataType>(Class<T> type, CreateFunction<T> create) {
    ensureCreators()[type] = create;
  }

  Map<Class, CreateFunction<DataType>> ensureCreators() {
    if (creators == null) {
      creators = <Class<DataType>, CreateFunction<DataType>>{};
    }

    return creators!;
  }

  Map<int, T> ensureCacheType<T extends DataType>(Class<T> type) {
    if (!ensureCache<T>().containsKey(type)) {
      ensureCache<T>()[type] = <int, T>{};
    }

    return ensureCache<T>()[type]!;
  }

  Map<Class<T>, Map<int, T>> ensureCache<T extends DataType>() {
    if (c == null) {
      c = <Class<DataType>, Map<int, DataType>>{};
    }

    return c!.cast();
  }

  WriteEngine createWriteEngine() {
    return WriteEngine(this);
  }
}
