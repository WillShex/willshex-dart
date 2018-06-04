//
//  statustype.dart
//  blogwt
//
//  Created by William Shakour on March 21, 2018.
//  Copyright © 2018 WillShex Limited. All rights reserved.
//

enum StatusType {
  success,
  failure,
}

String fromStatusTypeToString(StatusType value) {
  String statusType;

  switch (value) {
    case StatusType.success:
      statusType = "success";
      break;
    case StatusType.failure:
      statusType = "failure";
      break;
  }

  return statusType;
}

StatusType fromStringToStatusType(String value) {
  StatusType statusType;

  switch (value) {
    case "success":
      statusType = StatusType.success;
      break;
    case "failure":
      statusType = StatusType.failure;
      break;
  }

  return statusType;
}
