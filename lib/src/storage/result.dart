//
//  result.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

typedef Future<T> NowFunction<T>();

///
/// @author William Shakour (billy1380)
///
class Result<T> {
  final NowFunction _nowCall;

  Result(this._nowCall);

  Future<T> now() async {
    return _nowCall();
  }
}
