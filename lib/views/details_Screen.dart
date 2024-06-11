import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Rooms.dart';
import 'package:flutter_pfe/Screens/StreetView.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:flutter_pfe/Screens/aa.dart';
import 'package:flutter_pfe/Screens/hotel_reviews.dart';
import 'package:flutter_pfe/Screens/reviews_screen.dart';
import 'package:flutter_pfe/controllers/providers/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? rooms;
  int? Children;
  int? Adults;
  int? roommin;
  int? startyear;
  int? endyear;
  dynamic dataList;
  dynamic hotels;
  DateTime? datefin;
  DateTime? datedebut;

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
      required this.endyear,
      required this.startyear,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int totalChamspValue = 0;
  Future<void> calculerTotalChamspValue() async {
    final DateTime? datedebut = widget.datedebut;
    final DateTime? datefin = widget.datefin;

    // Récupérer les documents dont la date de début est après ou le même jour que la date de fin saisie
    final QuerySnapshot querySnapshotDebut = await FirebaseFirestore.instance
        .collection('reservation')
        .where('datedebut', isLessThanOrEqualTo: datefin)
        .get();

    // Récupérer les documents dont la date de fin est avant ou le même jour que la date de début saisie
    final QuerySnapshot querySnapshotFin = await FirebaseFirestore.instance
        .collection('reservation')
        .where('datefin', isGreaterThanOrEqualTo: datedebut)
        .get();

    // Fusionner les résultats des deux requêtes
    final List<QueryDocumentSnapshot> documentsDebut = querySnapshotDebut.docs;
    final List<QueryDocumentSnapshot> documentsFin = querySnapshotFin.docs;
    final List<QueryDocumentSnapshot> documents = [
      ...documentsDebut,
      ...documentsFin
    ];

    // Calculer la somme des chamspValue
    int total = 0;
    documents.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final chamspValue = data['chamspValue'] as int? ?? 0;
      total += chamspValue;
    });

    setState(() {
      totalChamspValue = total;
      isLoading = false;
    });
  }

  bool isLoading = true;

  List reviewData = [];

  CollectionReference review = FirebaseFirestore.instance.collection("reviews");

  @override
  void initState() {
    super.initState();
    // Appeler getData() lors de l'initialisation du widget
    getData();
    reviews();
  }

  // Méthode pour récupérer les données de la collection Firestore
  getData() async {
    var responsebody = await review
        .where('hotelId', isEqualTo: widget.dataList['hotelid'])
        .get();
    for (var element in responsebody.docs) {
      setState(() {
        reviewData.add(element.data());
        isLoading = false;
      });
    }
  }

  int _calculateTotalChamspValue(QuerySnapshot snapshot) {
    int total = 0;
    snapshot.docs.forEach((doc) {
      final data =
          doc.data() as Map<String, dynamic>?; // Spécifiez le type de data
      if (data != null) {
        final chamspValue = data['chamspValue'] as int? ?? 0;
        total += chamspValue;
      }
    });
    return total;
  }

  List Hotelreviews = [];

  CollectionReference Hotelreviewsref =
      FirebaseFirestore.instance.collection("reviews");
  reviews() async {
    var responsebody = await Hotelreviewsref.where('hotelId',
            isEqualTo: widget.dataList['hotelid'])
        .get();
    for (var element in responsebody.docs) {
      setState(() {
        Hotelreviews.add(element.data());
      });
    }

    // Print the list after fetching the data
    print('Hotelreviews: $Hotelreviews');

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _launchMapsUrl(double latitude, double longitude) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider = Provider.of<SelectedProvider>(context);
    final String hotelId =
        widget.dataList['hotelid']; // Utilisation de l'ID de l'hôtel
    final bool isFavorite = selectedProvider.isFavorite(hotelId);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF06B3C4),
          )) // Afficher un indicateur de chargement
        : Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      size: 30,
                      color: isFavorite
                          ? Color.fromARGB(255, 255, 0, 0)
                          : Colors
                              .white, // Changement de couleur en fonction de isFavorite
                    ),
                    onPressed: () {
                      context.read<SelectedProvider>().toggleFavorite(hotelId);
                    },
                  ),
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
                                height: 230,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: widget.dataList['photos'] != null &&
                                        widget.dataList['photos'].length >
                                            0 // Vérifiez si la liste de photos n'est pas vide
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.dataList['photos'].length,
                                        itemBuilder: (context, index) {
                                          String photoKey =
                                              'photo${index + 1}'; // Génère la clé de la photo (photo1, photo2, photo3, ...)
                                          String photoUrl = widget
                                                  .dataList['photos'][
                                              photoKey]; // Récupère l'URL de la photo à partir de la carte dataList
                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.zero,
                                                  topRight: Radius.zero,
                                                  bottomLeft: Radius.circular(
                                                      15), // Pas de radius pour le coin en bas à gauche
                                                  bottomRight: Radius.circular(
                                                      15), // Pas de radius pour le coin en bas à droite
                                                ),
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.3),
                                                    BlendMode.srcATop,
                                                  ),
                                                  child: Center(
                                                    child: Image.network(
                                                      photoUrl,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Color(
                                                                  0xFF06B3C4),
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Icon(Icons
                                                            .error); // Widget à afficher en cas d'erreur de chargement de l'image
                                                      },
                                                      width:
                                                          MediaQuery.of(context)
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "${widget.dataList['title']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      Text(
                                        "${widget.dataList['adresse']}",
                                        style: const TextStyle(
                                            color: Colors.white),
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
                        padding: const EdgeInsets.all(18.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 162, 164, 164),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Check-in",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${widget.startday}/${widget.startmonth}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: VerticalDivider(
                                                color: Colors.black,
                                                width: 80,
                                                indent: 10,
                                                thickness: 2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Check-out",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${widget.endday}/${widget.endmonth}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            (widget.roommin! >= widget.rooms!
                                                    ? '${widget.roommin} is minimum  rooms . '
                                                    : '${widget.rooms} room . ') +
                                                (widget.Children == 0
                                                    ? '${widget.Adults} adults . No children'
                                                    : '${widget.Adults} adults . ${widget.Children} children'),
                                            style: const TextStyle(
                                              color: Color(0xFF06B3C4),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -15,
                              right: -15,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF06B3C4),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => TabScreen()));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Overview",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(widget.dataList['description ']),
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
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _launchMapsUrl(widget.dataList['latitude'],
                              widget.dataList['longitude']);
                          print(widget.dataList['latitude']);
                          print(widget.dataList['longitude']);
                        },
                        child: Center(
                          child: Container(
                            height: 190,
                            width: 290,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 162, 164, 164),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 135,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                                          "${widget.dataList['adresse']}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 137, 134, 134),
                                          ),
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
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Review",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (widget.datedebut != null &&
                                    widget.datefin != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => HotelReviews(
                                        Hotelreviews: Hotelreviews,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Handle the case when dates are null, maybe show an error message
                                }
                                print(Hotelreviews);
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFF06B3C4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Hotelreviews.isNotEmpty)
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: InkWell(
                            child: buildHotelCard2(
                                0), // Afficher la carte pour le seul élément de la liste
                          ),
                        )
                      else
                        Center(
                          child: const Text(
                            'No reviews yet.',
                            style: TextStyle(),
                          ),
                        ),
                      if (Hotelreviews.length > 1)
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: InkWell(
                            child: buildHotelCard2(
                                1), // Afficher la carte pour le deuxième élément de la liste, s'il existe
                          ),
                        )
                      else
                        const Text(
                          '',
                          style: TextStyle(),
                        ),
                      SizedBox(
                        height: 100,
                      )
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
                        end: Alignment
                            .topCenter, // Fin du dégradé en bas à droite
                        colors: [
                          Color.fromARGB(255, 255, 255,
                              255), // Couleur de départ du dégradé
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
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '\MAD ${widget.dataList['price']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            calculerTotalChamspValue();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Book(
                                          startday: widget.startday,
                                          startmonth: widget.startmonth,
                                          endyear: widget.endyear,
                                          startyear: widget.startyear,
                                          endday: widget.endday,
                                          endmonth: widget.endmonth,
                                          dataList: widget.dataList,
                                          rooms: widget.rooms,
                                          Children: widget.Children,
                                          Adults: widget.Adults,
                                          roommin: widget.roommin,
                                          datedebut: widget.datedebut,
                                          datefin: widget.datefin,
                                        )));
                            print(widget.dataList);
                            print(
                                'total  chamspvalue   reserer$totalChamspValue');
                            print(widget.datefin);
                            print(widget.datedebut);
                            print('Hotelreviews ***: $Hotelreviews');
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

  Widget buildHotelCard2(int index) {
    final Hotelreview = Hotelreviews[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: Hotelreview['username'] != null
                  ? NetworkImage(
                      'https://ui-avatars.com/api/?name=${Hotelreview['username']}&font-size=0.36&color=233467&background=random',
                    )
                  : null,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Hotelreview['username'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Hotelreview['messege'] ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Text('⭐ ${Hotelreview['rating'].toStringAsFixed(1) ?? ''}'),
        ],
      ),
    );
  }
}
