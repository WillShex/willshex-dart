//
//  datatype.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'jsonable.dart';

class DataType extends Jsonable {
  int id;
  DateTime created;
  bool deleted;

  DataType({
    this.id,
    this.created,
    this.deleted,
  });

  DataType.json(Map<String, dynamic> json) : super.json(json);
  DataType.string(String string) : super.string(string);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json["id"] != null) {
      id = json["id"];
    }

    if (json["created"] != null) {
      created = new DateTime.fromMicrosecondsSinceEpoch(json["created"]);
    }

    if (json["deleted"] != null) {
      deleted = json["deleted"];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (id != null) {
      json["id"] = id;
    }

    if (created != null) {
      json["created"] = created.microsecondsSinceEpoch;
    }

    if (deleted != null) {
      json["deleted"] = deleted;
    }

    return json;
  }
}
