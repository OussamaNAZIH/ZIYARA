import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Moduls/SplashScreen.dart';
import 'package:flutter_pfe/Setting/setting.dart';
import 'package:flutter_pfe/controllers/home_controlle.dart';
import 'package:flutter_pfe/views/details_Screen.dart';
import 'package:flutter_pfe/views/home.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List hotels = [];
  CollectionReference Hotelref =
      FirebaseFirestore.instance.collection("hotels");
  getData() async {
    var responsebody = await Hotelref.get();
    for (var element in responsebody.docs) {
      setState(() {
        hotels.add(element.data());
      });
    }
  }

  String? _userName = '';
  void _getCurrentUser() async {
    // Récupération de l'utilisateur actuel authentifié avec Firebase
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Récupération des données utilisateur à partir de Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Mise à jour de l'interface utilisateur avec les informations utilisateur récupérées
      setState(() {
        _userName = userData['username'];
      });
    }
  }

  List<String> _titles = [];

  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int Adults = 1;
  int Children = 0;
  int rooms = 1;
  final List<String> _hotelTitles = [];
  FirebaseAuth instance = FirebaseAuth.instance;
  bool _DestinationController = true;
  bool _mailTextFieldEmpty = true;
  bool _travelersControllerEmpty = true;
  // final controller = HomeController();
///////////////////

  bool dateTextFieldEmpty = true;
  bool guestTextFieldEmpty = true;
  bool roomTypeTextFieldEmpty =
      true; // Variable pour suivre si le champ "Room Type" est vide
  bool phoneNumberTextFieldEmpty =
      true; // Variable pour suivre si le champ "Number Phone" est vide
  bool isDateSelected = false;
  bool isGuestEntered =
      false; // Variable pour suivre si les détails des invités ont été entrés

  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

