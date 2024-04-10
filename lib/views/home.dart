import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/controllers/home_controlle.dart';
import 'package:flutter_pfe/views/details_Screen.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController? destinationController;
  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  SearchScreen(
      {super.key,
      required TextEditingController destinationController,
      required this.startday,
      required this.startmonth,
      required this.endday,
      required this.endmonth});

  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        //   title: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.grey[100],
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: TextField(
        //       decoration: InputDecoration(
        //         border: InputBorder.none,
        //         hintText: 'Recherche...',
        //         prefixIcon: GestureDetector(
        //           // Ajout d'un GestureDetector autour de l'icône de recherche
        //           onTap: () {
        //             // Action à effectuer lorsqu'on clique sur l'icône de recherche
        //             GetBuilder<HomeController>(
        //               builder: (controller) => IconButton(
        //                 icon: const Icon(Icons.search),
        //                 color: Colors.red,
        //                 onPressed: () {
        //                   controller
        //                       .initialData(controller.DestinationController);
        //                   controller.update();
        //                   // Action lorsqu'on clique sur le bouton de recherche
        //                 },
        //               ),
        //             );
        //           },
        //           child: const Icon(Icons.search),
        //         ),
        //         suffixIcon: InkWell(
        //           onTap: () {
        //             // Action à effectuer lorsqu'on clique sur l'icône de filtrage
        //           },
        //           child: const Icon(Icons.filter_list),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: controller.DestinationController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: InkWell(
                        onTap: () {
                          showFilterModal(context);
                        },
                        child: const Icon(Icons.filter_list),
                      ),
                      hintText: 'Enter destination',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      )
                      // Ajout de la bordure
                      ),
                ),
              ),
            ),
          ),
          leading: GetBuilder<HomeController>(
            builder: (controller) => IconButton(
              icon: const Icon(Icons.search),
              color: Colors.red,
              onPressed: () {
                // controller.DestinationController = destinationController!;

                controller.initialData(controller.DestinationController);
                controller.update();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             const HomeScreen())); // Action lorsqu'on clique sur le bouton de menu
              },
            ),
          ),
        ),
        body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => Container(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 13),
                  itemCount: controller.data.length,
                  itemBuilder: (context, int i) {
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
                                    startday: startday,
                                    startmonth: startmonth,
                                    endday: endday,
                                    endmonth: endmonth,
                                    dataList: controller.data[i])));
                            print(startday);
                            print(startmonth);
                            print(endday);
                            print(endmonth);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    '${controller.data[i]['photos']['photo3']}',
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
                                        "⭐${controller.data[i]['rating']} (${controller.data[i]['reviews']})"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "${controller.data[i]['title']}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Flexible(
                                  child: Text(
                                    "${controller.data[i]['adresse']}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Text(
"\$${(controller.data[i]['price'] - (controller.data[i]['price'] * (controller.data[i]['discount']) / 100)).round()}",
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
                                      "\$${controller.data[i]['price']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Color.fromARGB(255, 255, 0, 0),
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
        ));
  }
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
                  values: RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
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
                const SizedBox(height: 16.0),
                const Text(
                  'Ratings',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                )
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
