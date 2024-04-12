import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Hotel {
  final String id;
  final String address;
  final String city;
  final double discount;
  final double latitude;
  final double longitude;
  final String photo1;
  // final Map<String, String> photos;
  final int price;
  final double rating;
  final int reviews;
  final String title;

  Hotel({
    required this.id,
    required this.address,
    required this.city,
    required this.discount,
    required this.latitude,
    required this.longitude,
    required this.photo1,
    // required this.photos,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.title,
  });

  // Factory method to create Hotel object from a DocumentSnapshot
  factory Hotel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Hotel(
      id: snapshot.id,
      address: data['address'],
      city: data['city'],
      discount: data['discount'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      photo1: data['photo1'],
      // photos: data['photos'] != null
      //     ? Map<String, String>.from(data['photos'])
      //     : {},
      price: data['price'],
      rating: data['rating'],
      reviews: data['reviews'],
      title: data['title'],
    );
  }
}

Future<List<Hotel>> fetchHotels() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('hotels').get();
    List<Hotel> hotels = [];
    for (var doc in querySnapshot.docs) {
      Hotel hotel = Hotel.fromSnapshot(doc);
      hotels.add(hotel);
    }
    return hotels;
  } catch (e) {
    print('Error fetching hotels: $e');
    return [];
  }
}

Hotel findNearestHotel(
    List<Hotel> hotels, double userLatitude, double userLongitude) {
  Hotel nearestHotel = hotels.first;
  double minDistance = double.infinity;

  for (final hotel in hotels) {
    final distance = calculateDistance(
        hotel.latitude, hotel.longitude, userLatitude, userLongitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestHotel = hotel;
    }
  }

  return nearestHotel;
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  final latDifference = lat1 - lat2;
  final lonDifference = lon1 - lon2;
  return sqrt(latDifference * latDifference + lonDifference * lonDifference);
}

class NearestHotelWidget extends StatefulWidget {
  const NearestHotelWidget({super.key});

  @override
  _NearestHotelWidgetState createState() => _NearestHotelWidgetState();
}

class _NearestHotelWidgetState extends State<NearestHotelWidget> {
  late Hotel _nearestHotel;

  @override
  void initState() {
    super.initState();
    _fetchNearestHotel();
  }

  Future<void> _fetchNearestHotel() async {
    const userLatitude = 6.837755; // Latitude de l'utilisateur
    const userLongitude = 33.990235; // Longitude de l'utilisateur

    List<Hotel> hotels = await fetchHotels();
    if (hotels.isNotEmpty) {
      final nearestHotel =
          findNearestHotel(hotels, userLatitude, userLongitude);
      setState(() {
        _nearestHotel = nearestHotel;
      });
    } else {
      print('Aucun hôtel trouvé.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  _nearestHotel
                      .photo1, // Utilisez le lien de la première photo de l'hôtel le plus proche
                  width: 100,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nearestHotel
                        .title, // Utilisez le titre de l'hôtel le plus proche
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    _nearestHotel
                        .address, // Utilisez l'adresse de l'hôtel le plus proche
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                          '\$ ${_nearestHotel.price} / Night'), // Utilisez le prix de l'hôtel le plus proche
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                          '⭐${_nearestHotel.rating} (${_nearestHotel.reviews})'), // Utilisez le rating et le nombre d'avis de l'hôtel le plus proche
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Nearest Hotel')),
      body: const NearestHotelWidget(),
    ),
  ));
}
