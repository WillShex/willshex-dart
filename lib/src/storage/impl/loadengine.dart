//
//  LoadEngine.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:io';

import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/storage/result.dart';
import 'package:willshex/src/storage/class.dart';
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/storage/cmd/loader.dart';

import 'storageimpl.dart';
import 'loaderimpl.dart';

///
/// @author William Shakour (billy1380)
///
class LoadEngine {
  StorageImpl<Storage> store;
  LoaderImpl<Loader> loader;

  LoadEngine(this.loader, this.store);

  Result<Map<int, T>> load<T extends DataType>(
      final Class<T> type, final Iterable<int> ids) {
    return Result<Map<int, T>>(() async {
      final Map<int, T> loaded = <int, T>{};
      File recordFileHandle;
      T entity;
      Directory folder = await store.ensureFolder(type.getSimpleName());
      for (int id in ids) {
        recordFileHandle = File("${folder.path}/${id.toString()}.json");

        if (await recordFileHandle.exists()) {
          (entity = store.creators[type]())
              .fromString(await recordFileHandle.readAsString());
          if (entity.id != null) {
            loaded[id] = entity;
          }
        }
      }

      return loaded;
    });
  }
}
