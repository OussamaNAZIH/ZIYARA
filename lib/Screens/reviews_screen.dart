import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  dynamic dataList;

  ReviewsScreen({
    super.key,
    required this.dataList,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

int selectedRating = 0;
double minRating = 0;
double Rating = 5;
final _messageController = TextEditingController();
String? messages;
getiduser() {
  User? user = FirebaseAuth.instance.currentUser;
  String? userId = user!.uid;
  return '$userId';
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Reviews & Rating',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              1.0), // Taille préférée de la barre de délimitation
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Messege',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[50],
                ),
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey[400],
                      ),
                      hintText: 'Enter your Review',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      )),
                  onTap: () {},
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rating',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '⭐$Rating',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              RangeSlider(
                values: RangeValues(minRating.toDouble(), Rating.toDouble()),
                min: 0,
                max: 5,
                divisions: 10,
                // labels: RangeLabels('\$$minPrice', '\$$maxPrice'),
                onChanged: (RangeValues values) {
                  setState(() {
                    Rating = values.end.toDouble();
                  });
                },
                activeColor: Colors.yellow,
                inactiveColor: Colors.grey,
                onChangeStart: (RangeValues values) {
                  // Ne rien faire lors du début du changement de la valeur
                },
                onChangeEnd: (RangeValues values) {
                  // Ne rien faire à la fin du changement de la valeur
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    messages = _messageController.text;
                  });
                  print(selectedRating);
                  print(Rating);
                  print(messages);
                  print('${widget.dataList['hotelId']}');
                  CollectionReference collRef =
                      FirebaseFirestore.instance.collection('reviews');
                  collRef.add({
                    'userid': getiduser(),
                    'hotelId': widget.dataList['hotelId'],
                    'username': '',
                    'userprofile': '',
                    'messege': messages,
                    'rating': Rating,
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFF06B3C4),
                  ),
                  child: const Center(
                      child: Text('Send Review ',
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'My Reviews',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
