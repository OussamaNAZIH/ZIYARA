import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatefulWidget {
  final dynamic dataList;

  ReviewsScreen({super.key, required this.dataList});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int selectedRating = 0;
  double minRating = 0;
  double rating = 5;
  final _messageController = TextEditingController();
  String? messages;

  User? user;
  String? userId;
  String? username;
  bool isLoading = true;

  List Myreviews = [];
  CollectionReference Myreviewsref =
      FirebaseFirestore.instance.collection("reviews");
  CollectionReference hotelsRef =
      FirebaseFirestore.instance.collection("hotels");
  String? _userName = '';

  Future<void> getCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        _userName = userData['username'];
        userId = user!.uid;
        isLoading = false;
      });
    }
  }

 Future<void> updateHotelRating(String hotelId, double newRating) async {
  DocumentReference hotelDoc = hotelsRef.doc(hotelId);
  DocumentSnapshot hotelSnapshot = await hotelDoc.get();

  if (hotelSnapshot.exists) {
    double currentRating = hotelSnapshot['rating'].toDouble(); // Casting to double
    int ratingCount = hotelSnapshot['reviews'];

    double updatedRating =
        ((currentRating * ratingCount) + newRating) / (ratingCount + 1);
    int updatedRatingCount = ratingCount + 1;

    await hotelDoc.update({
      'rating': updatedRating,
      'reviews': updatedRatingCount,
    });
  }
}


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await getCurrentUser();
  }

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
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Message',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                      ),
                    ),
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
                      '⭐${rating.toStringAsFixed(1)}',
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        messages = _messageController.text;
                      });

                      await FirebaseFirestore.instance
                          .collection('reviews')
                          .add({
                        'userid': userId,
                        'hotelId': widget.dataList['hotelId'],
                        'username': _userName,
                        'hoteltitle': widget.dataList['title'],
                        'userprofile': '',
                        'messege': messages,
                        'rating': rating,
                      });

                      await updateHotelRating(
                          widget.dataList['hotelId'], rating);

                      _messageController.text = "";
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFF06B3C4),
                    ),
                    child: const Center(
                      child: Text('Send Review',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'My Reviews',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('reviews')
                      .where('userid', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return Center(child: Text('No reviews found.'));
                    }
                    var reviews = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: reviews.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var review = reviews[index];
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
                                  backgroundImage: _userName != null
                                      ? NetworkImage(
                                          'https://ui-avatars.com/api/?name=${_userName}&font-size=0.36&color=233467&background=random',
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
                                      review['username'] ?? '',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      review['messege'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  '⭐ ${review['rating'].toStringAsFixed(1) ?? ''}'),
                            ],
                          ),
                        );
                      },
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
