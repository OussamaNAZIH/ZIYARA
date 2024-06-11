import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/reviews_screen.dart';

class MyBookingScreen extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? startyear;
  int? endyear;
  dynamic dataList;
  MyBookingScreen({
    super.key,
    required this.endyear,
    required this.startyear,
    required this.dataList,
    required this.startday,
    required this.startmonth,
    required this.endday,
    required this.endmonth,
  });

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  bool isLoading = true;
  List Mybooking = [];

  CollectionReference Mybookingref =
      FirebaseFirestore.instance.collection("reservation");

  Future<String?> getiduser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  getData() async {
    String? userId = await getiduser();
    if (userId != null) {
      var responsebody =
          await Mybookingref.where('userid', isEqualTo: userId).get();
      setState(() {
        Mybooking = responsebody.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF06B3C4),
          ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Center(
                  child: Text('My booking', style: TextStyle(fontSize: 22))),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Divider(
                  color: Color.fromARGB(255, 219, 219, 219),
                  height: 1.0,
                ),
              ),
            ),
            body: Container(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 10,
                              childAspectRatio: 9 / 5.8),
                      itemCount: Mybooking.length,
                      itemBuilder: (context, int i) {
                        var data = Mybooking[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewsScreen(
                                  dataList: data,
                                ),
                              ),
                            );
                            print(data);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.2),
                                              BlendMode.srcATop,
                                            ),
                                            child: Image.network(
                                              Mybooking[i]['photo'],
                                              height: 90,
                                              width: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data['title']}',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '${data['adresse']}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      '\MAD ${data['price']} / Night'),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                      '⭐${data['rating'].toStringAsFixed(1)} (${data['reviews']})'),
                                                ],
                                              ),
                                              Text(
                                                ('${data['rooms']}room . ') +
                                                    ('${data['Adults']} adults .  ${data['Children']}children'),
                                                style: TextStyle(
                                                  color: Color(0xFF06B3C4),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ID Reservation : ${data['id']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Email Hotel : ${data['email']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  'Check in ',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '${data['startday']}/${data['startmonth']}/${data['startyear']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.arrow_right_alt),
                                            const Spacer(),
                                            Column(
                                              children: [
                                                const Text(
                                                  'Check Out ',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '${data['endday']}/${data['endmonth']}/${data['endyear']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    ))));
  }
}
