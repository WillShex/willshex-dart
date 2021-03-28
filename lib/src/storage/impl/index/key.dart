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
  static const max = 4294967296;

  Key._() : super(_creator, 2);

  static Key _creator() {
    return Key._();
  }

  static Key createKey([int capacity = 10]) {
    return AbstractTree.createTree(KeyRegion(0, max), capacity, _creator);
  }
}
