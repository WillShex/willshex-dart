//
//  Loader.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import 'package:willshex/src/storage/result.dart';
import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/storage/class.dart';

import 'simplequery.dart';
import 'loadtype.dart';

///
/// @author William Shakour (billy1380)
///
abstract class Loader implements SimpleQuery<DataType> {
  LoadType<T> type<T extends DataType>(Class<T> type);

  Result<T> id<T extends DataType>(Class<T> type, int id);

  Result<Map<int, T>> ids<T extends DataType>(Class<T> type, Iterable<int> ids);

  Result<E> entity<E extends DataType>(E entity);

  Result<Map<int, E>> entities<E extends DataType>(Iterable<E> entities);

  Future<E> now<E extends DataType>(Class<E> type, int id);
}
