//
//  Saver.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../../datatype.dart';

///
/// @author William Shakour (billy1380)
///
abstract class Saver {
  Result<int> entity<E extends DataType>(E entity);

  Result<Map<int, E>> entities<E extends DataType>(Iterable<E> entities);
}
