// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_pfe/Moduls/SplashScreen.dart';
// import 'package:flutter_pfe/Setting/setting.dart';
// import 'package:flutter_pfe/controllers/home_controlle.dart';
// import 'package:flutter_pfe/views/details_Screen.dart';
// import 'package:flutter_pfe/views/home.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int Adults = 1;
//   int Children = 0;
  
//   List hotels = [];
//   CollectionReference Hotelref =
//       FirebaseFirestore.instance.collection("hotels");
//   getData() async {
//     var responsebody = await Hotelref.orderBy('rating', descending: true).get();
//     for (var element in responsebody.docs) {
//       setState(() {
//         hotels.add(element.data());
//       });
//     }
//   }

//   String? _userName = '';
//   void _getCurrentUser() async {
//     // Récupération de l'utilisateur actuel authentifié avec Firebase
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // Récupération des données utilisateur à partir de Firestore
//       DocumentSnapshot userData = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       // Mise à jour de l'interface utilisateur avec les informations utilisateur récupérées
//       setState(() {
//         _userName = userData['username'];
//       });
//     }
//   }

//   List<String> _titles = [];

//   int? startday;
//   int? startmonth;
//   int? endday;
//   int? endmonth;

//   final List<String> _hotelTitles = [];
//   FirebaseAuth instance = FirebaseAuth.instance;
//   bool _DestinationController = true;
//   bool _mailTextFieldEmpty = true;
//   final bool _travelersControllerEmpty = true;
//   // final controller = HomeController();
// ///////////////////

//   bool dateTextFieldEmpty = true;
//   bool guestTextFieldEmpty = true;
//   bool roomTypeTextFieldEmpty =
//       true; // Variable pour suivre si le champ "Room Type" est vide
//   bool phoneNumberTextFieldEmpty =
//       true; // Variable pour suivre si le champ "Number Phone" est vide
//   bool isDateSelected = false;
//   bool _isGuestEnteredControllerEmpty =
//       true; // Variable pour suivre si les détails des invités ont été entrés

//   DateTimeRange selectedDates =
//       DateTimeRange(start: DateTime.now(), end: DateTime.now());

// ////////////////////////////////////////

//   final durationController = TextEditingController();
//   final isGuestEnteredController = TextEditingController();
//   final AdultsController = TextEditingController();
//   final childrenController = TextEditingController();
//   final RoomsController = TextEditingController();
//   late TextEditingController DestinationController;

//   final _formkey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _fetchTitles();

//     DestinationController = TextEditingController();

//     getData();
//     DestinationController.addListener(() {
//       setState(() {
//         _DestinationController = DestinationController.text.isEmpty;
//       });
//     });
//     durationController.addListener(() {
//       setState(() {
//         _mailTextFieldEmpty = durationController.text.isEmpty;
//       });
//     });
//     isGuestEnteredController.addListener(() {
//       setState(() {
//         _isGuestEnteredControllerEmpty = isGuestEnteredController.text.isEmpty;
//       });
//     });
//     instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const SplashScreen()));
//       }
//     });
//   }

//   Future<void> _fetchTitles() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('hotels').get();

//       List<String> titles = querySnapshot.docs.map((doc) {
//         final data = doc.data() as Map<String,
//             dynamic>?; // Cast explicite vers Map<String, dynamic> ou utilisez le type de données correct
//         if (data != null && data['title'] != null) {
//           return data['title'] as String;
//         } else {
//           return ''; // ou toute autre valeur par défaut
//         }
//       }).toList();

//       setState(() {
//         _titles = titles;
//       });
//     } catch (e) {
//       print('Error fetching titles: $e');
//       // Gérer les erreurs en conséquence
//     }
//   }

//   DateTime? _dateDebut;
//   DateTime? _dateFin;
//   int _nombreAdultes = 1;
//   int _nombreEnfants = 0;
//   int _nombreChambres = 1;

//   void _incrementValue(bool isAdult) {
//     setState(() {
//       if (isAdult) {
//         _nombreAdultes++;
//       } else {
//         _nombreEnfants++;
//       }
//     });
//   }

