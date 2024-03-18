import 'package:flutter/material.dart';
import 'package:flutter_pfe/Setting/setting.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Définition des contrôleurs pour les champs de texte
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  // Liste des comptes associés
  List<String> _associatedAccounts = ['Compte 1'];
  String _selectedAccount = 'Compte 1'; // Compte sélectionné par défaut
  String username = "Ilyass jouamaa";
  String email = "elias.jouamaa@gmail.com";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Edit Profil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Account Settings'),
                ),
                PopupMenuItem(
                  child: Text('Logout'),
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: CircleAvatar(
                              // Mettez ici l'image de la photo de profil
                              backgroundImage:
                                  AssetImage('assets/default_profile_pic.png'),
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
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Color(0xFF06B3C4),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),

                  SizedBox(height: 20),

                  Row(
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

                  SizedBox(height: 10),
                  // Champ d'édition pour le nom d'utilisateur

                  TextFormField(
                    controller: TextEditingController(text: username),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                        // borderSide: const BorderSide(
                        //   width: 2,
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        // ),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xFF06B3C4),
                      ), // Ajout de l'icône
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),

                  // TextFormField(
                  //   cursorHeight: ,
                  //   controller: TextEditingController(text: username),
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(0))),
                  // ),
                  SizedBox(height: 20),

                  Row(
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

                  SizedBox(height: 10),
                  // Champ d'édition pour l'email
                  TextFormField(
                    controller: TextEditingController(text: email),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(
                              255, 219, 219, 219), // Couleur du bord
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF06B3C4),
                      ), // Ajout de l'icône
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
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

                  SizedBox(height: 10),

                  // Liste déroulante pour les comptes associés
                  Column(
                    children: [
                      Container(
                        height: 65,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 219, 219, 219),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.facebook,
                                color: Color(0xFF06B3C4),
                              ), // Icône Facebook (ou Google)
                            ),
                            SizedBox(width: 8), // Espace contrôlé par SizedBox
                            Expanded(
                              child:
                                  SizedBox(), // Espace pour occuper tout l'espace disponible
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Icon(Icons.link), // Icône de liaison à droite
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 65),
                      Padding(
                        // contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Modifier la hauteur ici
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: GestureDetector(
                          onTap: () {},
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
    );
  }
}
