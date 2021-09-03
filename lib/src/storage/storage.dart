//
//  Storage.dart
//  storage
//
//  Created by William Shakour (billy1380) on 28 Mar 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'cmd/compactor.dart';
import 'cmd/deleter.dart';
import 'cmd/loader.dart';
import 'cmd/saver.dart';

///
/// @author William Shakour (billy1380)
///
abstract class Storage {
  static const String VERSION = "0.0.2";

  Loader get load;

  Saver get save;

  Deleter get delete;

  Storage cache(bool cache);

  Compactor get compact;
}
