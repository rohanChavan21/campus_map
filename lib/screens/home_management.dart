import 'package:flutter/material.dart';
import '/screens/campus_map.dart';
import '/screens/places_list.dart';

class HomeManagement extends StatefulWidget {
  const HomeManagement({Key? key}) : super(key: key);

  @override
  State<HomeManagement> createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  final List<Widget> _pages = [
    const CampusMap(),
    const PlacesList(),
  ];
  int _index = 0;
  void _setPage(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _setPage,
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Campus'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop_outlined), label: 'Places'),
        ],
      ),
    );
  }
}
