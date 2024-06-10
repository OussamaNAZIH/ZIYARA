import 'dart:async';
import 'dart:math';
import 'package:flutter_pfe/Screens/ReservationScreen.dart';
import 'package:flutter_pfe/views/details_Screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pfe/Moduls/SplashScreen.dart';
import 'package:flutter_pfe/Moduls/nearby.dart';
import 'package:flutter_pfe/Screens/recomended_hotel.dart';
import 'package:flutter_pfe/controllers/providers/provider.dart';
import 'package:flutter_pfe/views/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Hotel {
  final String title;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviews;
  final String adresse;
  final int price;
  final int discount;
  final String photo1;
  final String photo2;
  final String photo3;

  Hotel({
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviews,
    required this.adresse,
    required this.price,
    required this.discount,
    required this.photo1,
    required this.photo2,
    required this.photo3,
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List hotels = [];
  CollectionReference Hotelref =
      FirebaseFirestore.instance.collection("hotels");

  getData() async {
    var responsebody = await Hotelref.orderBy('rating', descending: true).get();
    if (mounted) {
      setState(() {
        hotels = responsebody.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    }
  }

  DateTime? startDate;
  DateTime? endDate;
  String? _userName = '';
  String? _profile = '';
  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          _userName = userData['username'];
          _profile = userData['userprofile'];
          isLoading = false;
        });
      }
    }
  }

  List<String> _titles = [];
  late Timer _locationUpdateTimer;

  int? startday;
  int? startmonth;
  int? endday;
  int? endmonth;
  int? startyear;
  int? endyear;
  String? date;

  final List<String> _hotelTitles = [];
  FirebaseAuth instance = FirebaseAuth.instance;
  bool _DestinationController = true;
  bool _mailTextFieldEmpty = true;
  final bool _travelersControllerEmpty = true;
  bool dateTextFieldEmpty = true;
  bool guestTextFieldEmpty = true;
  bool roomTypeTextFieldEmpty = true;
  bool phoneNumberTextFieldEmpty = true;
  bool isDateSelected = false;
  bool _isGuestEnteredControllerEmpty = true;

  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  final durationController = TextEditingController();
  final isGuestEnteredController = TextEditingController();
  final AdultsController = TextEditingController();
  final childrenController = TextEditingController();
  final RoomsController = TextEditingController();
  late TextEditingController DestinationController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchTitlesAndAddresses();
    _requestPermissionAndGetLocation();
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _requestPermissionAndGetLocation();
      _getCurrentLocation(); // Actualise la position toutes les 10 minutes
    });

    DestinationController = TextEditingController();

    getData();
    DestinationController.addListener(() {
      if (mounted) {
        setState(() {
          _DestinationController = DestinationController.text.isEmpty;
        });
      }
    });
    durationController.addListener(() {
      if (mounted) {
        setState(() {
          _mailTextFieldEmpty = durationController.text.isEmpty;
        });
      }
    });
    isGuestEnteredController.addListener(() {
      if (mounted) {
        setState(() {
          _isGuestEnteredControllerEmpty =
              isGuestEnteredController.text.isEmpty;
        });
      }
    });
    instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      }
    });
  }

  @override
  void dispose() {
    _locationUpdateTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchTitlesAndAddresses() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hotels').get();

      List<String> titlesAndAddresses = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data['title'] != null) {
            String title = data['title'] as String;
            titlesAndAddresses.add(title);
          }
          if (data['adresse'] != null) {
            String address = data['adresse'] as String;
            titlesAndAddresses.add(address);
          }
        }
      }

      if (mounted) {
        setState(() {
          _titles = titlesAndAddresses;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching titles and addresses: $e');
    }
  }

  int children = 0;
  int rooms = 1;
  int roommin = 1;
  String? userAddress;
  Position? currentPosition;
  List<Hotel> nearbys = [];
  Future<void> _requestPermissionAndGetLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Autorisation requise'),
          content: Text(
              'Veuillez autoriser l\'accès à la position pour afficher les hôtels à proximité.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Autorisation refusée'),
          content: Text(
              'Vous avez définitivement refusé l\'accès à la position. Pour activer l\'accès, veuillez aller dans les paramètres de l\'application.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          currentPosition = position;
          isLoading = false;
        });
      }
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        if (mounted) {
          setState(() {
            userAddress =
                '${placemarks.first.name},${placemarks.first.country}';
          });
        }
      }
      _fetchHotelsFromFirebase();
    } catch (e) {
      print("Erreur lors de la récupération de la position: $e");
    }
  }

  Future<void> _fetchHotelsFromFirebase() async {
    QuerySnapshot hotelSnapshot =
        await FirebaseFirestore.instance.collection('hotels').get();

    if (mounted) {
      setState(() {
        nearbys = hotelSnapshot.docs.map((doc) {
          return Hotel(
            title: doc['title'],
            latitude: (doc['latitude'] as num).toDouble(),
            longitude: (doc['longitude'] as num).toDouble(),
            rating: (doc['rating'] as num).toDouble(),
            reviews: doc['reviews'] as int,
            adresse: doc['adresse'],
            price: doc['price'] as int,
            discount: doc['discount'] as int,
            photo1: doc['photos']['photo1'],
            photo2: doc['photos']['photo2'],
            photo3: doc['photos']['photo3'],
          );
        }).toList();
        if (currentPosition != null) {
          nearbys.sort((hotel1, hotel2) {
            double distance1 = _calculateDistance(currentPosition!.latitude,
                currentPosition!.longitude, hotel1.latitude, hotel1.longitude);
            double distance2 = _calculateDistance(currentPosition!.latitude,
                currentPosition!.longitude, hotel2.latitude, hotel2.longitude);
            return distance1.compareTo(distance2);
          });
        }
        isLoading = false;
      });
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF06B3C4),
          )) // Afficher un indicateur de chargement
        : Scaffold(
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
                          child: CircleAvatar(
                            backgroundImage: _profile != ""
                                ? NetworkImage(_profile!)
                                : NetworkImage(
                                    'https://ui-avatars.com/api/?name=${_userName}&font-size=0.36&color=233467&background=random'),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              "Hi, $_userName",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.grey,
                                ),
                                Center(
                                  child: Text(
                                    userAddress ?? '',
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "let's find the best hotels around the world ",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                                        item.contains(textEditingValue.text
                                            .toLowerCase()));
                                  },
                                  onSelected: (String item) {
                                    print('the $item');
                                    DestinationController.text = item;
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController controller,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return Form(
                                      key:
                                          _formKey, // Ajoutez la clé du Form ici
                                      child: FormField<String>(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter destination';
                                          }
                                          return null;
                                        },
                                        builder:
                                            (FormFieldState<String> state) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter destination',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 16),
                                              // Ajout de la bordure
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: _DestinationController
                                                    ? Colors.grey
                                                    : const Color(0xFF06B3C4),
                                                size: 35,
                                              ),
                                              errorText: state.errorText,
                                            ),
                                            onChanged: (String value) {
                                              state.didChange(value);
                                            },
                                            onSubmitted: (String value) {
                                              onFieldSubmitted();
                                            },
                                          );
                                        },
                                      ),
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
                                          constraints: const BoxConstraints(
                                              maxHeight: 200),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            children:
                                                options.map((String option) {
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTimeRange? dateTimeRange =
                                          await showDateRangePicker(
                                        barrierColor: Color(0xFF06B3C4),
                                        builder: (context, Widget? child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              dialogBackgroundColor:
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                              appBarTheme: Theme.of(context)
                                                  .appBarTheme
                                                  .copyWith(
                                                    iconTheme: IconThemeData(
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                    ),
                                                  ),
                                              colorScheme: Theme.of(context)
                                                  .colorScheme
                                                  .copyWith(
                                                    primary: Color(0xFF06B3C4),
                                                    onPrimary: Theme.of(context)
                                                        .primaryColorLight,
                                                  ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(3000),
                                      );

                                      if (dateTimeRange != null) {
                                        if (dateTimeRange.start ==
                                            dateTimeRange.end) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Erreur"),
                                                content: const Text(
                                                    "La date de début ne peut pas être égale à la date de fin."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("OK"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          setState(() {
                                            startDate = dateTimeRange.start;
                                            endDate = dateTimeRange.end;
                                            isDateSelected = true;
                                          });
                                        }
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
                                              startDate != null &&
                                                      endDate != null
                                                  ? '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                                  : 'Sélectionner une date',
                                              style: TextStyle(
                                                color: dateTextFieldEmpty
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
                                  GestureDetector(
                                    onTap: () {
                                      controller:
                                      '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}';
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color:
                                                              Colors.grey[50],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Décrémenter le nombre de chambres s'il est supérieur à 1

                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .decrementAdults();
                                                                });
                                                              },
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    isGuestEnteredController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                  hintText: context
                                                                      .watch<
                                                                          SelectedProvider>()
                                                                      .adults
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
                                                                },
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.add),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Incrémenter le nombre de chambres
                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .incrementAdults();
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color:
                                                              Colors.grey[50],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Décrémenter le nombre de chambres s'il est supérieur à 1

                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .decrementChildren();
                                                                });
                                                              },
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    isGuestEnteredController,
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
                                                                  hintText: context
                                                                      .watch<
                                                                          SelectedProvider>()
                                                                      .children
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
                                                                    (value) {},
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.add),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Incrémenter le nombre de chambres
                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .incrementChildren();
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
                                                      // Vos autres widgets ici...f
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color:
                                                              Colors.grey[50],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Décrémenter le nombre de chambres s'il est supérieur à 1

                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .decrementRooms();
                                                                });
                                                              },
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    isGuestEnteredController,
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
                                                                  hintText: context
                                                                      .watch<
                                                                          SelectedProvider>()
                                                                      .rooms
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
                                                                    (value) {},
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.add),
                                                              onPressed: () {
                                                                setState(() {
                                                                  // Incrémenter le nombre de chambres
                                                                  context
                                                                      .read<
                                                                          SelectedProvider>()
                                                                      .incrementRooms();
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),

                                                      const SizedBox(
                                                        height: 25,
                                                      )
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
                                              color: const Color(0xFF06B3C4),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              ' Adults: ${context.watch<SelectedProvider>().adults} . Children: ${context.watch<SelectedProvider>().children} . Rooms : ${context.watch<SelectedProvider>().rooms} ',
                                              style: TextStyle(
                                                color: Colors.grey[500],
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
                                      if (_formKey.currentState!.validate()) {
                                        startday = startDate!.day;
                                        startmonth = startDate!.month;
                                        startyear = startDate!.year;

                                        endday = endDate!.day;
                                        endmonth = endDate!.month;
                                        endyear = endDate!.year;
                                        controller:
                                        '${startDate!.day}/${startDate!.month}/${startDate!.year} - ${endDate!.day}/${endDate!.month}/${endDate!.year}';
                                        final selectedProvider =
                                            Provider.of<SelectedProvider>(
                                                context,
                                                listen: false);

                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => SearchScreen(
                                                hotels: hotels,
                                                startday: startday,
                                                startmonth: startmonth,
                                                 startyear : startyear,
                                                endday: endday,
                                                endmonth: endmonth,
                                                endyear : endyear,
                                                rooms: selectedProvider.rooms,
                                                datedebut: startDate,
                                                datefin: endDate,
                                                Children:
                                                    selectedProvider.children,
                                                Adults: selectedProvider.adults,
                                                roommin: (((context.read<SelectedProvider>().adults +
                                                                context
                                                                    .read<
                                                                        SelectedProvider>()
                                                                    .children) ~/
                                                            2) +
                                                        ((context.read<SelectedProvider>().adults +
                                                                context
                                                                    .read<
                                                                        SelectedProvider>()
                                                                    .children) %
                                                            2))
                                                    .toInt(),
                                                Controller:
                                                    DestinationController
                                                        .text)));

                                        print(startDate);
                                        print(endDate);
                                        print(
                                          (((context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .adults +
                                                          context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .children) ~/
                                                      2) +
                                                  ((context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .adults +
                                                          context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .children) %
                                                      2))
                                              .toInt(),
                                        );
                                        print(context
                                            .read<SelectedProvider>()
                                            .adults);
                                        print(context
                                            .read<SelectedProvider>()
                                            .children);
                                      }
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
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Recomended Hotels 🔥',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RecomendedHotel()));
                          },
                          child: Text(
                            'See All ',
                            style: TextStyle(
                                color: Color(0xFF06B3C4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
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
                            final isFavorite = context
                                .watch<SelectedProvider>()
                                .isFavorite(hotels[i]['hotelid']);

                            return InkWell(
                              onTap: () {
                                final selectedProvider =
                                    Provider.of<SelectedProvider>(context,
                                        listen: false);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                          hotels: hotels[i],
                                           endyear : endyear,
                                            startyear : startyear,
                                          startday: startDate!.day,
                                          startmonth: startDate!.month,
                                          endday: endDate!.day,
                                          endmonth:endDate!.month,
                                          rooms: selectedProvider.rooms,
                                          datedebut: startDate,
                                          datefin: endDate,
                                          Children: selectedProvider.children,
                                          Adults: selectedProvider.adults,
                                          roommin: (((context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .adults +
                                                          context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .children) ~/
                                                      2) +
                                                  ((context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .adults +
                                                          context
                                                              .read<
                                                                  SelectedProvider>()
                                                              .children) %
                                                      2))
                                              .toInt(),
                                          Controller: hotels[i]['title'],
                                        )));
                                print('$startDate start');
                                print('$endDate End');
                                print(
                                  (((context.read<SelectedProvider>().adults +
                                                  context
                                                      .read<SelectedProvider>()
                                                      .children) ~/
                                              2) +
                                          ((context
                                                      .read<SelectedProvider>()
                                                      .adults +
                                                  context
                                                      .read<SelectedProvider>()
                                                      .children) %
                                              2))
                                      .toInt(),
                                );
                                print(context.read<SelectedProvider>().adults);
                                print(
                                    context.read<SelectedProvider>().children);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
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
                                            hotels[i]['photo1'],
                                            width: 280,
                                            height: 500,

                                            fit: BoxFit.cover,
                                            // Utilisez directement l'URL de l'image depuis votre modèle
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                              return Icon(Icons
                                                  .error); // Widget à afficher en cas d'erreur de chargement de l'image
                                            },
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
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'MAD ${hotels[i]['price']}/Day',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons
                                                          .favorite_border_outlined,
                                                  size: 30,
                                                  color: isFavorite
                                                      ? Color.fromARGB(
                                                          255, 255, 0, 0)
                                                      : Colors
                                                          .white, // Changement de couleur en fonction de isFavorite
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<SelectedProvider>()
                                                      .toggleFavorite(
                                                          hotels[i]['hotelid']);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '⭐${hotels[i]['rating'].toStringAsFixed(1)} ',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    166,
                                                                    12)),
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
                                                        color:
                                                            Color(0xFF06B3C4),
                                                      ),
                                                      Text(' 2 Bads'),
                                                      Spacer(),
                                                      Text('.'),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.wifi,
                                                        color:
                                                            Color(0xFF06B3C4),
                                                      ),
                                                      Text(' Wifi'),
                                                      Spacer(),
                                                      Text('.'),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.sports_gymnastics,
                                                        color:
                                                            Color(0xFF06B3C4),
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
                    Row(
                      children: [
                        Text(
                          'Nearby Hotels',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HotelListScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See All ',
                            style: TextStyle(
                                color: Color(0xFF06B3C4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 100,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: nearbys.isNotEmpty
                          ? InkWell(
                              // onTap: (){
                              //    Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => DetailsScreen()));
                              // },
                              child: buildHotelCard2(
                                  0), // Afficher la carte pour le seul élément de la liste
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              color: Color(0xFF06B3C4),
                            )), // Afficher un indicateur de chargement si la liste est vide
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget buildHotelCard2(int index) {
    final nearby = nearbys[index];
    return InkWell(
      onTap: () {
        final selectedProvider =
            Provider.of<SelectedProvider>(context, listen: false);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsScreen(
                  dataList: nearby,
                  hotels: nearby,
                  startday: startday,
                  startmonth: startmonth,
                  endday: endday,
                  endmonth: endmonth,
                  rooms: selectedProvider.rooms,
                  datedebut: startDate,
                  datefin: endDate,
                  Children: selectedProvider.children,
                  Adults: selectedProvider.adults,
                  roommin: (((context.read<SelectedProvider>().adults +
                                  context.read<SelectedProvider>().children) ~/
                              2) +
                          ((context.read<SelectedProvider>().adults +
                                  context.read<SelectedProvider>().children) %
                              2))
                      .toInt(),
                )));
      },
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
                  child: Image.network(
                    nearby
                        .photo3, // Utilisez directement l'URL de l'image depuis votre modèle
                    width: 100,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF06B3C4),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Icon(Icons
                          .error); // Widget à afficher en cas d'erreur de chargement de l'image
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${nearby.title}",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "${nearby.adresse}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text('\$${nearby.price} / Night'),
                        SizedBox(
                          width: 15,
                        ),
                        Text('⭐${nearby.rating.toStringAsFixed(1)} '),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '${_calculateDistance(currentPosition!.latitude, currentPosition!.longitude, nearby.latitude, nearby.longitude).toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
