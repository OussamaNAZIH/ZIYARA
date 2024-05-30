import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HotelReviews extends StatefulWidget {
  final List Hotelreviews;
  HotelReviews({super.key, required this.Hotelreviews});

  @override
  State<HotelReviews> createState() => _HotelReviewsState();
}

class _HotelReviewsState extends State<HotelReviews> {
  double _averageRating = 0;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
  }

  void _calculateAverageRating() {
    double totalRating = 0;
    int reviewCount = 0;

    for (var review in widget.Hotelreviews) {
      if (review['rating'] != null) {
        totalRating += review['rating'];
        reviewCount++;
      }
    }

    setState(() {
      if (reviewCount > 0) {
        _averageRating = (totalRating / reviewCount);
      } else {
        _averageRating = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Reviews',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_averageRating',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 30),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: _averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size:
                                  12, // Ajustez la taille ici pour la rendre plus petite
                            ),
                            onRatingUpdate: (newRating) {
                              // Laissez cette fonction vide pour éviter la mise à jour de _averageRating
                            },
                          ),
                        ),
                        Text(
                          'Based on ${widget.Hotelreviews.length} reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text('hello')
                  ],
                ),
              ),
              Text(
                'Reviews (${widget.Hotelreviews.length})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ListView.builder(
                itemCount: widget.Hotelreviews.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final Hotelreview = widget.Hotelreviews[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
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
    );
  }
}
