import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/AccountScreen.dart';
import 'package:flutter_pfe/Screens/FavoriteScreen.dart';
import 'package:flutter_pfe/Screens/Home.dart';
import 'package:flutter_pfe/Screens/MyBookingScreen.dart';
import 'package:flutter_pfe/Setting/setting.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  final List<Widget> _screens = [
    const Home(),

    
    MyBookingScreen(
      dataList: null,
      startday: null,
      startmonth: null,
      endday: null,
      endmonth: null,
    ),
    const FavoriteScreen(),
    // AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: Colors.grey,
          selectedItemColor: const Color(0xFF06B3C4),
          onTap: _selectScreen,
          currentIndex: _selectedScreenIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_added), label: 'My Booking'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.settings), label: 'Setting'),
          ]),
    );
  }
}
