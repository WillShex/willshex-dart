//
//  pager.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

import 'package:willshex/src/jsonable.dart';
import 'package:willshex/src/sortdirectiontype.dart';

class Pager extends Jsonable {
  int? start;
  int? count;
  String? sortBy;
  SortDirectionType? sortDirection;
  int? totalCount;
  String? next;
  String? previous;

  Pager({
    this.start,
    this.count,
    this.sortBy,
    this.sortDirection,
    this.totalCount,
    this.next,
    this.previous,
  });

  Pager.json(Map<String, dynamic> json) : super.json(json);
  Pager.string(String string) : super.string(string);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json["start"] != null) {
      start = json["start"];
    }

    if (json["count"] != null) {
      count = json["count"];
    }

    if (json["sortBy"] != null) {
      sortBy = json["sortBy"];
    }

    if (json["sortDirection"] != null) {
      sortDirection = fromStringToSortDirectionType(json["sortDirection"]);
    }

    if (json["totalCount"] != null) {
      totalCount = json["totalCount"];
    }

    if (json["next"] != null) {
      next = json["next"];
    }

    if (json["previous"] != null) {
      previous = json["previous"];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (start != null) {
      json["start"] = start;
    }

    if (count != null) {
      json["count"] = count;
    }

    if (sortBy != null) {
      json["sortBy"] = sortBy;
    }

    if (sortDirection != null) {
      json["sortDirection"] = fromSortDirectionTypeToString(sortDirection);
    }

    if (totalCount != null) {
      json["totalCount"] = totalCount;
    }

    if (next != null) {
      json["next"] = next;
    }

    if (previous != null) {
      json["previous"] = previous;
    }

    return json;
  }
}
