import 'dart:math';

import 'package:hive/hive.dart';

/**
 * Class which represents forwarding rule
 */
@HiveType(typeId: 0)
class NotificationFilter extends HiveObject {
  @HiveField(0)
  String filterName;
  @HiveField(1)
  String key;
  @HiveField(2)
  String value;
  @HiveField(3)
  ForwardingMode forwardingMode;

  NotificationFilter() {
    this.key = randomString(10);
  }

  String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }
}

enum ForwardingMode { Accepting, Rejecting }
