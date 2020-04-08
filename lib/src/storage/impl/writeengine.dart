//
//  WriteEngine.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import '../../datatype.dart';
import '../result.dart';
import 'storageimpl.dart';
import '../class.dart';
import '../storage.dart';

///
/// @author William Shakour (billy1380)
///
class WriteEngine {
  StorageImpl<Storage> store;

  WriteEngine(this.store);

  Result<Map<int, T>> save<T extends DataType>(final Iterable<T> entities) {
    return Result<Map<int, T>>(() async {
      Class<T> type;
      Map<int, T> saved = <int, T>{};

      List<T> insert;
      List<T> update;
      for (T entity in entities) {
        if (type == null) {
          type = Class(entity.runtimeType);
        }

        if (entity.id == null) {
          if (insert == null) {
            insert = <T>[];
          }
          insert.add(entity);
        } else {
          if (update == null) {
            update = <T>[];
          }
          update.add(entity);
        }
      }

      if (insert != null) {
        saved.addAll(await _insert(type, insert));
      }

      if (update != null) {
        saved.addAll(await _update(type, update));
      }
      return saved;
    });
  }

  Result<Null> delete<T>(final Class<T> type, final Iterable<int> ids) {
    return Result<Null>(() async {
      File recordFileHandle;
      Directory folder =
          type == null ? null : await store.ensureFolder(type.getSimpleName());
      for (int id in ids) {
        recordFileHandle = File("${folder.path}/${id.toString()}.json");
        if (await recordFileHandle.exists()) {
          await recordFileHandle.delete();
        }

        if (store.useCache) {
          store.ensureCache().remove(id);
        }
      }
    });
  }

  Result<Null> compact<T extends DataType>(Class<T> type) {
    return Result<Null>(() async {});
  }

  Future<int> _nextAutoIncrement(Class<DataType> type, int increment) async {
    return _incrementCounter(type, "autoinc", increment);
  }

  Future<int> getAutoIncrement(Class<DataType> type) {
    return _getCounter(type, "autoinc");
  }

  Future<Null> _setAutoIncrement(Class<DataType> type, int value) async {
    await _setCounter(type, "autoinc", value);
  }

  Future<int> _incrementCounter(
      Class<DataType> type, String name, int increment) async {
    int next = await _getCounter(type, name) + increment;
    await _setCounter(type, name, next);
    return next;
  }

  Future<Null> _setCounter(Class<DataType> type, String name, int value) async {
    Directory folder = await store.ensureFolder(type.getSimpleName());
    File counterFileHandle = File("${folder.path}/.$name");
    await counterFileHandle.writeAsString(value.toString());
  }

  Future<int> _getCounter(Class<DataType> type, String name) async {
    int counter;
    Directory folder = await store.ensureFolder(type.getSimpleName());
    File counterFileHandle = File("${folder.path}/.$name");
    if (await counterFileHandle.exists()) {
      counter = int.parse(await counterFileHandle.readAsString());
    } else {
      counter = 1;
    }
    return counter;
  }

  Future<Map<int, T>> _insert<T extends DataType>(
      Class<T> type, List<T> entities) async {
    Map<int, T> inserted = <int, T>{};
    Directory folder = await store.ensureFolder(type.getSimpleName());
    int id = await _nextAutoIncrement(type, entities.length);
    id -= entities.length;
    for (T entity in entities) {
      entity.id = id;
      await File("${folder.path}/${id.toString()}.json")
          .writeAsString(entity.toString());
      inserted[id] = entity;

      if (store.useCache) {
        store.ensureCacheType(type)[id] = entity;
      }

      id++;
    }

    return inserted;
  }

  Future<Map<int, T>> _update<T extends DataType>(
      Class<T> type, List<T> entities) async {
    Map<int, T> updated = <int, T>{};
    int autoInc;
    Directory folder = await store.ensureFolder(type.getSimpleName());
    for (T entity in entities) {
      autoInc = await getAutoIncrement(type);
      if (entity.id > autoInc) {
        await _setAutoIncrement(type, autoInc = entity.id);
      }

      await File("${folder.path}/${entity.id.toString()}.json")
          .writeAsString(entity.toString());
      updated[entity.id] = entity;

      if (store.useCache) {
        store.ensureCacheType(type)[entity.id] = entity;
      }
    }

    return updated;
  }
}
