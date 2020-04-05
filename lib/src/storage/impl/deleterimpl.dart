//
//  DeleterImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../cmd/deleter.dart';
import 'storageimpl.dart';
import '../class.dart';
import '../cmd/deletetype.dart';
import '../../datatype.dart';
import 'deletetypeimpl.dart';
import '../storage.dart';

///
/// @author William Shakour (billy1380)
///
class DeleterImpl implements Deleter {
  StorageImpl<Storage> store;

  DeleterImpl(this.store);

  @override
  DeleteType type(Class<DataType> type) {
    return DeleteTypeImpl(this, type);
  }

  Result<Null> ids(Class<dynamic> type, Iterable<int> ids) {
    return store.createWriteEngine().delete(type, ids);
  }

  @override
  Result<Null> entity<T extends DataType>(T entity) {
    return entities(<T>[entity]);
  }

  @override
  Result<Null> entities<T extends DataType>(Iterable<T> entities) {
    List<int> ids = <int>[];
    Class<DataType> type;

    for (T t in entities) {
      if (type == null) {
        type = Class(t.runtimeType);
      }

      if (t.id != null) {
        ids.add(t.id);
      }
    }

    return store.createWriteEngine().delete(type, ids);
  }
}
