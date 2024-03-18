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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) => TextField(
                  controller: controller.DestinationController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Enter destination',
                      hintStyle: TextStyle(
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
                                    '${controller.data[i]['Photos']['Photo3']}',
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
                                        "⭐${controller.data[i]['Ritting']} (${controller.data[i]['reviews']})"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "${controller.data[i]['Title']}",
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
                                    "${controller.data[i]['Adresse']}",
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
                                      "\$${controller.data[i]['price'] - (controller.data[i]['price'] * (controller.data[i]['discount']) / 100)}",
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
