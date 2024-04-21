import 'package:flutter/material.dart';

class SelectedProvider extends ChangeNotifier {
  int adults = 1;
  int children = 0;
  int rooms = 1;
  bool _isGuestEnteredControllerEmpty = false;

  void incrementAdults() {
    adults++;
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }

  void decrementAdults() {
    if (adults > 1) {
      adults--;
    }
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }

  void incrementChildren() {
    children++;
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }

  void decrementChildren() {
    if (children > 0) {
      children--;
    }
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }

  void incrementRooms() {
    rooms++;
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }

  void decrementRooms() {
    if (rooms > 1) {
      rooms--;
    }
    _isGuestEnteredControllerEmpty = true;
    notifyListeners();
  }
}
