import 'package:flutter/material.dart';
import 'package:flutter_pfe/Setting/setting.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Langue',
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
      backgroundColor: Colors.white, // Couleur de fond du body en blanc
      body: Column(
        children: [
          SizedBox(height: 30),
          LanguageContainer(
            language: 'Français',
            icon: Icons.language,
            isSelected: selectedLanguage == 'Français',
            onTap: () {
              setState(() {
                selectedLanguage = 'Français';
              });
            },
          ),
          LanguageContainer(
            language: 'English',
            icon: Icons.language,
            isSelected: selectedLanguage == 'English',
            onTap: () {
              setState(() {
                selectedLanguage = 'English';
              });
            },
          ),
        ],
      ),
    );
  }
}

class LanguageContainer extends StatelessWidget {
  final String language;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageContainer({
    Key? key,
    required this.language,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 2,
              color: isSelected
                  ? Color(0xFF06B3C4)
                  : Color.fromARGB(255, 219, 219, 219)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Text(
              language,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            isSelected
                ? Icon(Icons.check, color: Color(0xFF06B3C4))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
