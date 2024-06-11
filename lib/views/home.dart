import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pfe/controllers/providers/provider.dart';
import 'package:flutter_pfe/views/details_Screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? rooms;
  int? Children;
  int? Adults;
  int? roommin;
  int? endyear;
  int? startyear;
  dynamic hotels;
  DateTime? datedebut;
  DateTime? datefin;

  final String Controller;
  SearchScreen(
      {super.key,
      required this.hotels,
      required this.datefin,
      required this.datedebut,
      required this.rooms,
      required this.Children,
      required this.Adults,
      required this.roommin,
      required this.Controller,
      required this.startday,
      required this.startmonth,
      required this.endyear,
      required this.startyear,
      required this.endday,
      required this.endmonth});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController TextController;
  List _allResults = [];
  List _Results = [];
  int minPrice = 0;
  int maxPrice = 5000;
  double minRating = 0;
  double maxRating = 5;
  bool isLoading = true;

  @override
  void initState() {
    TextController = TextEditingController(text: widget.Controller);
    TextController.addListener(_onSearchChnage);
    super.initState();
  }

  _onSearchChnage() {
    searchResultatList();
  }

  searchResultatList() {
    var showResultats = [];
    if (TextController.text != "") {
      for (var result in _allResults) {
        var title = result['title'].toString().toLowerCase();
        var address = result['adresse'].toString().toLowerCase();
        if (title.contains(TextController.text.toLowerCase()) ||
            address.contains(TextController.text.toLowerCase())) {
          showResultats.add(result);
        }
      }
    } else {
      showResultats = List.from(_allResults);
    }
    setState(() {
      isLoading = false;
      _Results = showResultats;
    });
  }

  void getTitleStream(
      int minPrice, int maxPrice, double minRating, double maxRating) async {
    var datas = await FirebaseFirestore.instance
        .collection('hotels')
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .orderBy('price')
        .get();

    var filteredByPrice = datas.docs.where((doc) {
      double rating = (doc.data()['rating'] as num).toDouble();
      return rating >= minRating && rating <= maxRating;
    }).toList();

    // Trier les résultats filtrés par rating
    filteredByPrice.sort((a, b) {
      double ratingA = (a.data()['rating'] as num).toDouble();
      double ratingB = (b.data()['rating'] as num).toDouble();
      return ratingB.compareTo(ratingA); // Tri décroissant par rating
    });

    setState(() {
      isLoading = false;
      _allResults = filteredByPrice;
    });
    searchResultatList();
  }

  @override
  void dispose() {
    TextController.removeListener(_onSearchChnage);
    TextController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getTitleStream(minPrice, maxPrice, minRating, maxRating);
    super.didChangeDependencies();
  }

  void applyFilters(int selectedMinPrice, int selectedMaxPrice,
      double selectedminRating, double selectedmaxRating) {
    // Appel de getTitleStream en passant les filtres sélectionnés
    getTitleStream(selectedMinPrice, selectedMaxPrice, selectedminRating,
        selectedmaxRating);

    Navigator.of(context).pop(); // Ferme la modal de filtre
    setState(() {
      _Results = List.from(_allResults);
      minPrice = selectedMinPrice; // Mettre à jour minPrice
      maxPrice = selectedMaxPrice;
      minRating = selectedminRating;
      maxRating = selectedmaxRating;
      isLoading = false; // Mettre à jour maxPrice
    });
    print(maxPrice);
  }

  // Autres méthodes

  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    // int adults = context.watch<SelectedProvider>().children;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF06B3C4),
          )) // Afficher un indicateur de chargement
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: CupertinoSearchTextField(
                controller: TextController,
              ),
              actions: [
                InkWell(
                  onTap: () {
                    showFilterModal(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
            body: Container(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 9 / 13),
                    itemCount: _Results.length,
                    itemBuilder: (context, i) {
                      var data = _Results[i];
                      final isFavorite = context
                          .watch<SelectedProvider>()
                          .isFavorite(data['hotelid']);

                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: const Offset(3, 3)),
                              ]),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        endyear: widget.endyear,
                                        startyear: widget.startyear,
                                        rooms: widget.rooms,
                                        Children: widget.Children,
                                        Adults: widget.Adults,
                                        roommin: widget.roommin,
                                        startday: widget.startday,
                                        startmonth: widget.startmonth,
                                        endday: widget.endday,
                                        endmonth: widget.endmonth,
                                        dataList: data,
                                        hotels: _Results,
                                        datedebut: widget.datedebut,
                                        datefin: widget.datefin,
                                      )));
                              print(widget.startday);
                              print(widget.startmonth);
                              print(widget.endday);
                              print(widget.endmonth);
                              print(_Results);
                              print(data);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        '${data['photos']['photo3']}',
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF06B3C4),
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
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 10, // Décalage par rapport au haut
                                      right:
                                          10, // Décalage par rapport à la gauche
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
                                          context
                                              .read<SelectedProvider>()
                                              .toggleFavorite(data['hotelid']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "⭐${data['rating'].toStringAsFixed(1)} (${data['reviews']})"),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "${data['title']}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "${data['adresse']}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        "\MAD ${data['price']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "\MAD ${data['price'] + data['discount']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  )),
            ),
          );
  }

  void showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\MAD $minPrice - \MAD $maxPrice',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  RangeSlider(
                    values:
                        RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
                    min: 0,
                    max: 5000,
                    divisions: 20,
                    // labels: RangeLabels('\$$minPrice', '\$$maxPrice'),
                    onChanged: (RangeValues values) {
                      setState(() {
                        minPrice = values.start.toInt();
                        maxPrice = values.end.toInt();
                      });
                    },
                    activeColor: const Color(0xFF06B3C4),
                    inactiveColor: Colors.grey,
                    onChangeStart: (RangeValues values) {
                      // Ne rien faire lors du début du changement de la valeur
                    },
                    onChangeEnd: (RangeValues values) {
                      // Ne rien faire à la fin du changement de la valeur
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rating',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '⭐$minRating - ⭐$maxRating',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  RangeSlider(
                    values:
                        RangeValues(minRating.toDouble(), maxRating.toDouble()),
                    min: 0,
                    max: 5,
                    divisions: 10,
                    // labels: RangeLabels('\$$minPrice', '\$$maxPrice'),
                    onChanged: (RangeValues values) {
                      setState(() {
                        minRating = values.start.toDouble();
                        maxRating = values.end.toDouble();
                      });
                    },
                    activeColor: Colors.yellow,
                    inactiveColor: Colors.grey,
                    onChangeStart: (RangeValues values) {
                      // Ne rien faire lors du début du changement de la valeur
                    },
                    onChangeEnd: (RangeValues values) {
                      // Ne rien faire à la fin du changement de la valeur
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      print(selectedRating);
                      print(maxPrice);
                      print(minPrice);
                      print(minRating);
                      print(maxRating);
                      applyFilters(minPrice, maxPrice, minRating, maxRating);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xFF06B3C4),
                      ),
                      child: const Center(
                          child: Text('Apply Filter ',
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
