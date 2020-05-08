//
//  DeleteType.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import 'deleteids.dart';
import '../../datatype.dart';

///
/// @author William Shakour (billy1380)
///
abstract class DeleteType implements DeleteIds {
  Result<void> entity<T extends DataType>(T entity);

  Result<void> entities<T extends DataType>(Iterable<T> entities);
}
