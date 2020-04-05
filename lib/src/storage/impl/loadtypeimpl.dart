//
//  LoadTypeImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'simplequeryimpl.dart';
import '../result.dart';
import '../../datatype.dart';
import 'queryable.dart';
import '../cmd/loadtype.dart';
import 'loaderimpl.dart';
import '../cmd/loader.dart';
import '../class.dart';
import '../cmd/query.dart';
import 'queryimpl.dart';

///
/// @author William Shakour (billy1380)
///
class LoadTypeImpl<T extends DataType> extends Queryable<T>
    implements LoadType<T> {
  LoadTypeImpl(LoaderImpl<Loader> loader, Class<T> type) : super(loader) {
    this.dataClass = type;
  }

  @override
  Result<T> id(final int id) {
    return loader.id(dataClass, id);
  }

  @override
  Result<Map<int, T>> ids(Iterable<int> ids) {
    return loader.ids(dataClass, ids);
  }

  @override
  Query<T> filter(String condition, dynamic value) {
    QueryImpl<T> q = createQuery();
    q.addFilter(condition, value);
    return q;
  }

  @override
  Query<T> order(String condition) {
    QueryImpl<T> q = createQuery();
    q.addOrder(condition);
    return q;
  }

  @override
  Query<T> group(String condition) {
    QueryImpl<T> q = createQuery();
    q.addGroup(condition);
    return q;
  }

  @override
  QueryImpl<T> createQuery() {
    return QueryImpl<T>.typed(loader, dataClass);
  }

  @override
  SimpleQueryImpl<T> newInstance() {
    return LoadTypeImpl<T>(null, null);
  }
}
