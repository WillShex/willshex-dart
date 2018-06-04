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
  final Type t;

  const Class(this.t);

  String getSimpleName() {
    return t.toString();
  }

  String getName() {
    return t.toString();
  }
}
