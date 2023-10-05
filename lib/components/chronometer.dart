import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Chronometer extends ChangeNotifier  {
  late Timer timer;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  int _milliseconds = 0;
  int get milliseconds => _milliseconds;

  int _seconds = 0;
  int get seconds => _seconds;

  int _minutes = 0;
  int get minutes => _minutes;

  void start() {
    if (!_isRunning) {
      timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        _milliseconds++;
        _isRunning = true;
        notifyListeners();
      });
    }
  }
}
