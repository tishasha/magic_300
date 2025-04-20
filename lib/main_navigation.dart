import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'saving_lost_island.dart';
import 'progress_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final String superheroName;
  final Uint8List? drawingData;

  const MainNavigation({
    super.key,
    required this.superheroName,
    this.drawingData,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const SavingLostIsland(),
      const ProgressPage(),
      ProfilePage(
        superheroName: widget.superheroName,
        drawingData: widget.drawingData,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 40),
            label: '拯救失落之島',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 40),
            label: '進度頁面',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40),
            label: '個人資料頁面',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.blue,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Rounded Mplus 1c',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Rounded Mplus 1c',
          fontSize: 14,
        ),
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
