// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reservation App',
//       home: ReservationScreen(),
//     );
//   }
// }

// class ReservationScreen extends StatefulWidget {
//   @override
//   _ReservationScreenState createState() => _ReservationScreenState();
// }

// class _ReservationScreenState extends State<ReservationScreen> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   List<DocumentSnapshot> _reservations = [];

//   final _dateFormat = DateFormat('dd/MM/yyyy');

//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   Future<void> _getReservations() async {
//     if (_startDate == null || _endDate == null) {
//       // Affiche un message d'erreur ou une alerte
//       return;
//     }

//     final startDate = _startDate!;
//     final endDate = _endDate!;
//     final startTimestamp = Timestamp.fromDate(startDate);
//     final endTimestamp = Timestamp.fromDate(endDate);

//     final startQuerySnapshot = await FirebaseFirestore.instance
//         .collection('reservations')
//         .where('datedebut', isLessThanOrEqualTo: endTimestamp)
//         .get();

//     final endQuerySnapshot = await FirebaseFirestore.instance
//         .collection('reservations')
//         .where('datefin', isGreaterThanOrEqualTo: startTimestamp)
//         .get();

//     final combinedReservations = <DocumentSnapshot>[];

//     for (var doc in startQuerySnapshot.docs) {
//       final reservation = doc.data() as Map<String, dynamic>;
//       final reservationEnd = (reservation['datefin'] as Timestamp).toDate();
//       if (reservationEnd.isAfter(startDate) || reservationEnd.isAtSameMomentAs(startDate)) {
//         combinedReservations.add(doc);
//       }
//     }

//     for (var doc in endQuerySnapshot.docs) {
//       final reservation = doc.data() as Map<String, dynamic>;
//       final reservationStart = (reservation['datedebut'] as Timestamp).toDate();
//       if ((reservationStart.isBefore(endDate) || reservationStart.isAtSameMomentAs(endDate)) &&
//           !combinedReservations.contains(doc)) {
//         combinedReservations.add(doc);
//       }
//     }

//     setState(() {
//       _reservations = combinedReservations;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reservation App'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       hintText: _startDate == null
//                           ? 'Select start date'
//                           : _dateFormat.format(_startDate!),
//                     ),
//                     onTap: () => _selectDate(context, true),
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//                 Expanded(
//                   child: TextField(
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       hintText: _endDate == null
//                           ? 'Select end date'
//                           : _dateFormat.format(_endDate!),
//                     ),
//                     onTap: () => _selectDate(context, false),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _getReservations,
//               child: Text('Get Reservations'),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _reservations.length,
//                 itemBuilder: (context, index) {
//                   final reservation = _reservations[index].data() as Map<String, dynamic>;
//                   return ListTile(
//                     title: Text(reservation['adresse'] ?? 'No address'),
//                     subtitle: Text(
//                         'Adults: ${reservation['Adults']}, Children: ${reservation['Children']}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