//   void _decrementValue(bool isAdult) {
//     setState(() {
//       if (isAdult) {
//         if (_nombreAdultes > 1) {
//           _nombreAdultes--;
//         }
//       } else {
//         if (_nombreEnfants > 0) {
//           _nombreEnfants--;
//         }
//       }
//     });
//   }

//   void _showBottomSheet(BuildContext context, bool isAdult) {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     isAdult ? 'Adultes' : 'Enfants',
//                     style: TextStyle(fontSize: 24.0),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.remove),
//                         onPressed: () => _decrementValue(isAdult),
//                       ),
//                       Text(
//                         isAdult ? '$_nombreAdultes' : '$_nombreEnfants',
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () => _incrementValue(isAdult),
//                       ),
//                     ],
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Mettre à jour les valeurs dans les champs de texte
//                       if (isAdult) {
//                         setState(() {
//                           _nombreAdultes = _nombreAdultes;
//                         });
//                       } else {
//                         setState(() {
//                           _nombreEnfants = _nombreEnfants;
//                         });
//                       }
//                     },
//                     child: Text('Sauvegarder'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(3000),
//     );

//     if (picked != null) {
//       if (isStartDate) {
//         setState(() {
//           _dateDebut = picked.start;
//         });
//       } else {
//         setState(() {
//           _dateFin = picked.end;
//         });
//       }
//     }
//   }
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     int newAdults = Adults;
// int newChildren = Children;
//     int rooms = ((Adults + Children) / 2).ceil();
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                       ),
//                       child: const CircleAvatar(
//                         backgroundImage: AssetImage('images/profile.png'),
//                       ),
//                     ),
//                     const Spacer(),
//                     Column(
//                       children: [
//                         Text(
//                           "Hi, $_userName",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_rounded,
//                               color: Colors.grey,
//                             ),
//                             Text('Chestnut StreetRome,NY'),
//                           ],
//                         )
//                       ],
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.settings,
//                         size: 30,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => AccountScreen()));
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Text(
//                   "let's find the best hotels around the world ",
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: const Color(0xFF06B3C4), width: 3.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15, top: 10, right: 15),
//                             child: Autocomplete<String>(
//                               optionsBuilder:
//                                   (TextEditingValue textEditingValue) {
//                                 if (textEditingValue.text == '') {
//                                   return const Iterable<String>.empty();
//                                 }
//                                 return _titles.where((String item) =>
//                                     item.contains(
//                                         textEditingValue.text.toLowerCase()));
//                               },
//                               onSelected: (String item) {
//                                 print('the $item');
//                                 DestinationController.text = item;
//                               },
//                               fieldViewBuilder: (BuildContext context,
//                                   TextEditingController controller,
//                                   FocusNode focusNode,
//                                   VoidCallback onFieldSubmitted) {
//                                 return TextField(
//                                   controller: controller,
//                                   focusNode: focusNode,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: 'Enter destination',
//                                     hintStyle: TextStyle(
//                                         color: Colors.grey[500], fontSize: 16),
//                                     // Ajout de la bordure

