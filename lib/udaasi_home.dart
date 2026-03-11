import 'package:flutter/material.dart';
import 'udaasi_viewfinder.dart';
import 'dart:ui';
import 'discover_page.dart';

class UdaasiHome extends StatefulWidget {
  const UdaasiHome({super.key});

  @override
  State<UdaasiHome> createState() => _UdaasiHomeState();
}

class _UdaasiHomeState extends State<UdaasiHome> {
  int _selectedIndex = 1; // Start on the Camera (middle tab)

  // Temporary placeholders for the other tabs
  final List<Widget> _pages = [
    DiscoverPage(),
    const UdaasiViewfinder(), // Our existing camera code
    const Scaffold(body: Center(child: Text("Your Journal", style: TextStyle(color: Colors.white)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This allows the camera to show behind the navigation bar
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.black.withOpacity(0.4), 
            selectedItemColor: Colors.orangeAccent,
            unselectedItemColor: Colors.white30,
            elevation: 0, 
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // --- ADD THESE TWO LINES ---
            selectedFontSize: 0,   // Forces the label space to disappear
            unselectedFontSize: 0, // Forces the label space to disappear
            // ---------------------------
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: ""), // Empty label
              BottomNavigationBarItem(icon: Icon(Icons.camera_alt_rounded), label: ""), 
              BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: ""),
            ],
          ),
        ),
      ),
    );
  }
}