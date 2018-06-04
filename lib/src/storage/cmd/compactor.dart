//
//  compactor.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';
import '../class.dart';

///
/// @author William Shakour (billy1380)
///
abstract class Compactor {
  Result<Null> type<E>(Class<E> type);
}
