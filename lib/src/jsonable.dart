//
//  jsonable.dart
//  classesfrom-core
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'dart:convert';

class Jsonable {
  Jsonable();

  Jsonable.json(Map<String, dynamic> json) {
    fromJson(json);
  }

  Jsonable.string(String string) : this.json(jsonDecode(string));

  void fromJson(Map<String, dynamic> json) {}

  void fromString(String string) {
    fromJson(jsonDecode(string));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
