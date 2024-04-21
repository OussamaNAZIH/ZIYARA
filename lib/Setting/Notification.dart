import 'package:flutter/material.dart';
import 'package:flutter_pfe/Setting/setting.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  State<notification> createState() => _notificationState();
}

// ignore: camel_case_types
class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Notification',
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