////////////////////////////////////////

  final durationController = TextEditingController();
  final travelersController = TextEditingController();
  final AdultsController = TextEditingController();
  final childrenController = TextEditingController();
  final RoomsController = TextEditingController();
  late TextEditingController DestinationController;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchTitles();

    DestinationController = TextEditingController();

    getData();
    DestinationController.addListener(() {
      setState(() {
        _DestinationController = DestinationController.text.isEmpty;
      });
    });
    durationController.addListener(() {
      setState(() {
        _mailTextFieldEmpty = durationController.text.isEmpty;
      });
    });
    travelersController.addListener(() {
      setState(() {
        _travelersControllerEmpty = travelersController.text.isEmpty;
      });
    });
    instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      }
    });
  }

  Future<void> _fetchTitles() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      List<String> titles = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String,
            dynamic>?; // Cast explicite vers Map<String, dynamic> ou utilisez le type de données correct
        if (data != null && data['title'] != null) {
          return data['title'] as String;
        } else {
          return ''; // ou toute autre valeur par défaut
        }
      }).toList();

      setState(() {
        _titles = titles;
      });
    } catch (e) {
      print('Error fetching titles: $e');
      // Gérer les erreurs en conséquence
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('images/profile.png'),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "Hi, $_userName",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.grey,
                            ),
                            Text('Chestnut StreetRome,NY'),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountScreen()));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "let's find the best hotels around the world ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF06B3C4), width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 15),
                            child: Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return _titles.where((String item) =>
                                    item.contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String item) {
                                print('the $item');
                                DestinationController.text = item;
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController controller,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter destination',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[500], fontSize: 16),
                                    // Ajout de la bordure

                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: _DestinationController
                                          ? Colors.grey
                                          : const Color(0xFF06B3C4),
                                      size: 35,
                                    ),
                                  ),
                                  onChanged: (String value) {
                                    // You can add additional logic here if necessary
                                  },
                                  onSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
                                );
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<String> onSelected,
                                  Iterable<String> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        children: options.map((String option) {
                                          return ListTile(
                                            title: Text(option),
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    controller:
                                    durationController.text;
                                    final DateTimeRange? dateTimeRange =
                                        await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(3000));
                                    if (dateTimeRange != null) {
                                      setState(() {
                                        selectedDates = dateTimeRange;
                                        isDateSelected = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 10, right: 5),
                                          child: Icon(
                                            Icons.calendar_today,
                                            color: isDateSelected
                                                ? const Color(0xFF06B3C4)
                                                : dateTextFieldEmpty
                                                    ? Colors.grey[400]
                                                    : const Color(0xFF06B3C4),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${selectedDates.start.day}/${selectedDates.start.month}/${selectedDates.start.year} - ${selectedDates.end.day}/${selectedDates.end.month}/${selectedDates.end.year}',
                                            style: TextStyle(
                                              color: dateTextFieldEmpty
                                                  ? Colors.grey[500]
                                                  : Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(right: 15),
                                        //   child: Icon(
                                        //     Icons.keyboard_arrow_down_outlined,
                                        //     color: guestTextFieldEmpty
                                        //         ? Colors.grey[400]
                                        //         : const Color(0xFF06B3C4),
                                        //     size: 40,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller:
                                    '${selectedDates.start.day}/${selectedDates.start.month}/${selectedDates.start.year} - ${selectedDates.end.day}/${selectedDates.end.month}/${selectedDates.end.year}';
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    const Center(
                                                      child: Text(
                                                        'Guest Selection',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Adults',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    // Vos autres widgets ici...
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.grey[50],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.remove),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Décrémenter le nombre de chambres s'il est supérieur à 1
                                                                if (Adults >
                                                                    1) {
                                                                  Adults--;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                                hintText: Adults
                                                                    .toString(), // Utiliser la valeur actuelle des chambres comme hintText
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                // Mettre à jour la valeur des chambres lors de la saisie manuelle
                                                                setState(() {
                                                                  Adults = int.tryParse(
                                                                          value) ??
                                                                      Adults;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.add),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Incrémenter le nombre de chambres
                                                                Adults++;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Childrens',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    // Vos autres widgets ici...
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.grey[50],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.remove),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Décrémenter le nombre de chambres s'il est supérieur à 1
                                                                if (Children >
                                                                    0) {
                                                                  Children--;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .child_care,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                                hintText: Children
                                                                    .toString(), // Utiliser la valeur actuelle des chambres comme hintText
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                // Mettre à jour la valeur des chambres lors de la saisie manuelle
                                                                setState(() {
                                                                  Children = int
                                                                          .tryParse(
                                                                              value) ??
                                                                      Children;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.add),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Incrémenter le nombre de chambres
                                                                Children++;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Rooms',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    // Vos autres widgets ici...
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.grey[50],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.remove),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Décrémenter le nombre de chambres s'il est supérieur à 1
                                                                if (rooms > 1) {
                                                                  rooms--;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons.hotel,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                                hintText: rooms
                                                                    .toString(), // Utiliser la valeur actuelle des chambres comme hintText
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                // Mettre à jour la valeur des chambres lors de la saisie manuelle
                                                                setState(() {
                                                                  rooms = int.tryParse(
                                                                          value) ??
                                                                      rooms;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.add),
                                                            onPressed: () {
                                                              setState(() {
                                                                // Incrémenter le nombre de chambres
                                                                rooms++;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Adults;
                                                            Children;
                                                            rooms;
                                                          });
                                                          // Action à effectuer lors de la validation du formulaire
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            color: const Color(
                                                                0xFF06B3C4),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Save',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    )
                                                    // Vos autres widgets ici...
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 15,
                                              right: 5,
                                              bottom: 15),
                                          child: Icon(
                                            Icons.person,
                                            color: isGuestEntered
                                                ? const Color(0xFF06B3C4)
                                                : guestTextFieldEmpty
                                                    ? Colors.grey[400]
                                                    : const Color(0xFF06B3C4),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            ' Adults: $Adults . Children: $Children . Rooms : $rooms',
                                            style: TextStyle(
                                              color: _travelersControllerEmpty
                                                  ? Colors.grey[500]
                                                  : Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    startday = selectedDates.start.day;
                                    startmonth = selectedDates.start.month;
                                    endday = selectedDates.end.day;
                                    endmonth = selectedDates.end.month;

                                    controller:
                                    '${selectedDates.start.day}/${selectedDates.start.month}/${selectedDates.start.year} - ${selectedDates.end.day}/${selectedDates.end.month}/${selectedDates.end.year}';

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SearchScreen(
                                                startday: startday,
                                                startmonth: startmonth,
                                                endday: endday,
                                                endmonth: endmonth,
                                                Controller:
                                                    DestinationController
                                                        .text)));

                                    print(startday);
                                    print(startmonth);
                                    print(endday);
                                    print(endmonth);
                                    print(RoomsController);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF06B3C4),
                                    ),
                                    child: const Center(
                                        child: Text('Rechercher',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Recomended Hotel 🔥',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'See All ',
                      style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 400,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotels.length,
                      itemBuilder: ((context, int i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                    startday: 0,
                                    startmonth: 0,
                                    endday: 0,
                                    endmonth: 0,
                                    dataList: hotels[i])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(10),
                            width: 280,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      BlendMode.srcATop,
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        '${hotels[i]['photo1']}',
                                        // fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    255, 255, 255, 40),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Row(
                                                children: [
                                                  // Text(
                                                  //   "\$${hotels[i]['price'] - (hotels[i]['price'] * (hotels[i]['discount']) / 100)}",
                                                  //   style: const TextStyle(
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //       color: Color.fromARGB(
                                                  //           255, 0, 0, 0)),
                                                  // ),
                                                  Text(
                                                    '\$${hotels[i]['price']}/Day',
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.favorite_border_outlined,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   height: 40,
                                    // ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 40),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '⭐${hotels[i]['rating']} ',
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 166, 12)),
                                                  ),
                                                  Text(
                                                    '(${hotels[i]['reviews']})',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${hotels[i]['title']}",
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    "${hotels[i]['adresse']}",
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.bed_outlined,
                                                    color: Color(0xFF06B3C4),
                                                  ),
                                                  Text(' 2 Bads'),
                                                  Spacer(),
                                                  Text('.'),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.bed_outlined,
                                                    color: Color(0xFF06B3C4),
                                                  ),
                                                  Text(' Wifi'),
                                                  Spacer(),
                                                  Text('.'),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.bed_outlined,
                                                    color: Color(0xFF06B3C4),
                                                  ),
                                                  Text(' Gym'),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Nearby Hotels',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'See All ',
                      style: TextStyle(
                          color: Color(0xFF06B3C4),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.srcATop,
                              ),
                              child: Image.asset(
                                'images/profile.png',
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Column(
                              children: [
                                Text(
                                  "title",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  "adresse",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Text('\$ price / Night'),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text('⭐rating '),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
