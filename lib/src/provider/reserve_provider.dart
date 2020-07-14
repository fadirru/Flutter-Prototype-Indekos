import 'package:flutter/cupertino.dart';

class ReserveProvider extends ChangeNotifier {
  Map<dynamic, dynamic> _reserve = {};
  Map<dynamic, dynamic> get reserve => _reserve;

  void addToReserved(index, payment, period) {
    _reserve[index] = 1;
    _reserve[index] = {'Payment': payment, 'PaymentPeriod': period};

    notifyListeners();
  }

  void clear(index, image) {
    if (_reserve.containsKey(index)) {
      _reserve[index] = {'Status': 'Verified', 'Image': image};
      notifyListeners();
    }
  }
}
