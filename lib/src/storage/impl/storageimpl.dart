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
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/storage/cmd/saver.dart';
import 'package:willshex/src/storage/class.dart';
import 'package:willshex/src/storage/cmd/deleter.dart';
import 'package:willshex/src/storage/cmd/loader.dart';
import 'package:willshex/src/storage/cmd/compactor.dart';

import 'loaderimpl.dart';
import 'saverimpl.dart';
import 'deleterimpl.dart';
import 'writeengine.dart';
import 'compactorimpl.dart';

typedef T CreateFunction<T>();
typedef Future<String> PathProvider();

///
/// @author William Shakour (billy1380)
///
class StorageImpl<S extends Storage> implements Storage {
  Directory _storageHandle;
  PathProvider _pathProvider;
  bool useCache;
  Map<String, Map<int, DataType>> c;
  Map<Class<DataType>, CreateFunction> creators;

  StorageImpl(this._pathProvider);

  Future<Directory> get folder async {
    if (_storageHandle == null) {
      String path = await _pathProvider();
      _storageHandle = new Directory("$path");
      if (await _storageHandle.exists()) {
        // do nothing
      } else {
        await _storageHandle.create(recursive: true);
      }
    }

    return _storageHandle;
  }

  Future<Directory> ensureFolder(String name) async {
    Directory parent = await this.folder;
    Directory folder = new Directory("${parent.path}/$name");

    if (await folder.exists()) {
      // do nothing
    } else {
      await folder.create(recursive: true);
    }

    return folder;
  }

  @override
  Loader load() {
    return new LoaderImpl<Loader>(this);
  }

  @override
  Saver save() {
    return new SaverImpl(this);
  }

  @override
  Deleter delete() {
    return new DeleterImpl(this);
  }

  @override
  Storage cache(bool value) {
    useCache = value;
    return this;
  }

  @override
  Compactor compact() {
    return new CompactorImpl(this);
  }

  @override
  void register<T extends DataType>(Class<T> type, CreateFunction create) {
    ensureCreators()[type] = create;
  }

  Map<Class<DataType>, Function> ensureCreators() {
    if (creators == null) {
      creators = <Class<DataType>, CreateFunction>{};
    }

    return creators;
  }

  Map<int, DataType> ensureCacheType<T extends DataType>(Class<T> type) {
    if (!ensureCache().containsKey(type.getName())) {
      ensureCache()[type.getName()] = <int, T>{};
    }

    return ensureCache()[type.getName()];
  }

  Map<String, Map<int, DataType>> ensureCache() {
    if (c == null) {
      c = <String, Map<int, DataType>>{};
    }

    return c;
  }

  WriteEngine createWriteEngine() {
    return new WriteEngine(this);
  }
}
