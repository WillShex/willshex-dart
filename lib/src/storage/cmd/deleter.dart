//
//  Deleter.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../class.dart';
import '../../datatype.dart';
import 'deletetype.dart';

///
/// @author William Shakour (billy1380)
///
abstract class Deleter {
  DeleteType type(Class<DataType> type);

  Result<void> entity<T extends DataType>(T entity);

  Result<void> entities<T extends DataType>(Iterable<T> entities);
}
