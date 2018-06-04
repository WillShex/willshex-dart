//
//  QueryExecute.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import '../result.dart';

typedef Future<List<T>> ListFunction<T>();
typedef Result<T> FirstFunction<T>();

///
/// @author William Shakour (billy1380)
///
class QueryExecute<T> {
  ListFunction _listCall;
  FirstFunction _firstCall;

  QueryExecute(this._firstCall, this._listCall);

  Future<List<T>> list() async {
    return _listCall();
  }

  Result<T> first() {
    return _firstCall();
  }
}
