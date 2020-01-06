import 'dart:math';

/**
 * Class which represents forwarding rule
 */
class NotificationFilter {
  String filterName;
  String key;
  String titleFilterValue;

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