//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       color: _DestinationController
//                                           ? Colors.grey
//                                           : const Color(0xFF06B3C4),
//                                       size: 35,
//                                     ),
//                                   ),
//                                   onChanged: (String value) {
//                                     // You can add additional logic here if necessary
//                                   },
//                                   onSubmitted: (String value) {
//                                     onFieldSubmitted();
//                                   },
//                                 );
//                               },
//                               optionsViewBuilder: (BuildContext context,
//                                   AutocompleteOnSelected<String> onSelected,
//                                   Iterable<String> options) {
//                                 return Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Material(
//                                     elevation: 4.0,
//                                     child: Container(
//                                       constraints:
//                                           const BoxConstraints(maxHeight: 200),
//                                       width: MediaQuery.of(context).size.width,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(8.0),
//                                       ),
//                                       child: ListView(
//                                         padding: EdgeInsets.zero,
//                                         shrinkWrap: true,
//                                         children: options.map((String option) {
//                                           return ListTile(
//                                             title: Text(option),
//                                             onTap: () {
//                                               onSelected(option);
//                                             },
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           Form(
//                             key: _formKey,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: <Widget>[InkWell(
//                                             onTap: () => _selectDate(context, true),
//                                             child: InputDecorator(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Date de Début du Voyage',
//                                               ),
//                                               child: Text(
//                                                 _dateDebut != null
//                                                     ? "${_dateDebut!.day}/${_dateDebut!.month}/${_dateDebut!.year}"
//                                                     : 'Sélectionnez la date',
//                                               ),
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () => _selectDate(context, false),
//                                             child: InputDecorator(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Date de Fin du Voyage',
//                                               ),
//                                               child: Text(
//                                                 _dateFin != null
//                                                     ? "${_dateFin!.day}/${_dateFin!.month}/${_dateFin!.year}"
//                                                     : 'Sélectionnez la date',
//                                               ),
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () => _showBottomSheet(context, true),
//                                             child: InputDecorator(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Nombre d\'Adultes',
//                                               ),
//                                               child: Text(
//                                                 '$_nombreAdultes',
//                                                 style: TextStyle(fontSize: 16.0),
//                                               ),
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () => _showBottomSheet(context, false),
//                                             child: InputDecorator(
//                                               decoration: InputDecoration(
//                                                 labelText: 'Nombre d\'Enfants',
//                                               ),
//                                               child: Text(
//                                                 '$_nombreEnfants',
//                                                 style: TextStyle(fontSize: 16.0),
//                                               ),
//                                             ),
//                                           ),
//                                           TextFormField(
//                                             decoration: InputDecoration(
//                                               labelText: 'Nombre de Chambres',
//                                             ),
//                                             keyboardType: TextInputType.number,
//                                             validator: (val) =>
//                                                 int.tryParse(val!) == null ? 'Entrez un nombre valide' : null,
//                                             onSaved: (val) => _nombreChambres = int.parse(val!),
//                                           ),
//                                           SizedBox(height: 16.0),
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               if (_formKey.currentState!.validate()) {
//                                                 _formKey.currentState!.save();
//                                                 // Utilisez les valeurs comme vous le souhaitez
//                                                 print('Date de Début du Voyage: $_dateDebut');
//                                                 print('Date de Fin du Voyage: $_dateFin');
//                                                 print('Nombre d\'Adultes: $_nombreAdultes');
//                                                 print('Nombre d\'Enfants: $_nombreEnfants');
//                                                 print('Nombre de Chambres: $_nombreChambres');
//                                               }
//                                             } ,child: Text('Soumettre'),
//                                           ),
//                                 InkWell(
//                                   onTap: () {
//                                     startday = selectedDates.start.day;
//                                     startmonth = selectedDates.start.month;
//                                     endday = selectedDates.end.day;
//                                     endmonth = selectedDates.end.month;
                            
//                                     controller:
//                                     '${selectedDates.start.day}/${selectedDates.start.month}/${selectedDates.start.year} - ${selectedDates.end.day}/${selectedDates.end.month}/${selectedDates.end.year}';
                            
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) => SearchScreen(
//                                                 startday: startday,
//                                                 startmonth: startmonth,
//                                                 endday: endday,
//                                                 endmonth: endmonth,
//                                                 Controller:
//                                                     DestinationController
//                                                         .text)));
                            
//                                     print(startday);
//                                     print(startmonth);
//                                     print(endday);
//                                     print(endmonth);
//                                     print(RoomsController);
//                                     print(((Adults + Children) / 2 +
//                                             (Adults + Children) % 2)
//                                         .toInt());
//                                     print(Adults);
//                                     print(Children);
//                                     print(rooms);
//                                     print((1 / 2).ceil());
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFF06B3C4),
//                                     ),
//                                     child: const Center(
//                                         child: Text('Rechercher',
//                                             style: TextStyle(
//                                                 color: Color.fromARGB(
//                                                     255, 255, 255, 255),
//                                                 fontWeight: FontWeight.bold))),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ])),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Row(
//                   children: [
//                     Text(
//                       'Recomended Hotel 🔥',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Spacer(),
//                     Text(
//                       'See All ',
//                       style: TextStyle(
//                           color: Color(0xFF06B3C4),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   height: 400,
//                   color: const Color.fromARGB(255, 255, 255, 255),
//                   child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: hotels.length,
//                       itemBuilder: ((context, int i) {
//                         return InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => DetailsScreen(
//                                     startday: 0,
//                                     startmonth: 0,
//                                     endday: 0,
//                                     endmonth: 0,
//                                     dataList: hotels[i])));
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 255, 255, 255),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             margin: const EdgeInsets.all(10),
//                             width: 280,
//                             child: Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: ColorFiltered(
//                                     colorFilter: ColorFilter.mode(
//                                       Colors.black.withOpacity(0.2),
//                                       BlendMode.srcATop,
//                                     ),
//                                     child: Center(
//                                       child: Image.network(
//                                         '${hotels[i]['photo1']}',
//                                         // fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 color: const Color.fromRGBO(
//                                                     255, 255, 255, 40),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10)),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(6.0),
//                                               child: Row(
//                                                 children: [
//                                                   // Text(
//                                                   //   "\$${hotels[i]['price'] - (hotels[i]['price'] * (hotels[i]['discount']) / 100)}",
//                                                   //   style: const TextStyle(
//                                                   //       fontWeight:
//                                                   //           FontWeight.bold,
//                                                   //       color: Color.fromARGB(
//                                                   //           255, 0, 0, 0)),
//                                                   // ),
//                                                   Text(
//                                                     '\$${hotels[i]['price']}/Day',
//                                                     style: const TextStyle(
//                                                         color: Color.fromARGB(
//                                                             255, 0, 0, 0)),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           const Spacer(),
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.favorite_border_outlined,
//                                               size: 30,
//                                               color: Color.fromARGB(
//                                                   255, 255, 255, 255),
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     // const SizedBox(
//                                     //   height: 40,
//                                     // ),
//                                     const Spacer(),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: const Color.fromRGBO(
//                                               255, 255, 255, 40),
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(10.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     '⭐${hotels[i]['rating']} ',
//                                                     style: const TextStyle(
//                                                         color: Color.fromARGB(
//                                                             255, 255, 166, 12)),
//                                                   ),
//                                                   Text(
//                                                     '(${hotels[i]['reviews']})',
//                                                     style: const TextStyle(
//                                                         color: Colors.grey),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Text(
//                                                 "${hotels[i]['title']}",
//                                                 style: const TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 0, 0, 0),
//                                                     fontSize: 20,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.location_on,
//                                                     color: Colors.grey,
//                                                   ),
//                                                   Text(
//                                                     "${hotels[i]['adresse']}",
//                                                     style: const TextStyle(
//                                                         color: Colors.grey),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.bed_outlined,
//                                                     color: Color(0xFF06B3C4),
//                                                   ),
//                                                   Text(' 2 Bads'),
//                                                   Spacer(),
//                                                   Text('.'),
//                                                   Spacer(),
//                                                   Icon(
//                                                     Icons.bed_outlined,
//                                                     color: Color(0xFF06B3C4),
//                                                   ),
//                                                   Text(' Wifi'),
//                                                   Spacer(),
//                                                   Text('.'),
//                                                   Spacer(),
//                                                   Icon(
//                                                     Icons.bed_outlined,
//                                                     color: Color(0xFF06B3C4),
//                                                   ),
//                                                   Text(' Gym'),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),

//                                     const SizedBox(height: 20)
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       })),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Row(
//                   children: [
//                     Text(
//                       'Nearby Hotels',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Spacer(),
//                     Text(
//                       'See All ',
//                       style: TextStyle(
//                           color: Color(0xFF06B3C4),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: ColorFiltered(
//                               colorFilter: ColorFilter.mode(
//                                 Colors.black.withOpacity(0.2),
//                                 BlendMode.srcATop,
//                               ),
//                               child: Image.asset(
//                                 'images/profile.png',
//                                 width: 100,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.all(2.0),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "title",
//                                   style: TextStyle(
//                                       color: Color.fromARGB(255, 0, 0, 0),
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                                 Text(
//                                   "adresse",
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('\$ price / Night'),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Text('⭐rating '),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }





