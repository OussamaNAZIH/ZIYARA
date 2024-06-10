import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pfe/Screens/Login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();

  User? user;
  String? userId;
  String? username;
  String? email;
  String loginMethod = '';
  bool isLoading = true;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userId = user!.uid;
      email = user!.email;

      // Détecter la méthode de connexion
      if (user!.providerData.isNotEmpty) {
        for (var profile in user!.providerData) {
          if (profile.providerId == 'password') {
            loginMethod = 'Email';
          } else if (profile.providerId == 'google.com') {
            loginMethod = 'Google';
          } else if (profile.providerId == 'facebook.com') {
            loginMethod = 'Facebook';
          }
        }
      }

      // Récupérer le nom d'utilisateur et la photo de profil depuis Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        username = userData['username'];
        _usernameController.text = username!;
        isLoading = false;
      });
    }
  }

  void _updateUserInfo() async {
    try {
      if (user != null) {
        // Mettez à jour l'e-mail de l'utilisateur dans l'authentification Firebase

        String userId = user!.uid;

        // Mise à jour des informations de l'utilisateur dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'username': _usernameController.text.trim(),
        });

        // Demandez à l'utilisateur de se reconnecter
        await _showReauthenticateDialog();
      }
    } catch (e) {
      print('Erreur lors de la mise à jour des informations utilisateur : $e');
    }
  }

  Future<void> _showReauthenticateDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reconnectez-vous'),
        content: const Text(
            'Vous devez vous reconnecter pour appliquer les changements.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const TabScreen()));
            },
            child: const Text('Goo To Home'),
          ),
        ],
      ),
    );
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     File file = File(image.path);
  //     String fileName = '$userId/profile.jpg';

  //     try {
  //       await FirebaseStorage.instance.ref(fileName).putFile(file);
  //       String downloadURL =
  //           await FirebaseStorage.instance.ref(fileName).getDownloadURL();

  //       setState(() {
  //         profileImageUrl = downloadURL;
  //       });

  //       // Update profile image URL in Firestore
  //       await FirebaseFirestore.instance
  //           .collection('profile') // Change 'users' to 'profile' folder
  //           .doc(userId)
  //           .update({'userprofile': profileImageUrl});
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Edit Profil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text('Account Settings'),
                ),
                const PopupMenuItem(
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://ui-avatars.com/api/?name=${username}&font-size=0.36&color=233467&background=random'),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: Container(
                              //     height: 50,
                              //     width: 50,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       border: Border.all(
                              //         width: 5,
                              //         color: Theme.of(context)
                              //             .scaffoldBackgroundColor,
                              //       ),
                              //       color: const Color(0xFF06B3C4),
                              //     ),
                              //     child: ElevatedButton(
                              //       onPressed: ,
                              //       style: ElevatedButton.styleFrom(
                              //         shape: CircleBorder(),
                              //         padding: EdgeInsets.zero,
                              //       ),
                              //       child: const Icon(
                              //         size: 30,
                              //         Icons.edit,
                              //         color: Color.fromARGB(255, 181, 50, 50),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            hintText: 'Enter your new username',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xFF06B3C4),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Account linked with',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 65,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 219, 219, 219),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  loginMethod == 'Email'
                                      ? Icons.email
                                      : loginMethod == 'Google'
                                          ? Icons.g_mobiledata
                                          : Icons.facebook,
                                  color: Color(0xFF06B3C4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  loginMethod,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.link),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 65),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: GestureDetector(
                            onTap: _updateUserInfo,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: const Color(0xFF06B3C4),
                              ),
                              child: const Center(
                                child: Text(
                                  'Change Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
