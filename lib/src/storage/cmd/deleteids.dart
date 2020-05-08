//
//  deleteids.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import '../result.dart';

///
/// @author William Shakour (billy1380)
///
abstract class DeleteIds {
  Result<void> id(int id);

  Result<void> ids(Iterable<int> ids);
}
