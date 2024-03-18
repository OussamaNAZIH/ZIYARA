import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Booking.dart';
import 'package:flutter_pfe/Screens/MyBookingScreen.dart';
import 'package:flutter_pfe/Screens/details_rooms.dart';

class Book extends StatelessWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  dynamic dataList;

  Book(
      {super.key,
      required this.dataList,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$startmonth $startday'),

          // title: const Center(
          //   child: Column(
          //     children: [Text('choose Rooms',style: TextStyle(fontSize: 10),), Text('Sofitel Rabat',style: TextStyle(fontSize: 10),)],
          //   ),
          // ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
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
                          color: const Color.fromARGB(255, 19, 226, 36),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recommended for 6 adults',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '3 x Superior Room with King -',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 40,
                                            ),
                                            Text('3 x MAD 23,000')
                                          ],
                                        ),
                                        Text(
                                          'size Bed',
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 100,
                                            ),
                                            Text('MAD 69.000')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detailsRooms(
                                                startday: startday,
                                                startmonth: startmonth,
                                                endday: endday,
                                                endmonth: endmonth,
                                                dataList: dataList,
                                              )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF06B3C4),
                                  ),
                                  child: const Center(
                                      child: Text('Reserve these rooms',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
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
                    height: 450,
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
                                          "${dataList['Rooms']['ChamSp']['Title']}",
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
                                              'Price for ${dataList['Rooms']['ChamSp']['Nbperson']} adults',
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
                                              '${dataList['Rooms']['ChamSp']['beds']} queen bed',
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
                                              'Room size : ${dataList['Rooms']['ChamSp']['size']}',
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
                                          'reserver : ${dataList['Rooms']['ChamSp']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${15 - dataList['Rooms']['ChamSp']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'Price for ${dataList['Rooms']['ChamSp']['Price']} night (9 Mar - 10 Mar) ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        Text(
                                          'MAD ${dataList['Rooms']['ChamSp']['Price']} ',
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
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detailsRooms(
                                                startday: startday,
                                                startmonth: startmonth,
                                                endday: endday,
                                                endmonth: endmonth,
                                                dataList: dataList,
                                              )));
                                  print(dataList['Rooms']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF06B3C4),
                                  ),
                                  child: const Center(
                                      child: Text('Select',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
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
                    height: 450,
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
                                          "${dataList['Rooms']['ChamSp']['Title']}",
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
                                              'Price for ${dataList['Rooms']['Chamdb']['Nbperson']} adults',
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
                                              '${dataList['Rooms']['Chamdb']['beds']} queen bed',
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
                                              'Room size : ${dataList['Rooms']['Chamdb']['size']}',
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
                                          'reserver : ${dataList['Rooms']['Chamdb']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${15 - dataList['Rooms']['Chamdb']['reserver']} ',
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
                                          'MAD ${dataList['Rooms']['Chamdb']['Price']}',
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
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detailsRooms(
                                                startday: startday,
                                                startmonth: startmonth,
                                                endday: endday,
                                                endmonth: endmonth,
                                                dataList: dataList,
                                              )));
                                  print(dataList['Rooms']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF06B3C4),
                                  ),
                                  child: const Center(
                                      child: Text('Select',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
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
                    height: 450,
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
                                          " ${dataList['Rooms']['Suites']['Title']}",
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
                                              'Price for  ${dataList['Rooms']['Suites']['Nbperson']} adults',
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
                                              '${dataList['Rooms']['Suites']['beds']} queen bed',
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
                                              'Room size :  ${dataList['Rooms']['Suites']['size']}',
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
                                          'reserver : ${dataList['Rooms']['Suites']['reserver']} ',
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),

                                        Text(
                                          'dispo : ${2 - dataList['Rooms']['ChamSp']['reserver']} ',
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
                                          'MAD  ${dataList['Rooms']['Suites']['Price']} ',
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
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detailsRooms(
                                                startday: startday,
                                                startmonth: startmonth,
                                                endday: endday,
                                                endmonth: endmonth,
                                                dataList: dataList,
                                              )));
                                  print(dataList['Rooms']['Title']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF06B3C4),
                                  ),
                                  child: const Center(
                                      child: Text('Select',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
