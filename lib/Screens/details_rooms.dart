import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/MyBookingScreen.dart';

class detailsRooms extends StatelessWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  dynamic dataList;
  detailsRooms(
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
          title: const Center(
              child: Text(
            'Checkout',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
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
                          child: Image.asset(
                            'images/sofitel.jpg',
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Text(
                              "Eliinate Galian Hotel",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              "Chestnut StreetRome,NY",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Text('£38 / Night'),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('⭐4,4 (516)'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Booking',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Dates ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '15 - 18 Nov 2022',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Guest ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '2 Guests(1 Room)',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.meeting_room_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Room type ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '${dataList['Rooms']['Title']}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Email ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            'Hotels@gmail.com',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                          child: Text(
                        '------------------------------------------',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Price Details',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Price ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '\$139.00',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Admin fee ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '\$2.50',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        children: [
                          Text(
                            'Total fee ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '\$141.50',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyBookingScreen(
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
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF06B3C4),
                  ),
                  child: const Center(
                      child: Text('Select Payment',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold))),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
