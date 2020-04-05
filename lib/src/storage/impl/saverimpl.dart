//
//  SaverImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../cmd/saver.dart';
import 'storageimpl.dart';
import '../../datatype.dart';
import '../storage.dart';

///
/// @author William Shakour (billy1380)
///
class SaverImpl implements Saver {
  StorageImpl<Storage> store;

  SaverImpl(this.store);

  @override
  Result<int> entity<E extends DataType>(E entity) {
    return Result<int>(() async {
      Map<int, E> saved = await entities(<E>[entity]).now();
      return saved.values.length > 0 ? saved.values.first.id : null;
    });
  }

  @override
  Result<Map<int, E>> entities<E extends DataType>(Iterable<E> entities) {
    return store.createWriteEngine().save(entities);
  }
}
