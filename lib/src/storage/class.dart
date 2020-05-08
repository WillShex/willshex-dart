//
//  class.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

///
/// @author William Shakour (billy1380)
///
class Class<T> {
  final Type _t;

  const Class(this._t);

  String getSimpleName() {
    return _t.toString();
  }

  String getName() {
    return _t.toString();
  }

  @override
  int get hashCode {
    return _t.hashCode;
  }

  @override
  bool operator ==(other) {
    return other != null && other is Class && other._t == this._t;
  }
}
