import 'package:flutter/material.dart';

class SelectedProvider extends ChangeNotifier {
  int adults = 1;
  int children = 0;
  int rooms = 1;

  void incrementAdults() {
    adults++;
    notifyListeners();
  }

  void decrementAdults() {
    if (adults > 1) {
      adults--;
    }
    notifyListeners();
  }

  void incrementChildren() {
    children++;
    notifyListeners();
  }

  void decrementChildren() {
    if (children > 0) {
      children--;
    }
    notifyListeners();
  }

  void incrementRooms() {
    rooms++;
    notifyListeners();
  }

  void decrementRooms() {
    if (rooms > 1) {
      rooms--;
    }
    notifyListeners();
  }
}
