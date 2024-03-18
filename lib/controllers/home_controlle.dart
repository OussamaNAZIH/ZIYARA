import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<QueryDocumentSnapshot> data = [];
  // var DestinationController = TextEditingController();

  var DestinationController = TextEditingController();
  Future<void> initialData(TextEditingController DestinationController) async {
    data = [];
    print("loading");
    CollectionReference datas = FirebaseFirestore.instance.collection('Hotels');
    QuerySnapshot hotelsdata = await datas
        .where('Title', isEqualTo: DestinationController.text.trim())
        .get();
    for (var element in hotelsdata.docs) {
      data.add(element);
      update();
    }
    print("test  ${DestinationController.text.trim()}");
  }

  @override
  Future<void> onInit() async {
    // DestinationController = DestinationController;
    // print(DestinationController.text.trim());
    await initialData(DestinationController);
    update();
    // print(data.length);
    // print(data[0]['Title']);
    super.onInit();
  }
}

// class Nerby {
//   List Nearby = [];
//   CollectionReference Nearbylref =
//       FirebaseFirestore.instance.collection("Hotels");
//   getData() async {
//     var responsebody = await Nearbylref.where('Ritting', isEqualTo: 4).get();
//     for (var element in responsebody.docs) {
//       Nearbylref.add(element.data());
//     }
//     print(Nearby);
//   }
// }
