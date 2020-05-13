//
//  DeleteIdsImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import 'package:willshex/src/storage/cmd/deletetype.dart';
import 'deleterimpl.dart';
import 'package:willshex/willshex.dart';

///
/// @author William Shakour (billy1380)
///
class DeleteTypeImpl implements DeleteType {
  DeleterImpl deleter;
  Class<DataType> type;

  DeleteTypeImpl(this.deleter, this.type);

  @override
  Future<void> id(int id) {
    return ids(<int>[id]);
  }

  @override
  Future<void> ids(Iterable<int> ids) {
    return deleter.ids(type, ids);
  }

  @override
  Future<void> entity<T extends DataType>(T entity) {
    return entities(<T>[entity]);
  }

  @override
  Future<void> entities<T extends DataType>(Iterable<T> entities) {
    List<int> ids = <int>[];
    for (T entity in entities) {
      ids.add(entity.id);
    }

    return this.deleter.ids(type, ids);
  }
}
