//
//  key.dart
//  willshex
//
//  Created by William Shakour (billy1380) on 22 Apr 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../../../abstracttree.dart';
import 'keyregion.dart';

class Key extends AbstractTree<int> {
  Key() : super(_creator, 2);

  static Key _creator() {
    return new Key();
  }

  static Key createKey(KeyRegion region, int capacity) {
    return AbstractTree.createTree(region, capacity, _creator);
  }
}
