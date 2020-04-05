//
//  QueryEngine.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:willshex/src/datatype.dart';
import 'package:willshex/src/sortdirectiontype.dart';
import 'package:willshex/src/storage/storage.dart';
import 'package:willshex/src/storage/cmd/loader.dart';

import 'order.dart';

import 'queryimpl.dart';
import 'storageimpl.dart';
import 'loaderimpl.dart';
import 'helper/queryhelper.dart';

///
/// @author William Shakour (billy1380)
///
class QueryEngine {
  static const List<Order> DEFAULT_ORDER = const <Order>[
    const Order("id", SortDirectionType.ascending)
  ];

  LoaderImpl<Loader> loader;
  StorageImpl<Storage> store;

  QueryEngine(this.loader, this.store);

  Future<List<int>> queryIds<T extends DataType>(QueryImpl<T> q) async {
    List<T> entities = await query(q);
    List<int> ids = <int>[]..length = entities.length;
    for (T entity in entities) {
      ids.add(entity.id);
    }
    return ids;
  }

  Future<List<T>> query<T extends DataType>(QueryImpl<T> query) async {
    if (query.dataClass == null)
      throw AssertionError("Cannot query without a type");

    Directory folder =
        await store.ensureFolder(query.dataClass.getSimpleName());
    Stream<FileSystemEntity> records = Directory("${folder.path}").list();

    List<Map<String, dynamic>> objects = <Map<String, dynamic>>[];
    Map<String, dynamic> object;
    // int startAt = query.startAt == null ? 0 : query.startAt;
    // int matchedCount = 0;
    await for (FileSystemEntity record in records) {
      if (record is File && record.path.endsWith(".json")) {
        object = jsonDecode(await record.readAsString());
        if (QueryHelper.isMatchAll(object, query.allFilters)) {
          // if (matchedCount >= startAt) {
          objects.add(object);
          // if (query.stopAfter != null &&
          //     matchedCount - startAt == query.stopAfter - 1) break;
          // }
          // matchedCount++;
        }
      }
    }

    // TODO: process distinct and group

    QueryHelper.sort(
        objects, query.allOrders == null ? DEFAULT_ORDER : query.allOrders);

    if (query.startAt != 0) {
      objects = objects.sublist(query.startAt);
    }

    int end;
    if ((end = query.stopAfter + 1) < objects.length) {
      objects = objects.sublist(0, end);
    }

    if (query.isReverse) {
      objects = objects.reversed;
    }

    List<T> matched = <T>[];
    CreateFunction create = store.creators[query.dataClass];

    T instance;
    for (Map<String, dynamic> object in objects) {
      matched.add(instance = create());

      if (query.isIdsOnly) {
        instance.id = object["id"];
      } else {
        instance.fromJson(object);
      }
    }

    return matched;
  }

  Future<int> queryCount<T extends DataType>(QueryImpl<T> query) async {
    return (await this.query(query)).length;
  }
}
