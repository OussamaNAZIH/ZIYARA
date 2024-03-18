// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_pfe/blocs/bloc/get_hotel_bloc.dart';
// import 'package:flutter_pfe/views/details_Screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     super.key,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
 

//   @override
//   void initState() {
    
//     super.initState();
//   }

//   final DestinationController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//           title: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: const Color.fromARGB(255, 255, 255, 255),
//             ),
//             child: TextFormField(
//               controller: DestinationController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return ' Please Enter your email';
//                 }
//                 return null;
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Color.fromARGB(255, 0, 0, 0),
//                   size: 30,
//                 ),
//                 hintText: 'Enter your email',
//                 hintStyle: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//               onTap: () {},
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new),
//             color: Colors.red,
//             onPressed: () {
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) =>
//               //             const HomeScreen())); // Action lorsqu'on clique sur le bouton de menu
//             },
//           ),
//         ),
//         body: Container(
//           child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 9 / 13),
//                 itemCount: data.length,
//                 itemBuilder: (context, int i) {
//                   // Material(
//                   //     elevation: 3,
//                   //     color: Colors.white,
//                   //     shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(20)),
//                   //     child:
//                   return InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 const DetailsScreen()),
//                       );
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Stack(children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.network(
//                               '${data[i]['Photos']['Photo1']}',
//                               height: 125,
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.favorite_border_outlined,
//                                 size: 25,
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),
//                         ]),
//                         // const SizedBox(
//                         //   height: 15,
//                         // ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 child: Text(
//                                     "⭐${data[i]['Ritting']} (${data[i]['reviews']})"),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: Text(
//                             "${data[i]['Title']}",
//                             style: const TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w900),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: Text(
//                             "${data[i]['Adresse']}",
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "\$${data[i]['price'] - (data[i]['price'] * (data[i]['discount']) / 100)}",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 20,
//                                   color: Color.fromARGB(255, 0, 0, 0),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 "\$${data[i]['price']}",
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 12,
//                                     color: Color.fromARGB(255, 255, 0, 0),
//                                     decoration: TextDecoration.lineThrough),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )),
//         ));
//   }
// }
