//
//  indexhelper.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';

import 'package:meta/meta.dart';
import 'dart:math';

import '../../class.dart';
import '../../storage.dart';
import '../index/index.dart';
import '../index/key.dart';
import '../storageimpl.dart';

///
/// @author William Shakour (billy1380)
///
class IndexHelper {
  static Future<Index<I>> loadIndex<T, I>({
    @required StorageImpl<Storage> storage,
    Class<T> type,
    String colName,
    String path,
  }) async {
    return null;
  }

  static Future<void> saveIndex<T, I>(
      {@required StorageImpl<Storage> storage,
      Index<I> index,
      Class<T> type,
      String colName,
      String path}) async {}

  static Future<Key> loadKey<T>(
      {@required StorageImpl<Storage> storage,
      Class<T> type,
      String path}) async {
    return null;
  }

  static Future<void> saveKey<T>(
      {@required StorageImpl<Storage> storage,
      @required Key key,
      @required Class<T> type,
      String path}) async {
    if (type != null) {
      if (path == null) {
        // remove .key folder

        if (key.points != null) {
          // TODO: write the points

          for (int i = 0; i < key.children.length; i++) {
            saveKey(
                storage: storage,
                key: key.children[i],
                type: type,
                path: _path(path, i));
          }
        }
      } else {}
    }
  }

  static String _path(String path, int index) {
    return path == null ? "$index" : "$path$index";
  }

  static double weigh(String s) {
    double value = 0.0;
    for (int i = 0; i < s.length; i++) {
      value += s.codeUnitAt(i) * pow(10.0, -i);
    }

    print("$s weighs: $value");

    return value;
  }
}
