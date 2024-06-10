import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/views/details_Screen.dart';

class RecomendedHotel extends StatefulWidget {
  const RecomendedHotel({super.key});

  @override
  State<RecomendedHotel> createState() => _RecomendedHotelState();
}

class _RecomendedHotelState extends State<RecomendedHotel> {
  List HotelRecomended = [];
  CollectionReference Hotelref =
      FirebaseFirestore.instance.collection("hotels");
  bool isLoading = true; // Ajouté pour gérer l'affichage de chargement

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var responsebody = await Hotelref.orderBy('rating', descending: true).get();
    List temp = [];
    for (var element in responsebody.docs) {
      temp.add(element.data());
    }
    setState(() {
      HotelRecomended = temp;
      isLoading = false; // Mise à jour de l'état de chargement
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Recommended Hotels 🔥',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xFF06B3C4),
            )) // Afficher un indicateur de chargement
          : Container(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 9 / 13),
                    itemCount: 5, // Modifié pour refléter la taille de la liste
                    itemBuilder: (context, i) {
                      return buildHotelCard(i);
                    },
                  )),
            ),
    );
  }

  Widget buildHotelCard(int i) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    '${HotelRecomended[i]['photos']['photo3']}',
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
                        "⭐${HotelRecomended[i]['rating'].toStringAsFixed(1)} (${HotelRecomended[i]['reviews']})"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${HotelRecomended[i]['title']}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${HotelRecomended[i]['adresse']}",
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
                      "\$${HotelRecomended[i]['chamsp']['price']}",
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
                      "\$${HotelRecomended[i]['chamsp']['price']}",
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
  }
}
