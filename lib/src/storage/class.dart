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
  final String _name;

  const Class(this._t, this._name);

  String get simpleName {
    return _name.split(".").last;
  }

  String get name {
    return _name;
  }

  @override
  int get hashCode {
    return _t.hashCode;
  }

  @override
  bool operator ==(dynamic other) {
    return other != null && other is Class && other._t == this._t;
  }
}
