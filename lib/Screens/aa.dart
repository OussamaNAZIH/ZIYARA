import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  ReservationPage({required this.startDate, required this.endDate});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<QueryDocumentSnapshot> reservations = [];
  bool isLoading = true;
  num totalChamdbValue = 0;
  num totalChamspValue = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startDate != null && widget.endDate != null) {
      fetchReservations(widget.startDate!, widget.endDate!);
    } else {
      // Handle the case where startDate or endDate is null
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchReservations(DateTime startDate, DateTime endDate) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // First query: get reservations with datedebut within the interval
    QuerySnapshot query1 = await firestore
        .collection('reservation')
        .where('datedebut', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('datedebut', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    // Second query: get reservations with datefin within the interval
    QuerySnapshot query2 = await firestore
        .collection('reservation')
        .where('datefin', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('datefin', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    // Combine results and remove duplicates
    Map<String, QueryDocumentSnapshot> reservationMap = {};
    for (var doc in query1.docs) {
      reservationMap[doc.id] = doc;
    }
    for (var doc in query2.docs) {
      reservationMap[doc.id] = doc;
    }

    setState(() {
      reservations = reservationMap.values.toList();
      calculateTotals();
      isLoading = false;
    });
  }

  void calculateTotals() {
    totalChamdbValue = 0;
    totalChamspValue = 0;

    for (var reservation in reservations) {
      var data = reservation.data() as Map<String, dynamic>;
      totalChamdbValue += data['chamdbValue'] ?? 0;
      totalChamspValue += data['chamspValue'] ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservations"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Chamdb Value: $totalChamdbValue"),
                      Text("Total Chamsp Value: $totalChamspValue"),
                    ],
                  ),
                ),
                Expanded(
                  child: reservations.isEmpty
                      ? Center(child: Text("No reservations found"))
                      : ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            var reservation = reservations[index].data() as Map<String, dynamic>;
                            return Card(
                              child: ListTile(
                                title: Text("Hotel ID: ${reservation['hotelId']}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Adults: ${reservation['Adults']}"),
                                    Text("Children: ${reservation['Children']}"),
                                    Text("Address: ${reservation['adresse']}"),
                                    Text("Chamdb Value: ${reservation['chamdbValue']}"),
                                    Text("Chamsp Value: ${reservation['chamspValue']}"),
                                    Text("Start Date: ${reservation['datedebut'].toDate()}"),
                                    Text("End Date: ${reservation['datefin'].toDate()}"),
                                    Image.network(reservation['photo']),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
