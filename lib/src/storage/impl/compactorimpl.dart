//
//  CompactorImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import 'storageimpl.dart';
import '../cmd/compactor.dart';
import '../class.dart';
import '../storage.dart';

///
/// @author William Shakour (billy1380)
///
class CompactorImpl implements Compactor {
  StorageImpl<Storage> store;

  CompactorImpl(this.store);

  @override
  Result<void> type<E>(Class<E> type) {
    return Result<void>(() {
      return null;
    });
  }
}
