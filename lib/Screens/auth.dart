import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Login.dart';
import 'package:flutter_pfe/Screens/MapsScreen.dart';
import 'package:flutter_pfe/Screens/StreetView.dart';


// class auth extends StatefulWidget {
//   const auth({super.key});

//   @override
//   State<auth> createState() => _authState();
// }

// class _authState extends State<auth> {
//   FirebaseAuth instance = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => const Login()));
//       } else {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const StreetViewScreen()));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }
