/*
 * Copyright (C) 2011 The Android Open Source Project
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

import 'dart:math';

import 'package:willshex/src/functions.dart';
import 'package:willshex/src/utility/containerhelpers.dart';
import 'package:willshex/willshex.dart';

typedef KeyProvider<T> = int Function(T object);

/// A copy of the current platform (currently {@link android.os.Build.VERSION_CODES#KITKAT}
/// version of {@link android.util.SparseArray}; provides a removeAt() method and other things.
class SparseArray<E> extends Iterable<E> implements Cloneable<SparseArray<E>> {
  static final Object _deleted = Object();
  bool _garbage = false;

  late List<int> _keys;
  late List<Object?> _values;
  int _length = 0;

  ///
  /// Creates a new SparseArray containing no mappings that will not
  /// require any additional memory allocation to store the specified
  /// number of mappings.  If you supply an initial capacity of 0, the
  /// sparse array will be initialized with a light-weight representation
  /// not requiring any additional array allocations.
  ///
  SparseArray([int initialCapacity = 10]) {
    if (initialCapacity == 0) {
      _keys = ContainerHelpers.emptyInts;
      _values = ContainerHelpers.emptyObjects;
    } else {
      initialCapacity = ContainerHelpers.idealIntArraySize(initialCapacity);
      _keys = <int>[]..length = initialCapacity;
      _values = <Object>[]..length = initialCapacity;
    }
  }

  @override
  SparseArray<E> clone() {
    late SparseArray<E> clone;

    clone = SparseArray<E>(_keys.length);
    clone._garbage = _garbage;
    clone._length = _length;
    clone._keys = List<int>.from(_keys);
    clone._values = List<int>.from(_values);

    return clone;
  }

  ///
  /// Gets the Object mapped from the specified key, or <code>null</code>
  /// if no such mapping has been made.
  ///
  E? operator [](int key) {
    return get(key, null);
  }

  ///
  /// Gets the Object mapped from the specified key, or the specified Object
  /// if no such mapping has been made.
  ///
  E? get(int key, E? valueIfKeyNotFound) {
    int i = ContainerHelpers.binarySearch(_keys, _length, key);

    if (i < 0 || _values[i] == _deleted) {
      return valueIfKeyNotFound;
    } else {
      return _values[i] as E;
    }
  }

  ///
  /// Removes the mapping from the specified key, if there was any.
  ///
  void delete(int key) {
    int i = ContainerHelpers.binarySearch(_keys, _length, key);

    if (i >= 0) {
      if (_values[i] != _deleted) {
        _values[i] = _deleted;
        _garbage = true;
      }
    }
  }

  ///
  /// Alias for {@link #delete(int)}.
  ///
  void remove(int key) {
    delete(key);
  }

  ///
  /// Removes the mapping at the specified index.
  ///
  void removeAt(int index) {
    if (_values[index] != _deleted) {
      _values[index] = _deleted;
      _garbage = true;
    }
  }

  ///
  /// Remove a range of mappings as a batch.
  ///
  /// @param index Index to begin at
  /// @param size Number of mappings to remove
  ///
  void removeAtRange(int index, int size) {
    final int end = min(_length, index + size);
    for (int i = index; i < end; i++) {
      removeAt(i);
    }
  }

  void _gc() {
    // Log.e("SparseArray", "gc start with " + mSize);

    int n = _length;
    int o = 0;
    List<int> keys = _keys;
    List<Object?> values = _values;

    for (int i = 0; i < n; i++) {
      Object? val = values[i];

      if (val != _deleted) {
        if (i != o) {
          keys[o] = keys[i];
          values[o] = val;
          values[i] = null;
        }

        o++;
      }
    }

    _garbage = false;
    _length = o;

    // Log.e("SparseArray", "gc end with " + mSize);
  }

  ///
  /// Adds a mapping from the specified key to the specified value,
  /// replacing the previous mapping from the specified key if there
  /// was one.
  ///
  void operator []=(int key, E? value) {
    int i = ContainerHelpers.binarySearch(_keys, _length, key);

    if (i >= 0) {
      _values[i] = value;
    } else {
      i = ~i;

      if (i < _length && _values[i] == _deleted) {
        _keys[i] = key;
        _values[i] = value;
        return;
      }

      if (_garbage && _length >= _keys.length) {
        _gc();

        // Search again because indices may have changed.
        i = ~ContainerHelpers.binarySearch(_keys, _length, key);
      }

      if (_length >= _keys.length) {
        int n = ContainerHelpers.idealIntArraySize(_length + 1);

        List<int> nkeys = <int>[]..length = n;
        List<Object> nvalues = <Object>[]..length = n;

        // Log.e("SparseArray", "grow " + mKeys.length + " to " + n);
        _arrayCopy(_keys, 0, nkeys, 0, _keys.length);
        _arrayCopy(_values, 0, nvalues, 0, _values.length);

        _keys = nkeys;
        _values = nvalues;
      }

      if (_length - i != 0) {
        // Log.e("SparseArray", "move " + (mSize - i));
        _arrayCopy(_keys, i, _keys, i + 1, _length - i);
        _arrayCopy(_values, i, _values, i + 1, _length - i);
      }

      _keys[i] = key;
      _values[i] = value;
      _length++;
    }
  }

  ///
  /// Returns the number of key-value mappings that this SparseArray
  /// currently stores.
  ///
  @override
  int get length {
    if (_garbage) {
      _gc();
    }

    return _length;
  }

  ///
  /// Given an index in the range <code>0...size()-1</code>, returns
  /// the key from the <code>index</code>th key-value mapping that this
  /// SparseArray stores.
  ///
  int keyAt(int index) {
    if (_garbage) {
      _gc();
    }

    return _keys[index];
  }

  ///
  /// Given an index in the range <code>0...size()-1</code>, returns
  /// the value from the <code>index</code>th key-value mapping that this
  /// SparseArray stores.
  ///
  E? valueAt(int index) {
    if (_garbage) {
      _gc();
    }

    return _values[index] as E;
  }

  ///
  /// Given an index in the range <code>0...size()-1</code>, sets a new
  /// value for the <code>index</code>th key-value mapping that this
  /// SparseArray stores.
  ///
  void setValueAt(int index, E value) {
    if (_garbage) {
      _gc();
    }

    _values[index] = value;
  }

  ///
  /// Returns the index for which {@link #keyAt} would return the
  /// specified key, or a negative number if the specified
  /// key is not mapped.
  ///
  int indexOfKey(int key) {
    if (_garbage) {
      _gc();
    }

    return ContainerHelpers.binarySearch(_keys, _length, key);
  }

  ///
  /// Returns an index for which {@link #valueAt} would return the
  /// specified key, or a negative number if no keys map to the
  /// specified value.
  /// <p>Beware that this is a linear search, unlike lookups by key,
  /// and that multiple keys can map to the same value and this will
  /// find only one of them.
  /// <p>Note also that unlike most collections' {@code indexOf} methods,
  /// this method compares values using {@code ==} rather than {@code equals}.
  ///
  int indexOfValue(E value) {
    if (_garbage) {
      _gc();
    }

    for (int i = 0; i < _length; i++) {
      if (_values[i] == value) return i;
    }

    return -1;
  }

  ///
  /// Removes all key-value mappings from this SparseArray.
  ///
  void clear() {
    int n = _length;
    List<Object?> values = _values;

    for (int i = 0; i < n; i++) {
      values[i] = null;
    }

    _length = 0;
    _garbage = false;
  }

  ///
  /// Puts a key/value pair into the array, optimizing for the case where
  /// the key is greater than all existing keys in the array.
  ///
  void append(int key, E value) {
    if (_length != 0 && key <= _keys[_length - 1]) {
      this[key] = value;
      return;
    }

    if (_garbage && _length >= _keys.length) {
      _gc();
    }

    int pos = _length;
    if (pos >= _keys.length) {
      int n = ContainerHelpers.idealIntArraySize(pos + 1);

      List<int> nkeys = <int>[]..length = n;
      List<Object> nvalues = <Object>[]..length = n;

      // Log.e("SparseArray", "grow " + mKeys.length + " to " + n);
      _arrayCopy(_keys, 0, nkeys, 0, _keys.length);
      _arrayCopy(_values, 0, nvalues, 0, _values.length);

      _keys = nkeys;
      _values = nvalues;
    }

    _keys[pos] = key;
    _values[pos] = value;
    _length = pos + 1;
  }

  ///
  /// {@inheritDoc}
  /// <p>This implementation composes a string by iterating over its mappings. If
  /// this map contains itself as a value, the string "(this Map)"
  /// will appear in its place.
  ///
  @override
  String toString() {
    if (length <= 0) {
      return "{}";
    }

    StringBuffer buffer = StringBuffer(_length * 28);
    buffer.write('{');
    for (int i = 0; i < _length; i++) {
      if (i > 0) {
        buffer.write(", ");
      }
      int key = keyAt(i);
      buffer.write(key);
      buffer.write('=');
      Object? value = valueAt(i);
      if (value != this) {
        buffer.write(value);
      } else {
        buffer.write("(this Map)");
      }
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  Iterator<E> get iterator {
    return ArrayIterator<E>(
        _values.where((Object? e) => e != null).toList().cast<E>(), length);
  }

  bool containsKey(int key) {
    return this[key] != null;
  }

  static SparseArray<E> of<E>(Iterable<E>? i, Mapper<E, int>? p) {
    SparseArray<E>? array;

    if (i != null && p != null) {
      final SparseArray<E> a = SparseArray<E>();
      for (E s in i) {
        a[p(s)] = s;
      }
      array = a;
    }

    return array ?? SparseArray<E>();
  }

  void putAll(Iterable<E> i, Mapper<E, int> p) {
    for (E s in i) {
      this[p(s)] = s;
    }
  }

  @override
  bool get isEmpty {
    return length == 0;
  }

  void _arrayCopy<T>(
      List<T> sourceArr, int sourcePos, List<T> destArr, int destPos, int len) {
    for (int i = 0; i < len; i++) {
      destArr[i + destPos] = sourceArr[i + sourcePos];
    }
  }
}
