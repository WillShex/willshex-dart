//
//  StorageProvider.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'storage.dart';
import 'impl/storageimpl.dart';

///
/// @author William Shakour (billy1380)
///
class StorageProvider {
  static Storage provide(PathProvider path) {
    return new StorageImpl<Storage>(path);
  }
}
