import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatefulWidget {
  dynamic dataList;

  ReviewsScreen({
    super.key,
    required this.dataList,
  });

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int selectedRating = 0;
  double minRating = 0;
  double rating = 5;
  final _messageController = TextEditingController();
  String? messages;

  String? getiduser() {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user!.uid;
    return '$userId';
  }

  bool isLoading = true;

  List Myreviews = [];

  CollectionReference Myreviewsref =
      FirebaseFirestore.instance.collection("reviews");

  getData() async {
    var responsebody =
        await Myreviewsref.where('userid', isEqualTo: getiduser()).get();
    for (var element in responsebody.docs) {
      setState(() {
        Myreviews.add(element.data());
        isLoading = false;
      });
    }
  }

  final _formke = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Appeler getData() lorsque le widget est créé
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF06B3C4),
          )) // Afficher un indicateur de chargement
        : Scaffold(
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formke,
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
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[50],
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your message';
                            }
                            return null;
                          },
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
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '⭐$rating',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formke.currentState!.validate()) {
                            setState(() {
                              messages = _messageController.text;
                            });
                            print(selectedRating);
                            print(rating);
                            print(messages);
                            print('${widget.dataList['hotelId']}');
                            CollectionReference collRef = FirebaseFirestore
                                .instance
                                .collection('reviews');
                            collRef.add({
                              'userid': getiduser(),
                              'hotelId': widget.dataList['hotelId'],
                              'username': '',
                              'hoteltitle': widget.dataList['title'],
                              'userprofile': '',
                              'messege': messages,
                              'rating': rating,
                            }).then((value) {
                              value.get().then((snapshot) {
                                setState(() {
                                  Myreviews.add(snapshot.data());
                                  isLoading = false;
                                });
                              });
                            });
                          }
                          _messageController.text = "";
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
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
            ListView.builder(
              itemCount: Myreviews.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Hotelreview = Myreviews[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: Hotelreview['username'] != null
                              ? NetworkImage(
                                  'https://ui-avatars.com/api/?name=${Hotelreview['username']}&font-size=0.36&color=233467&background=random',
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Hotelreview['username'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Hotelreview['messege'] ?? '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Text('⭐ ${Hotelreview['rating'] ?? ''}'),
                    ],
                  ),
                );
              },
            ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
