import 'package:flutter/cupertino.dart';

class CustomerService extends ChangeNotifier {
  int scrollLength = 0;
  var blockedValues = [];

  void totalLength(int val) {
    print(val);
    scrollLength = scrollLength + val;
    // scrollLength = scrollLength - blockedValues.length;
    notifyListeners();
  }

  void blocked(var val) {
    print('values are      $val');
    if (val == null) {
    } else {
      for (var item in val) {
        blockedValues.add(item);
        print("here");
      }
      notifyListeners();
    }
  }

  void clearData() {
    scrollLength = 0;
    blockedValues.clear();
  }
}
