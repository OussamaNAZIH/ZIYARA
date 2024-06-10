import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectedProvider extends ChangeNotifier {
  int adults = 1;
  int children = 0;
  int rooms = 1;
    Map<String, bool> favoriteHotels = {};

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


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SelectedProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavoriteHotels(user.uid);
      }
    });
  }

  // Méthodes pour gérer les hôtels favoris
  Future<void> saveFavoriteHotels() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'hotellike': favoriteHotels.map((key, value) => MapEntry(key, value.toString())),
      });
    }
  }

  Future<void> loadFavoriteHotels(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('hotellike')) {
        Map<String, dynamic> favHotels = Map<String, dynamic>.from(data['hotellike']);
        favoriteHotels = favHotels.map((key, value) => MapEntry(key, value == 'true'));
        notifyListeners();
      }
    }
  }

  void toggleFavorite(String hotelId) {
    if (favoriteHotels.containsKey(hotelId)) {
      favoriteHotels[hotelId] = !favoriteHotels[hotelId]!;
    } else {
      favoriteHotels[hotelId] = true;
    }
    saveFavoriteHotels();
    notifyListeners();
  }

  bool isFavorite(String hotelId) {
    return favoriteHotels[hotelId] ?? false;
  }
}

