//
//  DeleterImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import 'package:willshex/src/storage/cmd/deleter.dart';
import 'package:willshex/src/storage/cmd/deletetype.dart';
import 'package:willshex/src/storage/impl/deletetypeimpl.dart';
import 'package:willshex/src/storage/impl/storageimpl.dart';
import 'package:willshex/willshex.dart';

///
/// @author William Shakour (billy1380)
///
class DeleterImpl implements Deleter {
  StorageImpl<Storage> store;

  DeleterImpl(this.store);

  @override
  DeleteType type<T extends DataType>(Class<T> type) {
    return DeleteTypeImpl(this, type);
  }

  Future<void> ids<T extends DataType>(Class<T> type, Iterable<int> ids) {
    return store.createWriteEngine().delete(type, ids);
  }

  @override
  Future<void> entity<T extends DataType>(T entity) {
    return entities(<T>[entity]);
  }

  @override
  Future<void> entities<T extends DataType>(Iterable<T> entities) {
    List<int> ids = <int>[];
    Class<T>? type;

    for (T t in entities) {
      if (type == null) {
        type = Class(t.runtimeType);
      }

      if (t.id != null) {
        ids.add(t.id!);
      }
    }

    return store.createWriteEngine().delete(type!, ids);
  }
}
