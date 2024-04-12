import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Login.dart';
import 'package:flutter_pfe/Setting/setting.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Définition des contrôleurs pour les champs de texte
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _updateUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Mettez à jour l'e-mail de l'utilisateur dans l'authentification Firebase
        await user.updateEmail(_emailController.text.trim());

        String userId = user.uid;

        // Mise à jour des informations de l'utilisateur dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'username': _usernameController.text.trim(),
          'usergmail': _emailController.text.trim(),
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
              // Déconnectez l'utilisateur
              await FirebaseAuth.instance.signOut();
              // Naviguez vers l'écran de connexion
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

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
          preferredSize: Size.fromHeight(
              1.0), // Taille préférée de la barre de délimitation
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          // Mettez ici votre logique pour changer la photo de profil
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                // border: Border.all(color: Colors.grey, width: 2),
                              ),
                              child: const CircleAvatar(
                                // Mettez ici l'image de la photo de profil
                                backgroundImage:
                                    AssetImage('images/profile.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 5,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: const Color(0xFF06B3C4),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // _updateProfilePicture();
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 181, 50, 50),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),

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
                        // Autres widgets que vous pouvez ajouter à droite du texte
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Champ d'édition pour le nom d'utilisateur

                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),

                          // borderSide: const BorderSide(
                          //   width: 2,
                          //   color: Color.fromARGB(255, 255, 255, 255),
                          // ),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Enter your new username',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF06B3C4),
                        ), // Ajout de l'icône
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),

                    // TextFormField(
                    //   cursorHeight: ,
                    //   controller: TextEditingController(text: username),
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(0))),
                    // ),
                    const SizedBox(height: 20),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Autres widgets que vous pouvez ajouter à droite du texte
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Champ d'édition pour l'email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(
                                255, 219, 219, 219), // Couleur du bord
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter your new email',

                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF06B3C4),
                        ), // Ajout de l'icône
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
                        // Autres widgets que vous pouvez ajouter à droite du texte
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Liste déroulante pour les comptes associés
                    Column(
                      children: [
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
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.facebook,
                                  color: Color(0xFF06B3C4),
                                ), // Icône Facebook (ou Google)
                              ),
                              SizedBox(
                                  width: 8), // Espace contrôlé par SizedBox
                              Expanded(
                                child:
                                    SizedBox(), // Espace pour occuper tout l'espace disponible
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                    Icons.link), // Icône de liaison à droite
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 65),
                        Padding(
                          // contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Modifier la hauteur ici
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: GestureDetector(
                            onTap: () {
                              _updateUserInfo();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: const Color(0xFF06B3C4),
                              ),
                              child: const Center(
                                  child: Text('Change Now',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
