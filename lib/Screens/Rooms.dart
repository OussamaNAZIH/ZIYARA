import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:flutter_pfe/Screens/details_rooms.dart';

class Book extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  dynamic dataList;
  int? rooms;
  int? Children;
  int? Adults;
  int? roommin;
  DateTime? datefin;
  DateTime? datedebut;
  int? startyear;
  int? endyear;

  Book(
      {super.key,
      required this.endyear,
      required this.startyear,
      required this.datedebut,
      required this.datefin,
      required this.rooms,
      required this.Children,
      required this.Adults,
      required this.roommin,
      required this.dataList,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  late int chamspValue;
  late int chamdbValue;
  late int suitesValue = 0;

  @override
  void initState() {
    super.initState();
    if (widget.datedebut != null && widget.datefin != null) {
      fetchReservations(widget.datedebut!, widget.datefin!);
    } else {
      // Handle the case where startDate or endDate is null
      setState(() {
        isLoading = false;
      });
    }
    // Calculer les valeurs initiales de chamspValue et chamdbValue
    chamspValue = ((widget.Adults! + widget.Children!) % 2).toInt();
    chamdbValue = ((widget.Adults! + widget.Children!) ~/ 2).toInt();

    // Vérifier si chamdbValue est supérieur à la disponibilité des chamdb
    if (chamdbValue >= widget.dataList['chamdb']['dispo']) {
      // Calculer la quantité supplémentaire de chambres simples nécessaires
      int additionalChamsp =
          ((chamdbValue - widget.dataList['chamdb']['dispo']) * 2).toInt();
      chamspValue += additionalChamsp;
      // Réduire chamdbValue à la disponibilité des chamdb
      chamdbValue = widget.dataList['chamdb']['dispo'];
    }
    if (chamspValue >= widget.dataList['chamsp']['dispo']) {
      // Calculer la quantité supplémentaire de chambres simples nécessaires
      int additionalChamdb =
          ((chamspValue - widget.dataList['chamsp']['dispo']) * 1).toInt();
      chamdbValue += additionalChamdb;
      // Réduire chamdbValue à la disponibilité des chamdb
      chamspValue = widget.dataList['chamsp']['dispo'];
    }
    if (chamspValue >= widget.dataList['chamsp']['dispo']) {
      int additionalSuites =
          (chamspValue - widget.dataList['chamsp']['dispo']) ~/ 2;
      suitesValue += additionalSuites;
      chamspValue = widget.dataList['chamsp']['dispo'];
    }
    if (suitesValue >= widget.dataList['suites']['dispo']) {
      suitesValue = widget.dataList['suites']['dispo'];
    }

    // Mettre à jour les valeurs des variables d'état
    setState(() {
      chamspValue = chamspValue;
      chamdbValue = chamdbValue;
      suitesValue = suitesValue;
    });
    print(' nomber de chamber simple  $chamspValue');
    print(' nomber de chamber double  $chamdbValue');
    print(' nomber de chamber suites  $suitesValue');
  }

  calculateTotal() {
    num total = (chamspValue * widget.dataList['chamsp']['price']) +
        (chamdbValue * widget.dataList['chamdb']['price']) +
        (suitesValue * widget.dataList['suites']['price']);

    return '$total';
  }

  getiduser() {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user!.uid;
    return '$userId';
  }

  void updateDispo(
      String hotelId, int chamspValue, int chamdbValue, int suitesValue) async {
    var firestore = FirebaseFirestore.instance;

    var hotelDoc = firestore.collection('hotels').doc(hotelId);

    var snapshot = await hotelDoc.get();
    if (snapshot.exists) {
      int currentDispoChamsp = snapshot.data()!['chamsp']['dispo'];
      int currentreserverChamsp = snapshot.data()!['chamsp']['reserver'];

      int currentDispoChamdb = snapshot.data()!['chamdb']['dispo'];
      int currentreserverChamdb = snapshot.data()!['chamdb']['reserver'];

      int currentDispoSuite = snapshot.data()!['suites']['dispo'];
      int currentreserverSuite = snapshot.data()!['suites']['reserver'];

      int newDispoChamsp = currentDispoChamsp - chamspValue;
      int newReserverChamsp = currentreserverChamsp + chamspValue;

      int newDispoChamdb = currentDispoChamdb - chamdbValue;
      int newReservrrChamsdb = currentreserverChamdb + chamdbValue;

      int newDispoSuite = currentDispoSuite - suitesValue;
      int newReserverSuite = currentreserverSuite + suitesValue;

      newDispoChamsp = newDispoChamsp < 0 ? 0 : newDispoChamsp;
      newReserverChamsp = newReserverChamsp < 0 ? 0 : newReserverChamsp;
      newDispoChamdb = newDispoChamdb < 0 ? 0 : newDispoChamdb;
      newReservrrChamsdb = newReservrrChamsdb < 0 ? 0 : newReservrrChamsdb;
      newDispoSuite = newDispoSuite < 0 ? 0 : newDispoSuite;
      newReserverSuite = newReserverSuite < 0 ? 0 : newReserverSuite;

      await hotelDoc.update({
        'chamsp.dispo': newDispoChamsp,
        'chamsp.reserver': newReserverChamsp,
        'chamdb.dispo': newDispoChamdb,
        'chamdb.reserver': newReservrrChamsdb,
        'suites.dispo': newDispoSuite,
        'suites.reserver': newReserverSuite
      }).then((_) {
        print('Dispo updated to $newDispoChamsp');
        print('Reserver updated to $newReserverChamsp');
        print('Reserver updated to $newReservrrChamsdb');
        print('Dispo updated to $newDispoChamdb');
        print('Dispo updated to $newDispoSuite');
        print('Reserver updated to $newReserverSuite');
      }).catchError((error) {
        print('Failed to update dispo: $error');
      });
    } else {
      print('Hotel not found!');
    }
  }

  List<QueryDocumentSnapshot> reservations = [];
  bool isLoading = true;
  num totalChamdbValue = 0;
  num totalChamspValue = 0;
  num totalSuitesValue = 0;

  void fetchReservations(DateTime startDate, DateTime endDate) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // First query: get reservations with datedebut within the interval
    QuerySnapshot query1 = await firestore
        .collection('reservation')
        .where('datedebut',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
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
    totalSuitesValue = 0;

    for (var reservation in reservations) {
      var data = reservation.data() as Map<String, dynamic>;
      totalChamdbValue += data['chamdbValue'] ?? 0;
      totalChamspValue += data['chamspValue'] ?? 0;
      totalSuitesValue += data['suitesValue'] ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Pour s'assurer que le Column prend seulement l'espace nécessaire
              children: <Widget>[
                const Text('Choose Rooms',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${widget.dataList['title']}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          centerTitle: true,
          // title: const Center(
          //   child: Column(
          //     children: [Text('choose Rooms',style: TextStyle(fontSize: 10),), Text('Sofitel Rabat',style: TextStyle(fontSize: 10),)],
          //   ),
          // ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.dataList['chamsp']['title']}",
                                          style: const TextStyle(
                                            color: Color(0xFF06B3C4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Non-refundable",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.view_in_ar_outlined,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'No prepayment needed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' - pay ',
                                            ),
                                          ],
                                        ),
                                        const Text('          the property'),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.family_restroom_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Price for ${widget.dataList['chamsp']['nbperson']} adults',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.bed_sharp,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              '${widget.dataList['chamsp']['beds']} queen bed',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .photo_size_select_small_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Room size : ${widget.dataList['chamsp']['size']}',
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.coffee,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Breakfast avaible,pay at the prorerty',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        // Text(
                                        //   '          prorerty',
                                        //   style: TextStyle(
                                        //       color:
                                        //           Color.fromARGB(255, 12, 224, 22)),
                                        // ),

                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.wifi,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Free wifi ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Balcony ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.local_florist_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Granden view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.pool,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Pool view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.location_city,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'City view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Minibar',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.ac_unit_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Air conditiong  ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.bathtub_outlined,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Private Bathroom ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.tv,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Flat-screen TV ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons
                                                  .integration_instructions_sharp,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Soundproof ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Coffee machine ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ' pool with a view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'reserver : ${widget.dataList['chamsp']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${15 - widget.dataList['chamsp']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'Price for ${widget.dataList['chamsp']['price']} night (9 Mar - 10 Mar) ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Text(
                                          'MAD ${widget.dataList['chamsp']['price']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '+MAD 99 taxes and fees',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.srcATop,
                                          ),
                                          child: Image.asset(
                                            'images/sofitel.jpg',
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        items: List.generate(
                                          (chamspValue >
                                                  widget.dataList['chamsp']
                                                          ['dispo'] -
                                                      totalChamspValue)
                                              ? 0
                                              : (widget.dataList['chamsp']
                                                          ['dispo'] -
                                                      totalChamspValue) +
                                                  1,
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Text('$index'),
                                          ),
                                        ),
                                        // Valeur initiale
                                        value: chamspValue,
                                        onChanged: (value) {
                                          // Mettre à jour la valeur sélectionnée
                                          setState(() {
                                            chamspValue = value!;
                                          });
                                          // Faire quelque chose avec la valeur sélectionnée
                                          print(
                                              'Vous avez sélectionné la valeur : $value');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // const Spacer(),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => detailsRooms(
                              //                   startday: widget.startday,
                              //                   startmonth: widget.startmonth,
                              //                   endday: widget.endday,
                              //                   endmonth: widget.endmonth,
                              //                   dataList: widget.dataList,
                              //                   roomData:
                              //                       widget.dataList['chamsp'],
                              //                 )));
                              //     print(widget.dataList);
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(10),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20),
                              //       color: const Color(0xFF06B3C4),
                              //     ),
                              //     child: const Center(
                              //         child: Text('Select',
                              //             style: TextStyle(
                              //                 color: Color.fromARGB(
                              //                     255, 255, 255, 255),
                              //                 fontWeight: FontWeight.bold))),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.dataList['chamdb']['title']}",
                                          style: const TextStyle(
                                            color: Color(0xFF06B3C4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Non-refundable",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.view_in_ar_outlined,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'No prepayment needed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' - pay ',
                                            ),
                                          ],
                                        ),
                                        const Text('          the property'),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.family_restroom_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Price for ${widget.dataList['chamdb']['nbperson']} adults',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.bed_sharp,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              '${widget.dataList['chamdb']['beds']} queen bed',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .photo_size_select_small_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Room size : ${widget.dataList['chamdb']['size']}',
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.coffee,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Breakfast avaible,pay at the prorerty',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        // Text(
                                        //   '          prorerty',
                                        //   style: TextStyle(
                                        //       color:
                                        //           Color.fromARGB(255, 12, 224, 22)),
                                        // ),

                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.wifi,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Free wifi ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Balcony ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.local_florist_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Granden view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.pool,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Pool view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.location_city,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'City view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Minibar',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.ac_unit_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Air conditiong  ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.bathtub_outlined,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Private Bathroom ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.tv,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Flat-screen TV ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons
                                                  .integration_instructions_sharp,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Soundproof ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Coffee machine ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ' pool with a view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'reserver : ${widget.dataList['chamdb']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${15 - widget.dataList['chamdb']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        const Text(
                                          'Price for 1 night (9 Mar - 10 Mar) ',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Text(
                                          'MAD ${widget.dataList['chamdb']['price']}',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '+MAD 99 taxes and fees',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.srcATop,
                                          ),
                                          child: Image.asset(
                                            'images/sofitel.jpg',
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        items: List.generate(
                                          (chamdbValue >
                                                  (widget.dataList['chamdb']
                                                          ['dispo'] -
                                                      totalChamdbValue))
                                              ? 0
                                              : (widget.dataList['chamdb']
                                                          ['dispo'] -
                                                      totalChamdbValue) +
                                                  1,
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Text('$index'),
                                          ),
                                        ),
                                        // Valeur initiale
                                        value: (chamdbValue >
                                                widget.dataList['chamdb']
                                                        ['dispo'] -
                                                    totalChamdbValue)
                                            ? 0
                                            : chamdbValue,
                                        onChanged: (value) {
                                          // Mettre à jour la valeur sélectionnée
                                          setState(() {
                                            chamdbValue = value!;
                                          });
                                          // Faire quelque chose avec la valeur sélectionnée
                                          print(
                                              'Vous avez sélectionné la valeur : $value');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // const Spacer(),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => detailsRooms(
                              //                   startday: widget.startday,
                              //                   startmonth: widget.startmonth,
                              //                   endday: widget.endday,
                              //                   endmonth: widget.endmonth,
                              //                   dataList: widget.dataList,
                              //                   roomData:
                              //                       widget.dataList['chamdb'],
                              //                 )));
                              //     print(widget.dataList['chamdb']);
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(10),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20),
                              //       color: const Color(0xFF06B3C4),
                              //     ),
                              //     child: const Center(
                              //         child: Text('Select',
                              //             style: TextStyle(
                              //                 color: Color.fromARGB(
                              //                     255, 255, 255, 255),
                              //                 fontWeight: FontWeight.bold))),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          " ${widget.dataList['suites']['title']}",
                                          style: const TextStyle(
                                            color: Color(0xFF06B3C4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Non-refundable",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.view_in_ar_outlined,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'No prepayment needed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' - pay ',
                                            ),
                                          ],
                                        ),
                                        const Text('          the property'),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.family_restroom_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Price for  ${widget.dataList['suites']['nbperson']} adults',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.bed_sharp,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              '${widget.dataList['suites']['beds']} queen bed',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .photo_size_select_small_outlined,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Room size :  ${widget.dataList['suites']['size']}',
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.coffee,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Breakfast avaible,pay at the prorerty',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        // Text(
                                        //   '          prorerty',
                                        //   style: TextStyle(
                                        //       color:
                                        //           Color.fromARGB(255, 12, 224, 22)),
                                        // ),

                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.wifi,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Free wifi ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Balcony ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.local_florist_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Granden view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.pool,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Pool view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.location_city,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'City view ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Minibar',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.ac_unit_rounded,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Air conditiong  ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.bathtub_outlined,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Private Bathroom ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.tv,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Flat-screen TV ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons
                                                  .integration_instructions_sharp,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Soundproof ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Coffee machine ',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 12, 224, 22),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ' pool with a view',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 12, 224, 22)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'reserver : ${widget.dataList['suites']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${2 - widget.dataList['suites']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        const Text(
                                          'Price for 1 night (9 Mar - 10 Mar) ',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Text(
                                          'MAD  ${widget.dataList['suites']['price']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '+MAD 99 taxes and fees',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.srcATop,
                                          ),
                                          child: Image.asset(
                                            'images/sofitel.jpg',
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        items: List.generate(
                                          (suitesValue >
                                                  (widget.dataList['suites']
                                                          ['dispo'] -
                                                      totalSuitesValue))
                                              ? 0
                                              : (widget.dataList['suites']
                                                          ['dispo'] -
                                                      totalSuitesValue) +
                                                  1,
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Text('$index'),
                                          ),
                                        ),
                                        // Valeur initiale
                                        value: (suitesValue >
                                                (widget.dataList['suites']
                                                        ['dispo'] -
                                                    totalSuitesValue))
                                            ? 0
                                            : suitesValue,
                                        onChanged: (value) {
                                          // Mettre à jour la valeur sélectionnée
                                          setState(() {
                                            suitesValue = value!;
                                          });
                                          // Faire quelque chose avec la valeur sélectionnée
                                          print(
                                              'Vous avez sélectionné la valeur : $value');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 detailsRooms(
                              //                   startday: widget.startday,
                              //                   startmonth:
                              //                       widget.startmonth,
                              //                   endday: widget.endday,
                              //                   endmonth: widget.endmonth,
                              //                   dataList: widget.dataList,
                              //                   roomData: widget
                              //                       .dataList['suites'],
                              //                 )));
                              //     print(widget.dataList['suites']);
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(10),
                              //     decoration: BoxDecoration(
                              //       borderRadius:
                              //           BorderRadius.circular(20),
                              //       color: const Color(0xFF06B3C4),
                              //     ),
                              //     child: const Center(
                              //         child: Text('Select',
                              //             style: TextStyle(
                              //                 color: Color.fromARGB(
                              //                     255, 255, 255, 255),
                              //                 fontWeight:
                              //                     FontWeight.bold))),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 125,
                    color: Colors.white,
                    child: const Text(
                      'data',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF06B3C4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      Radius.zero, // Pas de radius pour le coin en bas à gauche
                  bottomRight:
                      Radius.zero, // Pas de radius pour le coin en bas à droite
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Prend seulement l'espace nécessaire
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.Children == 0
                                ? 'Recommended for ${widget.Adults} adults. No children'
                                : 'Recommended for ${widget.Adults} adults and ${widget.Children} children'),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          Text(
                              (chamspValue != 0
                                      ? '$chamspValue x chamber simple  '
                                      : '') +
                                  (chamdbValue != 0
                                      ? '$chamdbValue x chamber double  '
                                      : '') +
                                  (suitesValue != 0
                                      ? '$suitesValue x chamber Suite'
                                      : ''),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(width: 40),
                          Text(
                            (chamspValue != 0
                                    ? '$chamspValue x  MAD ${widget.dataList['chamsp']['price']}  '
                                    : '') +
                                (chamdbValue != 0
                                    ? '  $chamdbValue x  MAD ${widget.dataList['chamdb']['price']}  '
                                    : '') +
                                (suitesValue != 0
                                    ? '  $suitesValue x  MAD ${widget.dataList['suites']['price']}'
                                    : ''),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          // const Text(
                          //   'size Bed',
                          //   style: TextStyle(
                          //       color: Color.fromARGB(255, 255, 255, 255)),
                          // ),
                          Row(
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 100),
                              Text(
                                calculateTotal(),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if ((widget.Adults! + widget.Children!) >
                            (chamspValue +
                                (chamdbValue * 2) +
                                (suitesValue * 2))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 4),
                              backgroundColor: Color.fromARGB(255, 181, 22, 22),
                              content: Text(
                                'You still need to fit ${(widget.Adults! + widget.Children!) - (chamspValue + (chamdbValue * 2) + (suitesValue * 2))} more Personnes. Check how many guests the available options can sleep.',
                                style: TextStyle(fontSize: 20),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                              ),
                              // behavior: SnackBarBehavior
                              //     ., // Afficher le SnackBar en haut de l'écran
                              // padding: EdgeInsets.only(
                              //     top: MediaQuery.of(context).viewInsets.top +
                              //         20.0), // Ajuster la marge supérieure
                            ),
                          );
                        } else {
                          CollectionReference collRef = FirebaseFirestore
                              .instance
                              .collection('reservation');
                          DocumentReference docRef = collRef.doc();
                          String docId = docRef.id;
                          collRef.add({
                            'id': docId,
                            'userid': getiduser(),
                            'hotelId': widget.dataList['hotelid'],
                            'startday': widget.startday,
                            'startmonth': widget.startmonth,
                            'startyear': widget.startyear,
                            'endday': widget.endday,
                            'endmonth': widget.endmonth,
                            'endyear': widget.endyear,
                            'rooms': suitesValue + chamspValue + chamdbValue,
                            'Children': widget.Children,
                            'Adults': widget.Adults,
                            'chamdbValue': chamdbValue,
                            'chamspValue': chamspValue,
                            'suitesValue': suitesValue,
                            'email': widget.dataList['hotelEmail'],
                            'title': widget.dataList['title'],
                            'adresse': widget.dataList['adresse'],
                            'rating': widget.dataList['rating'],
                            'reviews': widget.dataList['reviews'],
                            'price': calculateTotal(),
                            'photo': widget.dataList['photos']['photo3'],
                            'datedebut': widget.datedebut,
                            'datefin': widget.datefin,
                          });
                          // updateDispo(widget.dataList['hotelid'], chamspValue,
                          //     chamdbValue, suitesValue);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailsRooms(
                                        rooms: suitesValue +
                                            chamspValue +
                                            chamdbValue,
                                        startyear: widget.startyear,
                                        endyear: widget.endyear,
                                        Children: widget.Children,
                                        Adults: widget.Adults,
                                        suitesValue: suitesValue,
                                        chamspValue: chamspValue,
                                        chamdbValue: chamdbValue,
                                        startday: widget.startday,
                                        startmonth: widget.startmonth,
                                        endday: widget.endday,
                                        endmonth: widget.endmonth,
                                        dataList: widget.dataList,
                                        email: widget.dataList['hotelEmail'],
                                        Total: calculateTotal(),
                                        userid: getiduser(),
                                      )));
                        }
                        print(getiduser());
                      },
                      child: Container(
                        width: double
                            .infinity, // Fait en sorte de prendre toute la largeur
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: const Center(
                          child: Text(
                            'Reserve these rooms',
                            style: TextStyle(
                                color: Color(0xFF06B3C4),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
