//
//  indexhelper.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';
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
  static final Logger _log = Logger("IndexHelper");

  static Future<Index<I>> loadIndex<T, I>({
    @required StorageImpl<Storage> storage,
    Class<T> type,
    String colName,
    String path,
  }) async {
    // TODO: load index
    return null;
  }

  static Future<void> saveIndex<T, I>({
    @required StorageImpl<Storage> storage,
    Index<I> index,
    Class<T> type,
    String colName,
    String path,
  }) async {
    // TODO: save index
  }

  static Future<Key> loadKey<T>({
    @required StorageImpl<Storage> storage,
    Class<T> type,
    String path,
  }) async {
    return null;
  }

  static Future<void> saveKey<T>({
    @required StorageImpl<Storage> storage,
    @required Key key,
    @required Class<T> type,
    String path,
  }) async {
    if (type != null) {
      Directory keyFolder = Directory(
          "${(await storage.ensureFolder(type.getSimpleName())).path}/.key/${path ?? ""}");

      // remove .key folder
      if (await keyFolder.exists()) {
        await keyFolder.delete(
          recursive: true,
        );

        // recreate the folder
        await keyFolder.create();
      }

      if (key.points != null) {
        File pointsFile = File("${keyFolder.absolute.path}/points.text");
        pointsFile = await pointsFile.create(
          recursive: true,
        );

        await pointsFile.writeAsBytes(
            utf8.encode((key.points.map((e) => e.toString()).join("\n"))));

        for (int i = 0; i < key.children.length; i++) {
          if (key.children[i] != null) {
            await saveKey(
                storage: storage,
                key: key.children[i],
                type: type,
                path: _path(path, i));
          }
        }
      }
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

    _log.info("$s weighs: $value");

    return value;
  }
}
