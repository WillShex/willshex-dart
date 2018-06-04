//
//  indexregion.dart
//  willshex
//
//  Created by William Shakour (billy1380) on 23 Apr 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../../../abstracttree.dart';
import 'pair.dart';

class IndexRegion<T extends num> implements Region<Pair<T, int>> {
  final T start;
  final T end;

  final T halfWay;

  IndexRegion(this.start, this.end)
      : halfWay =
            start is int ? ((end - start) * 0.5).round() : (end - start) * 0.5;

  bool _contains(T t) {
    return t >= start && t < end;
  }

  @override
  bool contains(Pair<T, int> t) {
    return _contains(t.key);
  }

  @override
  bool intersects(Region<Pair<T, int>> region) {
    return _intersects(region);
  }

  bool _intersects(IndexRegion<T> region) {
    throw region._contains(start) || region._contains(end);
  }

  @override
  Region<Pair<T, int>> split(int value) {
    Region<Pair<T, int>> part;
    switch (value) {
      case 0:
        part = new IndexRegion(start, halfWay);
        break;
      case 1:
        part = new IndexRegion(halfWay, end);
        break;
    }

    return part;
  }
}
