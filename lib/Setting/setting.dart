import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Moduls/SplashScreen.dart';
import 'package:flutter_pfe/Screens/Home.dart';
import 'package:flutter_pfe/Setting/ChangePasswordPage.dart';
import 'package:flutter_pfe/Setting/Langue.dart';
import 'package:flutter_pfe/Setting/Notification.dart';
import 'EditProfile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen or another appropriate screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SplashScreen())); // Example navigation
  } catch (e) {
    print("Error signing out: $e");
    // Handle sign-out errors here
  }
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Setting',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(
                1.0), // Taille préférée de la barre de délimitation
            child: Divider(
              color: Color.fromARGB(255, 219, 219, 219),
              height: 1.0,
            ),
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'General',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 20, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement edit profile functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.manage_accounts_sharp,
                        size: 27,
                      ),
                      title: const Text(
                        'Edit profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()));
                        // Action à exécuter lors du clic sur "Edit profile"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), // Espace entre le bouton et les autres éléments de la liste
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement change password functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.password,
                        size: 27,
                      ),
                      title: const Text(
                        'Change password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Change()));
                        // Action à exécuter lors du clic sur "Change password"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les boutons
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement notification functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        size: 27,
                      ),
                      title: const Text(
                        'Notification',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const notification()));
                        // Action à exécuter lors du clic sur "Notification"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les boutons

              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement language functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.language,
                        size: 27,
                      ),
                      title: const Text(
                        'Language',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LanguageSelectionPage()));
                        // Action à exécuter lors du clic sur "Language"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement help & support functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.help,
                        size: 27,
                      ),
                      title: const Text(
                        'Help & Support',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // Action à exécuter lors du clic sur "Help & Support"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les boutons
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement about functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.info,
                        size: 27,
                      ),
                      title: const Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // Action à exécuter lors du clic sur "About"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les boutons
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 0), // Espace à gauche et à droite
                child: GestureDetector(
                  onTap: () {
                    // Implement log out functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(
                              3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.exit_to_app,
                        size: 27,
                        color: Color.fromRGBO(244, 67, 54, 1),
                      ),
                      title: InkWell(
                        onTap: () {
                          signOut(context);
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                              color: Color.fromRGBO(244, 67, 54, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      onTap: () {
                        // Action à exécuter lors du clic sur "Log Out"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
