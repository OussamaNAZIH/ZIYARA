import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/MyBookingScreen.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';

class detailsRooms extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? chamdbValue;
  int? suitesValue;
  int? chamspValue;
  dynamic dataList;
  String? Total;
  String? userid;
  int? Adults;
  int? Children;
  int? rooms;
  int? startyear;
  int? endyear;
  String? email;

  detailsRooms(
      {super.key,
      required this.endyear,
      required this.email,
      required this.startyear,
      required this.Adults,
      required this.Children,
      required this.rooms,
      required this.chamdbValue,
      required this.suitesValue,
      required this.chamspValue,
      required this.dataList,
      required this.Total,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.userid,
      required this.endmonth});

  @override
  State<detailsRooms> createState() => _detailsRoomsState();
}

class _detailsRoomsState extends State<detailsRooms> {
  int Fee = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Your Ticket',
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
                          // child: Image.asset(
                          //   dataList['photos']['photo3'],
                          //   width: 100,
                          //   height: 50,
                          // ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(2.0),
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
                                    widget.dataList['photos'][
                                        'photo1'], // Utilisez directement l'URL de l'image depuis votre modèle
                                    width: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF06B3C4),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dataList['title'],
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    widget.dataList['adresse'],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '\MAD ${widget.dataList['price']} / Night'),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                          '⭐${widget.dataList['rating'].toStringAsFixed(1)} (${widget.dataList['reviews']})'),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ))
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
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Dates ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.startday} / ${widget.startmonth} / ${widget.startyear}  - ${widget.endday} / ${widget.endmonth} ${widget.endyear}',
                            style: const TextStyle(
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
                            '${widget.Adults != 0 ? ' ${widget.Adults} Guest ' : ''} ${widget.Children != 0 ? '- ${widget.Children} Children ' : ''} (${widget.rooms} Room)',
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
                            '${widget.chamspValue != 0 ? 'Simple Room' : ''} ${widget.chamdbValue != 0 ? ' - Double Room' : ''}  ${widget.suitesValue != 0 ? ' - Sweet' : ''}',
                            style: const TextStyle(
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
                           '${widget.email}',
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
                      Row(
                        children: [
                          const Text(
                            'Price ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '\$ ${widget.Total}',
                            style: const TextStyle(
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
                          const Text(
                            'Admin fee ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '\$ $Fee',
                            style: const TextStyle(
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
                          const Text(
                            'Total fee ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '\$${int.parse(widget.Total!) + Fee}',
                            style: const TextStyle(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TabScreen()));

                  // Imprimer les données de chaque élément de dataList
                  // for (var snapshot in dataList) {
                  //   print(snapshot
                  //       .data()); // Assurez-vous que `.data()` récupère les données correctement
                  // }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF06B3C4),
                  ),
                  child: const Center(
                      child: Text('Go To Home',
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
