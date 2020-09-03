import 'package:flutter/widgets.dart';

class SequentialStage with ChangeNotifier {
  int stage;

  SequentialStage() {
    this.stage = 0;
  }

  void increase() {
    stage++;
    notifyListeners();
  }

  void decrease() {
    stage--;
    notifyListeners();
  }
}
