import 'package:flutter/material.dart';

class Forme extends StatefulWidget {
  const Forme({super.key});

  @override
  State<Forme> createState() => _FormeState();
}

class _FormeState extends State<Forme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Forme Detail',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.pop(context);
            }
        ),
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
    );
  }
}
