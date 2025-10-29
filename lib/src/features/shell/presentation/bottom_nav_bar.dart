import 'package:flutter/material.dart';

// Define Gold color for the theme
const Color _goldColor = Color(0xFFFFD700);
const Color _blackColor = Colors.black;


class GoldBlackBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GoldBlackBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _blackColor, // Bottom nav background is Black
        border: Border(
          top: BorderSide(color: _goldColor, width: 0.5), // Subtle gold separator
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45, // Soft black shadow
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            activeIcon: Icon(Icons.qr_code_2),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        
        // --- Black and Gold Styling ---
        type: BottomNavigationBarType.fixed, // Essential for showing all items on black background
        backgroundColor: _blackColor,
        selectedItemColor: _goldColor, // Gold for the selected item
        unselectedItemColor: Colors.grey[700], // Dark grey for unselected items
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 0, // No shadow needed since the container has one
      ),
    );
  }
}
