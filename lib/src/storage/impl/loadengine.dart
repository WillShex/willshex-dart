//
//  LoadEngine.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/storage/class.dart';
import 'package:willshex/src/storage/cmd/loader.dart';
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/utility/typedef.dart';

import 'loaderimpl.dart';
import 'storageimpl.dart';
///
/// @author William Shakour (billy1380)
///
class LoadEngine {
  StorageImpl<Storage> store;
  LoaderImpl<Loader> loader;

  LoadEngine(this.loader, this.store);

  Future<Map<int, T>> load<T extends DataType>(
      final Class<T> type, final Iterable<int> ids) {
    return Future<Map<int, T>>(() async {
      final Map<int, T> loaded = <int, T>{};
      File recordFileHandle;
      T entity;
      Directory folder = await store.ensureFolder(type.getSimpleName());
      for (int id in ids) {
        entity = null;

        if (store.useCache) {
          entity = store.ensureCacheType(type)[id];
        }

        if (entity == null) {
          recordFileHandle = File("${folder.path}/${id.toString()}.json");

          if (await recordFileHandle.exists()) {
            final CreateFunction<T> creator = store.creators[type];

            if (creator == null) {
              throw Exception(
                  "Looks like ${type.getName()} was not registered");
            }

            (entity = creator())
                .fromString(await recordFileHandle.readAsString());

            if (entity.id != null) {
              if (store.useCache) {
                store.ensureCacheType(type)[id] = entity;
              }
            }
          }
        }

        if (entity != null && entity.id != null) {
          loaded[id] = entity;
        }
      }

      return loaded;
    });
  }
}
