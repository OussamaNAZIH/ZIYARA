import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Home.dart';
import 'package:flutter_pfe/Setting/ChangePasswordPage.dart';
import 'package:flutter_pfe/Setting/Langue.dart';
import 'package:flutter_pfe/Setting/Notification.dart';
import 'EditProfile.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Setting',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Home()));
              }),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text('Paramètres du compte'),
                  ),
                  PopupMenuItem(
                    child: Text('Déconnexion'),
                  ),
                ];
              },
            ),
          ],
          bottom: PreferredSize(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'General',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 2),
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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.manage_accounts_sharp,
                        size: 27,
                      ),
                      title: Text(
                        'Edit profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                        // Action à exécuter lors du clic sur "Edit profile"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.password,
                        size: 27,
                      ),
                      title: Text(
                        'Change password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Change()));
                        // Action à exécuter lors du clic sur "Change password"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espace entre les boutons
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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications_active_outlined,
                        size: 27,
                      ),
                      title: Text(
                        'Notification',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => notification()));
                        // Action à exécuter lors du clic sur "Notification"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espace entre les boutons

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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.language,
                        size: 27,
                      ),
                      title: Text(
                        'Language',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
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

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),

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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.help,
                        size: 27,
                      ),
                      title: Text(
                        'Help & Support',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // Action à exécuter lors du clic sur "Help & Support"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espace entre les boutons
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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        size: 27,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // Action à exécuter lors du clic sur "About"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espace entre les boutons
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
                          offset:
                              Offset(3, 3), // change shadow offset if needed
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        size: 27,
                        color: Color.fromRGBO(244, 67, 54, 1),
                      ),
                      title: Text(
                        'Log Out',
                        style: TextStyle(
                            color: const Color.fromRGBO(244, 67, 54, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onTap: () {
                        // Action à exécuter lors du clic sur "Log Out"
                        // Mettez ici le code pour la fonctionnalité à exécuter
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
