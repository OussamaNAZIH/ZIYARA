import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

// Modèle d'un hôtel
class Hotel {
  final String title;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviews;
  final String adresse;
  final int price;
  final int discount;
  final String photo1;
  final String photo2;
  final String photo3;

  Hotel({
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviews,
    required this.adresse,
    required this.price,
    required this.discount,
    required this.photo1,
    required this.photo2,
    required this.photo3,
  });
}

class HotelListScreen extends StatefulWidget {
  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  List<Hotel> nearbys = [];
  bool isLoading = true;
  Position? currentPosition;
  late Timer _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetLocation();

    // Start periodic updates only if the widget is mounted
    if (mounted) {
      _startPeriodicUpdates();
    }
  }

  void _startPeriodicUpdates() {
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 1000), (timer) {
      if (mounted) {
        _requestPermissionAndGetLocation();
        _getCurrentLocation(); // Actualise la position toutes les 10 minutes
      } else {
        // If the widget is unmounted, cancel the timer to prevent further updates
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent calling setState() after dispose
    _locationUpdateTimer.cancel();
    super.dispose();
  }

// Declare the timer variable at the top of your State class

  Future<void> _requestPermissionAndGetLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Gérer le cas où l'utilisateur a refusé l'autorisation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Autorisation requise'),
          content: Text(
              'Veuillez autoriser l\'accès à la position pour afficher les hôtels à proximité.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (permission == LocationPermission.deniedForever) {
      // Gérer le cas où l'utilisateur a définitivement refusé l'autorisation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Autorisation refusée'),
          content: Text(
              'Vous avez définitivement refusé l\'accès à la position. Pour activer l\'accès, veuillez aller dans les paramètres de l\'application.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // L'utilisateur a autorisé l'accès à la position, obtenir la position actuelle
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
      _fetchHotelsFromFirebase();
    } catch (e) {
      print("Erreur lors de la récupération de la position: $e");
    }
  }

  Future<void> _fetchHotelsFromFirebase() async {
    QuerySnapshot hotelSnapshot =
        await FirebaseFirestore.instance.collection('hotels').get();

    setState(() {
      nearbys = hotelSnapshot.docs.map((doc) {
        return Hotel(
          title: doc['title'],
          latitude: (doc['latitude'] as num).toDouble(), // Convertir en double
          longitude:
              (doc['longitude'] as num).toDouble(), // Convertir en double
          rating: (doc['rating'] as num).toDouble(), // Convertir en double
          reviews: doc['reviews'] as int,
          adresse: doc['adresse'],
          price: doc['price'] as int,
          discount: doc['discount'] as int,
          photo1: doc['photos']['photo1'],
          photo2: doc['photos']['photo2'],
          photo3: doc['photos']['photo3'],
        );
      }).toList();

      if (currentPosition != null) {
        nearbys.sort((hotel1, hotel2) {
          double distance1 = _calculateDistance(currentPosition!.latitude,
              currentPosition!.longitude, hotel1.latitude, hotel1.longitude);
          double distance2 = _calculateDistance(currentPosition!.latitude,
              currentPosition!.longitude, hotel2.latitude, hotel2.longitude);
          return distance1.compareTo(distance2);
        });
      }
      isLoading = false;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Nearby Hotels 10 Km',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xFF06B3C4),
            ))
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListView.separated(
                  itemCount: nearbys.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 20); // Espace entre chaque élément
                  },
                  itemBuilder: (context, index) {
                    return buildHotelCard2(index);
                  },
                ),
              ),
            ),
    );
  }

  Widget buildHotelCard2(int index) {
    final nearby = nearbys[index];
    if (_calculateDistance(currentPosition!.latitude,
            currentPosition!.longitude, nearby.latitude, nearby.longitude) <
        10.00) {
      return InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.srcATop,
                    ),
                    child: Image.network(
                      nearby
                          .photo3, // Utilisez directement l'URL de l'image depuis votre modèle
                      width: 100,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF06B3C4),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons
                            .error); // Widget à afficher en cas d'erreur de chargement de l'image
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${nearby.title}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        "${nearby.adresse}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Text('\MAD ${nearby.price} / Night'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('⭐${nearby.rating.toStringAsFixed(1)} '),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${_calculateDistance(currentPosition!.latitude, currentPosition!.longitude, nearby.latitude, nearby.longitude).toStringAsFixed(2)} km',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
