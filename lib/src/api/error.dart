//
//  error.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'package:willshex/src/jsonable.dart';

class Error extends Jsonable {
  int code;
  String message;

  Error({
    this.code,
    this.message,
  });

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json["code"] != null) {
      code = json["code"];
    }

    if (json["message"] != null) {
      message = json["message"];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (code != null) {
      json["code"] = code;
    }

    if (message != null) {
      json["message"] = message;
    }

    return json;
  }
}
