//
//  DeleteIdsImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../cmd/deletetype.dart';
import 'deleterimpl.dart';
import '../class.dart';
import '../../datatype.dart';

///
/// @author William Shakour (billy1380)
///
class DeleteTypeImpl implements DeleteType {
  DeleterImpl deleter;
  Class<DataType> type;

  DeleteTypeImpl(this.deleter, this.type);

  @override
  Result<void> id(int id) {
    return ids(<int>[id]);
  }

  @override
  Result<void> ids(Iterable<int> ids) {
    return deleter.ids(type, ids);
  }

  @override
  Result<void> entity<T extends DataType>(T entity) {
    return entities(<T>[entity]);
  }

  @override
  Result<void> entities<T extends DataType>(Iterable<T> entities) {
    List<int> ids = <int>[];
    for (T entity in entities) {
      ids.add(entity.id);
    }

    return this.deleter.ids(type, ids);
  }
}
