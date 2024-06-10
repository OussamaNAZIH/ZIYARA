import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pfe/controllers/providers/provider.dart';
import 'package:flutter_pfe/views/details_Screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<DocumentSnapshot> _allResults;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Récupération de tous les hôtels
    final allData = await FirebaseFirestore.instance.collection('hotels').get();
    final selectedProvider =
        Provider.of<SelectedProvider>(context, listen: false);
    setState(() {
      _allResults = allData.docs.where((doc) {
        var data = doc.data();
        return selectedProvider.isFavorite(data['hotelid']);
      }).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFF06B3C4),
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Center(
                  child: Text('My Favorite', style: TextStyle(fontSize: 22))),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Divider(
                  color: Color.fromARGB(255, 219, 219, 219),
                  height: 1.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 9 / 13),
                itemCount: _allResults.length,
                itemBuilder: (context, i) {
                  var data = _allResults[i].data() as Map<String, dynamic>;
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => DetailsScreen(
                        //           rooms: widget.rooms,
                        //           Children: widget.Children,
                        //           Adults: widget.Adults,
                        //           roommin: widget.roommin,
                        //           startday: widget.startday,
                        //           startmonth: widget.startmonth,
                        //           endday: widget.endday,
                        //           endmonth: widget.endmonth,
                        //           dataList: data,
                        //           hotels: data,
                        //           datedebut: widget.datedebut,
                        //           datefin: widget.datefin,
                        //         )));
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
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    size: 30,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<SelectedProvider>()
                                        .toggleFavorite(data['hotelid']);
                                    setState(() {
                                      _fetchData();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
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
                                  "\$${data['price']}",
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
                                  "\$${data['price'] + data['discount']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
