//
//  LoadIds.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import 'package:willshex/src/datatype.dart';

///
/// @author William Shakour (billy1380)
///
abstract class LoadIds<T extends DataType> {
  Result<T> id(int id);

  Result<Map<int, T>> ids(Iterable<int> ids);
}
