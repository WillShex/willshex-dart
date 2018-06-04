//
//  LoaderImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import 'package:willshex/src/storage/cloneable.dart';
import 'package:willshex/src/storage/class.dart';
import 'package:willshex/src/storage/result.dart';
import 'package:willshex/src/storage/cmd/loader.dart';
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/storage/cmd/loadtype.dart';

import 'queryable.dart';
import 'queryimpl.dart';
import 'storageimpl.dart';

import 'loadengine.dart';
import 'queryengine.dart';
import 'loadtypeimpl.dart';
import 'simplequeryimpl.dart';

///
/// @author William Shakour (billy1380)
///
class LoaderImpl<L extends Loader> extends Queryable<DataType>
    implements Loader, Cloneable {
  StorageImpl<Storage> store;

  LoaderImpl._private() : super.protected();
  LoaderImpl(this.store) : super(null);

  @override
  LoadType<E> type<E extends DataType>(Class<E> type) {
    return new LoadTypeImpl<E>(this, type);
  }

  @override
  QueryImpl<DataType> createQuery() {
    return new QueryImpl<DataType>(this);
  }

  @override
  Result<Map<int, E>> entities<E extends DataType>(Iterable<E> entities) {
    LoadEngine engine = createLoadEngine();

    List<int> ids = <int>[];
    Class<E> type;
    for (E entity in entities) {
      if (type == null) {
        type = new Class(entity.runtimeType);
      }

      ids.add(entity.id);
    }

    return engine.load(type, ids);
  }

  LoadEngine createLoadEngine() {
    return new LoadEngine(this, store);
  }

  QueryEngine createQueryEngine() {
    return new QueryEngine(this, store);
  }

  @override
  Future<E> now<E extends DataType>(Class<E> type, int id) async {
    Map<int, E> loaded = await createLoadEngine().load(type, <int>[id]).now();
    return loaded.values.length > 0 ? loaded.values.first : null;
  }

  LoaderImpl<L> clone() {
    try {
      return super.clone();
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Result<E> entity<E extends DataType>(final E entity) {
    return new Result<E>(() async {
      Map<int, E> entities = await this.entities(<E>[entity]).now();
      return entities.values.length > 0 ? entities.values.first : null;
    });
  }

  @override
  Result<T> id<T extends DataType>(final Class<T> type, final int id) {
    return new Result<T>(() async {
      Map<int, T> entities = await this.ids(type, <int>[id]).now();
      return entities.values.length > 0 ? entities.values.first : null;
    });
  }

  @override
  Result<Map<int, T>> ids<T extends DataType>(
      Class<T> type, Iterable<int> ids) {
    return createLoadEngine().load(type, ids);
  }

  @override
  SimpleQueryImpl<DataType> newInstance() {
    return new LoaderImpl<Loader>._private();
  }
}
