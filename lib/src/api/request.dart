//
//  request.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'package:willshex/src/jsonable.dart';

class Request extends Jsonable {
  String? accessCode;

  Request({
    this.accessCode,
  });

  Request.json(Map<String, dynamic> json) : super.json(json);
  Request.string(String string) : super.string(string);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json["accessCode"] != null) {
      accessCode = json["accessCode"];
    }

  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (accessCode != null) {
      json["accessCode"] = accessCode;
    }

    return json;
  }
}
