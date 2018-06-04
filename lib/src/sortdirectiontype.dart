//
//  sortdirectiontype.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

enum SortDirectionType {
  ascending,
  descending,
}

String fromSortDirectionTypeToString(SortDirectionType value) {
  String sortDirectionType;

  switch (value) {
    case SortDirectionType.ascending:
      sortDirectionType = "ascending";
      break;
    case SortDirectionType.descending:
      sortDirectionType = "descending";
      break;
  }

  return sortDirectionType;
}

SortDirectionType fromStringToSortDirectionType(String value) {
  SortDirectionType sortDirectionType;

  switch (value) {
    case "ascending":
      sortDirectionType = SortDirectionType.ascending;
      break;
    case "descending":
      sortDirectionType = SortDirectionType.descending;
      break;
  }

  return sortDirectionType;
}
