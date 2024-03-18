// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class Reviews extends StatefulWidget {
//   const Reviews({Key? key}) : super(key: key);

//   @override
//   State<Reviews> createState() => _ReviewsState();
// }

// class _ReviewsState extends State<Reviews> {
//   double averageRating = 4.5; // Note moyenne initiale

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Center(
//           child: Text(
//             'Reviews',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             // Ajoutez l'action lorsque l'utilisateur clique sur le bouton de retour ici
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.menu,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               // Ajoutez l'action lorsque l'utilisateur clique sur le bouton de menu ici
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: Divider(
//             color: Color.fromARGB(255, 219, 219, 219),
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 30),

//                     // Ajouter un padding à gauche
//                     child: Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Note moyenne à gauche
//                           Text(
//                             averageRating.toString(),
//                             style: TextStyle(
//                                 fontSize: 40,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 0),
//                           // Barre de notation des étoiles en dessous de la note moyenne
//                           RatingBar.builder(
//                             initialRating: averageRating,
//                             minRating: 1,
//                             direction: Axis.horizontal,
//                             allowHalfRating: true,
//                             itemCount: 5,
//                             itemSize: 25,
//                             itemBuilder: (context, _) => Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                             ),
//                             onRatingUpdate: (rating) {
//                               setState(() {
//                                 averageRating =
//                                     rating; // Mettre à jour la note moyenne
//                               });
//                             },
//                           ),
//                           Text(
//                             'Based on 150 reviews',
//                             style: TextStyle(fontSize: 15, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildReviewTile('John Doe', 'Great experience!', 4.5,
//               'https://example.com/user1.jpg'),
//           _buildReviewTile('Jane Smith', 'Nice place!', 4.0,
//               'https://example.com/user2.jpg'),
//           _buildReviewTile('Alice Johnson', 'Wonderful stay!', 5.0,
//               'https://example.com/user3.jpg'),
//           _buildReviewTile('Bob Williams', 'Lovely accommodation!', 4.7,
//               'https://example.com/user4.jpg'),
//           _buildReviewTile('Emma Brown', 'Excellent service!', 4.8,
//               'https://example.com/user5.jpg'),
//           _buildReviewTile('Michael Wilson', 'Awesome hotel!', 4.2,
//               'https://example.com/user6.jpg'),
//           _buildReviewTile('Sophia Martinez', 'Perfect location!', 4.9,
//               'https://example.com/user7.jpg'),
//           _buildReviewTile('William Taylor', 'Great amenities!', 4.6,
//               'https://example.com/user8.jpg'),

//           // Ajoutez plus de critiques ici si nécessaire
//         ],
//       ),
//     );
//   }

//   Widget _buildReviewTile(
//       String userName, String comment, double rating, String userPhotoUrl) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 255, 255, 255),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage:
//                     NetworkImage(userPhotoUrl), // Photo de l'utilisateur
//               ),
//               SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     userName,
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(comment),
//                 ],
//               ),
//               Spacer(), // Pour espacer le texte de l'étoile
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.orange, size: 18),
//                   SizedBox(width: 4),
//                   Text(
//                     rating.toString(),
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
