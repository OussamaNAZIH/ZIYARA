import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pfe/controllers/home_controlle.dart';
import 'package:flutter_pfe/views/details_Screen.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  final String Controller;
  SearchScreen(
      {super.key,
      required this.Controller,
      required this.startday,
      required this.startmonth,
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
  int maxPrice = 1000;
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
      for (var titleSnapShot in _allResults) {
        var title = titleSnapShot['title'].toString().toLowerCase();
        if (title.contains(TextController.text.toLowerCase())) {
          showResultats.add(titleSnapShot);
        }
      }
    } else {
      showResultats = List.from(_allResults);
    }
    setState(() {
      _Results = showResultats;
    });
  }

  getTitleStream() async {
    var datas = await FirebaseFirestore.instance
        .collection('hotels')
        .where('rating', isEqualTo: selectedRating)
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .orderBy('title')
        .get();

    setState(() {
      _allResults = datas.docs;
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
    getTitleStream();
    super.didChangeDependencies();
  }

  void applyFilters() {
    getTitleStream();
    Navigator.of(context).pop(); // Close the filter modal
  }

  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 9 / 13),
              itemCount: _Results.length,
              itemBuilder: (context, i) {
                var data = _Results[i];
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
                                startday: widget.startday,
                                startmonth: widget.startmonth,
                                endday: widget.endday,
                                endmonth: widget.endmonth,
                                dataList: data)));
                        print(widget.startday);
                        print(widget.startmonth);
                        print(widget.endday);
                        print(widget.endmonth);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${data['photos']['photo3']}',
                              ),
                            ),
                          ]),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "⭐${data['rating']} (${data['reviews']})"),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "${data['title']}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "${data['adresse']}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  "\$${(data['price'] - (data['price'] * (data['discount']) / 100)).round()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "\$${data['price']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      decoration: TextDecoration.lineThrough),
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
    int minPrice = 0;
    int maxPrice = 1000;

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
                        '\$$minPrice - \$$maxPrice',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  RangeSlider(
                    values:
                        RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
                    min: 0,
                    max: 1000,
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
                  const Text(
                    'Ratings',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildRatingContainer(5),
                        const Spacer(),
                        _buildRatingContainer(4),
                        const Spacer(),
                        _buildRatingContainer(3),
                        const Spacer(),
                        _buildRatingContainer(2),
                        const Spacer(),
                        _buildRatingContainer(1),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      applyFilters();
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

  Widget _buildRatingContainer(int rating) {
    final selectedRating = RxInt(0);

    return GestureDetector(
      onTap: () {
        if (selectedRating.value == rating) {
          selectedRating.value = 0; // Déselectionne si déjà sélectionné
        } else {
          selectedRating.value = rating;
        }
        print(selectedRating);
      },
      child: Obx(() => Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedRating.value == rating
                    ? const Color(0xFF06B3C4)
                    : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                '⭐ $rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selectedRating.value == rating
                      ? const Color(0xFF06B3C4)
                      : Colors.black,
                ),
              ),
            ),
          )),
    );
  }
}
