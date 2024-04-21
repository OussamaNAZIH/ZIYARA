import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Rooms.dart';
import 'package:flutter_pfe/Screens/StreetView.dart';

class DetailsScreen extends StatelessWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? rooms;
  int? Children;
  int? Adults;
  int? roommin;
  dynamic dataList;
  dynamic hotels;
  String? datefin;
    String? datedebut;


  DetailsScreen(
      {super.key,
      required this.datedebut,
      required this.datefin,
      required this.hotels,
      required this.rooms,
      required this.Children,
      required this.Adults,
      required this.roommin,
      required this.dataList,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.favorite_border_outlined,
                size: 30, color: Colors.white),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            size: 40,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
            print(hotels);
          },
        ),
        title: const Center(
          child: Text(
            "Detail Hotel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 260,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: dataList['photos'] != null &&
                                  dataList['photos'].length >
                                      0 // Vérifiez si la liste de photos n'est pas vide
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataList['photos'].length,
                                  itemBuilder: (context, index) {
                                    String photoKey =
                                        'photo${index + 1}'; // Génère la clé de la photo (photo1, photo2, photo3, ...)
                                    String photoUrl = dataList['photos'][
                                        photoKey]; // Récupère l'URL de la photo à partir de la carte dataList
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.zero,
                                            topRight: Radius.zero,
                                            bottomLeft: Radius.circular(
                                                15), // Pas de radius pour le coin en bas à gauche
                                            bottomRight: Radius.circular(
                                                15), // Pas de radius pour le coin en bas à droite
                                          ),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.3),
                                              BlendMode.srcATop,
                                            ),
                                            child: Center(
                                              child: Image.network(
                                                photoUrl,
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('No photos available'),
                                ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${dataList['title']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                Text(
                                  "${dataList['adresse']}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Ckeck-in",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$startday/$startmonth",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Ckeck-in",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$endday/$endmonth",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rooms and guests",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        (roommin! >= rooms!
                                ? '$roommin is minimum  rooms . '
                                : '$rooms room . ') +
                            (Children == 0
                                ? '$Adults adults . No children'
                                : '$Adults adults . $Children children'),
                        style: const TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Common Facilities",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //     child: ListView.builder(
                //         itemCount: 3,
                //         scrollDirection: Axis.horizontal,
                //         itemBuilder: (context, index) {
                //           return const MyCircle();
                //         })),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Location",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'View Detail',
                        style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              StreetViewScreen(Maps: dataList)));
                      print(dataList['latitude']);
                      print(dataList['longitude']);
                    },
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 162, 164, 164),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Container(
                              height: 135,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.asset(
                                'images/download.jpg',
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF06B3C4),
                                  ),
                                  Text(
                                    "${dataList['adresse']}",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 137, 134, 134)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Review",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Review",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment
                      .bottomCenter, // Début du dégradé en haut à gauche
                  end: Alignment.topCenter, // Fin du dégradé en bas à droite
                  colors: [
                    Color.fromARGB(
                        255, 255, 255, 255), // Couleur de départ du dégradé
                    Color.fromARGB(
                        0, 255, 255, 255), // Couleur de fin du dégradé
                  ],
                  stops: [
                    0.65,
                    2.0
                  ], // Arrêtez la répartition des couleurs (0.0 pour le début, 1.0 pour la fin)
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      '\$24.00',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Book(
                                    startday: startday,
                                    startmonth: startmonth,
                                    endday: endday,
                                    endmonth: endmonth,
                                    dataList: dataList,
                                    rooms: rooms,
                                    Children: Children,
                                    Adults: Adults,
                                    roommin: roommin,
                                    datedebut:datedebut,
                                    datefin:datefin,
                                  )));
                      print(dataList);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF06B3C4),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            '  Booking Now  ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
