//
//  CompactorImpl.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'package:willshex/src/storage/cmd/compactor.dart';
import 'package:willshex/willshex.dart';

import 'storageimpl.dart';

import 'dart:async';

///
/// @author William Shakour (billy1380)
///
class CompactorImpl implements Compactor {
  StorageImpl<Storage> store;

  CompactorImpl(this.store);

  @override
  Future<void> type<E>(Class<E> type) {
    return null;
  }
}
