import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pfe/Screens/Booking.dart';
import 'package:flutter_pfe/Screens/MyBookingScreen.dart';
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

  Book(
      {super.key,
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
  late int chamspValue = ((widget.Adults! + widget.Children!) % 2).toInt();

  late int chamdbValue = ((widget.Adults! + widget.Children!) ~/ 2).toInt();

  int suitesValue = 0;

  calculateTotal() {
    num total = (chamspValue * widget.dataList['chamsp']['price']) +
        (chamdbValue * widget.dataList['chamdb']['price']) +
        (suitesValue * widget.dataList['suites']['price']);

    return 'MAD $total';
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
                                        // Utilisez dataList['dispo'].length au lieu de dataList['dispo']
                                        items: List.generate(
                                          widget.dataList['chamsp']['dispo'] -
                                              widget.dataList['chamsp']
                                                  ['reserver'],
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Text(
                                                '$index '), // Pour afficher les nombres à partir de 1
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
                                        // Utilisez dataList['dispo'].length au lieu de dataList['dispo']
                                        items: List.generate(
                                          widget.dataList['chamdb']['dispo'] -
                                              widget.dataList['chamdb']
                                                  ['reserver'],
                                          (index) => DropdownMenuItem<int>(
                                            value: index,
                                            child: Text(
                                                '$index'), // Pour afficher les nombres à partir de 1
                                          ),
                                        ),
                                        // Valeur initiale
                                        value: chamdbValue,
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
                        child: widget.dataList['suites']['dispo'] -
                                    widget.dataList['suites']['reserver'] ==
                                0
                            ? const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    // Votre contenu ici pour le cas où dataList.length == 0
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    ' - pay ',
                                                  ),
                                                ],
                                              ),
                                              const Text(
                                                  '          the property'),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .family_restroom_outlined,
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
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),

                                              Text(
                                                'dispo : ${2 - widget.dataList['suites']['reserver']} ',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),

                                              const Text(
                                                'Price for 1 night (9 Mar - 10 Mar) ',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                              Text(
                                                'MAD  ${widget.dataList['suites']['price']} ',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text(
                                                '+MAD 99 taxes and fees',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              items: [
                                                // Créer un élément pour la valeur 0
                                                const DropdownMenuItem<int>(
                                                  value: 0,
                                                  child: Text('0'),
                                                ),
                                                // Générer dynamiquement les autres éléments
                                                ...List.generate(
                                                  widget.dataList['suites']
                                                          ['dispo'] -
                                                      widget.dataList['suites']
                                                          ['reserver'],
                                                  (index) =>
                                                      DropdownMenuItem<int>(
                                                    value: index + 1,
                                                    child: Text('${index + 1}'),
                                                  ),
                                                ),
                                              ],
                                              value: suitesValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  suitesValue = value!;
                                                });
                                                print(
                                                    'Vous avez sélectionné la valeur : $value et la valeur de $suitesValue ');
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailsRooms(
                                      startday: widget.startday,
                                      startmonth: widget.startmonth,
                                      endday: widget.endday,
                                      endmonth: widget.endmonth,
                                      dataList: widget.dataList,
                                      roomData: widget.dataList['chamsp'],
                                    )));
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
