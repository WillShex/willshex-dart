//
//  abstracttree.dart
//  willshex
//
//  Created by William Shakour (billy1380) on 22 Apr 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

abstract class Region<T> {
  Region<T> split(int value);
  bool intersects(Region<T> region);
  bool contains(T t);
}

typedef T CreateFunction<T>();

abstract class AbstractTree<T> {
  final List<AbstractTree<T>> children;
  int capacity;
  Region<T> bounds;
  List<T> points;
  CreateFunction<AbstractTree<T>> creator;

  AbstractTree(this.creator, int branches) : children = new List(branches);

  static AbstractTree<T> createTree<T>(
      Region<T> region, int capacity, CreateFunction<AbstractTree<T>> creator) {
    AbstractTree<T> q = creator();
    q.bounds = region;
    q.capacity = capacity;
    return q;
  }

  bool add(T p) {
    bool added = false;

    if (bounds.contains(p)) {
      if (_isSubdivided()) {
        added = _addToChildren(p);
      } else {
        if (points == null) {
          points = [];
        }

        points.add(p);

        if (points.length == capacity) {
          _subdivideBinary();
        }

        added = true;
      }
    }

    return added;
  }

  int countQuery(Region<T> r, List<T> found) {
    int counted = 0;

    if (bounds.intersects(r)) {
      if (points != null) {
        for (T p in points) {
          counted++;
          if (r.contains(p)) {
            found.add(p);
          }
        }

        if (_isSubdivided()) {
          for (int i = 0; i < children.length; i++) {
            if (children[i] != null) {
              counted += children[i].countQuery(r, found);
            }
          }
        }
      }
    }

    return counted;
  }

  List<T> resultQuery(Region<T> r) {
    List<T> found = [];

    countQuery(r, found);

    return found;
  }

  bool _isSubdivided() {
    return points != null && points.length == capacity;
  }

  bool _addToChildren(T p) {
    bool added = false;

    for (int i = 0; i < children.length; i++) {
      if (children[i].add(p)) {
        added = true;
        break;
      }
    }

    return added;
  }

  void _subdivideBinary() {
    for (int i = 0; i < children.length; i++) {
      children[i] = createTree(bounds.split(i), capacity, creator);
    }
  }
}
