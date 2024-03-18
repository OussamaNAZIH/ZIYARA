import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyBookingScreen extends StatelessWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  dynamic dataList;
  MyBookingScreen(
      {super.key,
      required this.dataList,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 4.4),
                  itemCount: 1,
                  itemBuilder: (context, int i) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
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
                                        height: 80,
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Check in ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '${startday.toString()} / ${startmonth.toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            '${endday.toString()} / ${endmonth.toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ))));
  }
}
