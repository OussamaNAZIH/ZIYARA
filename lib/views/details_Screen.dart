import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pfe/Screens/Rooms.dart';
import 'package:flutter_pfe/Screens/StreetView.dart';
import 'package:flutter_pfe/Screens/hotel_reviews.dart';

class DetailsScreen extends StatefulWidget {
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
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int totalChamspValue = 0;
  Future<void> calculerTotalChamspValue() async {
    final String? datedebut = widget.datedebut;
    final String? datefin = widget.datefin;

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

  @override
  Widget build(BuildContext context) {
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
                  print(widget.hotels);
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
                                    // Add your onPressed logic here
                                  },
                                ),
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
                                fontSize: 16,
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  StreetViewScreen(Maps: widget.dataList)));
                          print(widget.dataList['latitude']);
                          print(widget.dataList['longitude']);
                        },
                        child: Center(
                          child: Container(
                            height: 190,
                            width: 290,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 162, 164, 164),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 135,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                                  255, 137, 134, 134)),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HotelReviews(
                                        Hotelreviews: Hotelreviews),
                                  ),
                                );
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
                      Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Hotelreviews.isNotEmpty
                            ? InkWell(
                                // onTap: (){
                                //    Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => DetailsScreen()));
                                // },
                                child: buildHotelCard2(
                                    0), // Afficher la carte pour le seul élément de la liste
                              )
                            : Center(
                                child: const Text(
                                  'No reviews yet.',
                                  style: TextStyle(),
                                ),
                              ), // Afficher un indicateur de chargement si la liste est vide
                      ),
                      Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Hotelreviews.isNotEmpty
                            ? InkWell(
                                // onTap: (){
                                //    Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => DetailsScreen()));
                                // },
                                child: buildHotelCard2(
                                    1), // Afficher la carte pour le seul élément de la liste
                              )
                            : const Text(
                                '',
                                style: TextStyle(),
                              ), // Afficher un indicateur de chargement si la liste est vide
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
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '\$24.00',
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
          Text('⭐ ${Hotelreview['rating'] ?? ''}'),
        ],
      ),
    );
  }
}
