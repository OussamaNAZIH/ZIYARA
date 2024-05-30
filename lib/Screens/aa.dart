import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatelessWidget {
  DateTime startDate = DateTime(2024, 4, 23);
  DateTime endDate = DateTime(2024, 4, 27);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final reservations = snapshot.data!.docs;
          final filteredReservations = reservations.where((reservation) {
            final reservationStartDate =
                DateTime.parse(reservation['datedebut']);
            final reservationEndDate = DateTime.parse(reservation['datefin']);
            return reservationStartDate.isBefore(endDate) &&
                reservationEndDate.isAfter(startDate);
          }).toList();
          return ListView.builder(
            itemCount: filteredReservations.length,
            itemBuilder: (context, index) {
              final reservation = filteredReservations[index];
              return ListTile(
                title: Text(reservation['title']),
                subtitle: Text('Adresse: ${reservation['adresse']}'),
                leading: Image.network(reservation['photo']),
                trailing: Text('Prix: ${reservation['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
