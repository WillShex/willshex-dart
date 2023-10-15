/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:willshex/src/functions.dart';

class ArrayIterator<E> implements Iterator<E> {
  int _i = 0;
  final int _size;
  final List<E> _ref;

  ArrayIterator(this._ref, this._size);

  bool hasNext() {
    return _i < _size;
  }

  E next() {
    return _ref[_i++];
  }

  @override
  E get current => _ref[_i];

  @override
  bool moveNext() {
    bool n = hasNext();

    if (n) {
      next();
    }

    return n;
  }
}

class ContainerHelpers {
  static final List<int> emptyInts = List<int>.empty(growable: false);
  static final List<Object> emptyObjects = List<Object>.empty(growable: false);

  static int idealIntArraySize(int need) {
    return idealByteArraySize(need * 4) ~/ 4;
  }

  static int idealByteArraySize(int need) {
    for (int i = 4; i < 32; i++) {
      if (need <= (1 << i) - 12) return (1 << i) - 12;
    }

    return need;
  }

  static bool equal(dynamic a, dynamic b) {
    return a == b || (a != null && a.equals(b));
  }

  // This is Arrays.binarySearch(), but doesn't do any argument validation.
  static int binarySearch(List<int> array, int size, int value) {
    int lo = 0;
    int hi = size - 1;

    while (lo <= hi) {
      int mid = unsignedShift((lo + hi), 1);
      int midVal = array[mid];

      if (midVal < value) {
        lo = mid + 1;
      } else if (midVal > value) {
        hi = mid - 1;
      } else {
        return mid; // value found
      }
    }
    return ~lo; // value not present
  }
}
