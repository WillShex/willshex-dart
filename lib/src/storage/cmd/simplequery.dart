//
//  SimpleQuery.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'queryexecute.dart';

///
/// @author William Shakour (billy1380)
///
abstract class SimpleQuery<T> implements QueryExecute<T> {
  SimpleQuery<T> filterId(String condition, dynamic value);

  SimpleQuery<T> limit(int value);

  SimpleQuery<T> offset(int value);

  SimpleQuery<T> distinct(bool value);

  SimpleQuery<T> reverse();

  QueryExecute<int> getIds();

  Future<int> get count;
}
