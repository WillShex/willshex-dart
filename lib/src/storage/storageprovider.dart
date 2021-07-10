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
abstract class StorageProvider {
  StorageProvider._();
  
  static Storage provide(PathProvider path) {
    return StorageImpl<Storage>(path);
  }
}
