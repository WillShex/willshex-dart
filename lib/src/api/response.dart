//
//  response.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'package:willshex/willshex.dart' as ws;

class Response extends ws.Jsonable {
  ws.StatusType status;
  ws.Error error;

  Response({
    this.status,
    this.error,
  });

  Response.json(Map<String, dynamic> json) : super.json(json);
  Response.string(String string) : super.string(string);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json["status"] != null) {
      status = ws.fromStringToStatusType(json["status"]);
    }

    if (json["error"] != null) {
      error = ws.Error()..fromJson(json["error"]);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (status != null) {
      json["status"] = ws.fromStatusTypeToString(status);
    }

    if (error != null) {
      json["error"] = error.toJson();
    }

    return json;
  }
}
