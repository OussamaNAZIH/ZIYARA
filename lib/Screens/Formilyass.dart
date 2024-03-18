import 'package:flutter/material.dart';

class Formet extends StatefulWidget {
  const Formet({super.key});

  @override
  State<Formet> createState() => _FormeState();
}

class _FormeState extends State<Formet> {
  final bool _obscureText = true;

  final _dateController = TextEditingController();
  final _guestController = TextEditingController();
  final _roomTypeController =
      TextEditingController(); // Controller pour le champ "Room Type"
  final _phoneNumberController =
      TextEditingController(); // Controller pour le champ "Number Phone"

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

  String? selectedRoomType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Forme Detail',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text('Paramètres du compte'),
                ),
                const PopupMenuItem(
                  child: Text('Déconnexion'),
                ),
              ];
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Date',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTimeRange? dateTimeRange =
                        await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));
                    if (dateTimeRange != null) {
                      setState(() {
                        selectedDates = dateTimeRange;
                        isDateSelected = true;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 247, 247, 247),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.calendar_today,
                            color: isDateSelected
                                ? Colors.blue
                                : dateTextFieldEmpty
                                    ? Colors.grey[400]
                                    : const Color(0xFF06B3C4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Center(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: guestTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Guest',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Guest Selection',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.grey[400],
                                        ),
                                        hintText: 'Select the number of adults',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Children',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.child_care,
                                          color: Colors.grey[400],
                                        ),
                                        hintText:
                                            'Select the number of children',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Rooms',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.hotel,
                                          color: Colors.grey[400],
                                        ),
                                        hintText: 'Select the number of rooms',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Action à effectuer lors de la validation du formulaire
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: const Color(0xFF06B3C4),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 247, 247, 247),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.person,
                            color: isGuestEntered
                                ? Colors.blue
                                : guestTextFieldEmpty
                                    ? Colors.grey[400]
                                    : const Color(0xFF06B3C4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Guest Details',
                              style: TextStyle(
                                color: guestTextFieldEmpty
                                    ? Colors.grey[500]
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: guestTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Room Type',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    // Ouvrir la boîte de dialogue pour sélectionner le type de chambre
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Center(
                                  child: Text(
                                    'Select Room Type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                customListTile(
                                  title: 'King Room',
                                  icon: Icons.king_bed,
                                  selected: selectedRoomType == 'King Room',
                                  onTap: () {
                                    setState(() {
                                      selectedRoomType = 'King Room';
                                    });
                                  },
                                ),
                                customListTile(
                                  title: 'Queen Room',
                                  icon: Icons.weekend,
                                  selected: selectedRoomType == 'Queen Room',
                                  onTap: () {
                                    setState(() {
                                      selectedRoomType = 'Queen Room';
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Action à effectuer lors de la validation du formulaire
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: const Color(0xFF06B3C4),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 247, 247, 247),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.hotel,
                            color: roomTypeTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                // Action à effectuer lors du clic sur le bouton
                              },
                              child: Text(
                                selectedRoomType ?? 'Select room type',
                                style: TextStyle(
                                  color: guestTextFieldEmpty
                                      ? Colors.grey[500]
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: guestTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Number Phone',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 247, 247, 247),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.phone,
                          color: phoneNumberTextFieldEmpty
                              ? Colors.grey[400]
                              : const Color(0xFF06B3C4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.center, // Centrer le texte
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter phone number',
                              hintStyle: TextStyle(
                                color: guestTextFieldEmpty
                                    ? Colors.grey[500]
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: const Color(0xFF06B3C4),
                      ),
                      child: const Center(
                        child: Text('Change Now',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customListTile({
  required String title,
  required IconData icon,
  required bool selected,
  required VoidCallback onTap,
}) {
  return ListTile(
    title: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10), // Espacement entre l'icône et le texte
        Text(title),
      ],
    ),
    trailing: Checkbox(
      value: selected,
      onChanged: (value) {
        onTap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Bordures carrées
      ),
    ),
    onTap: onTap,
  );
}
