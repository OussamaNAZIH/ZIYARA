import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreetViewScreen extends StatelessWidget {
  dynamic Maps;
  StreetViewScreen({super.key, required this.Maps});

  @override
  Widget build(BuildContext context) {
    final streetViewUrl =
        "https://www.google.com/maps/@${Maps['latitude']},${Maps['longitude']},3a,75y,244.65h,94.16t/data=!3m4!1e1";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Street View'),
      ),
      // body: WebView(
      //   initialUrl: streetViewUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreetViewScreen(
        Maps: "",
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class StreetViewScreen extends StatefulWidget {
//   final String address;

//   StreetViewScreen(this.address);

//   @override
//   _StreetViewScreenState createState() => _StreetViewScreenState();
// }

// class _StreetViewScreenState extends State<StreetViewScreen> {
//   String streetViewUrl = "";

//   @override
//   void initState() {
//     super.initState();
//     _getCoordinatesAndStreetViewUrl();
//   }

//   Future<void> _getCoordinatesAndStreetViewUrl() async {
//     // Utilisez l'API de géocodage pour obtenir les coordonnées géographiques
//     final apiKey = "VOTRE_CLE_API"; // Remplacez par votre clé API
//     final address = Uri.encodeComponent(widget.address);
//     final apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey";

//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final location = data["results"][0]["geometry"]["location"];
//       final latitude = location["lat"];
//       final longitude = location["lng"];

//       // Utilisez les coordonnées pour générer l'URL Street View
//       final streetViewBaseUrl = "https://www.google.com/maps/@$latitude,$longitude,3a,75y,244.65h,94.16t/data=!3m4!1e1";
//       setState(() {
//         streetViewUrl = streetViewBaseUrl;
//       });
//     } else {
//       // Gestion des erreurs
//       print("Erreur lors de l'obtention des coordonnées géographiques");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Street View'),
//       ),
//       body: streetViewUrl.isNotEmpty
//           ? WebView(
//               initialUrl: streetViewUrl,
//               javascriptMode: JavascriptMode.unrestricted,
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }


// AIzaSyBVnHCNNY1wJr0ibeqdMFFBvJYVOYwBxUk