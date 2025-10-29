import 'package:flutter/material.dart';

import 'package:vms_resident_app/src/features/home/screens/home_screen.dart';
import 'package:vms_resident_app/src/features/visitor_codes/screens/generate_code_screen.dart';
import 'package:vms_resident_app/src/features/auth/presentation/pages/profile_screen.dart';
import 'package:vms_resident_app/src/features/visitor_codes/screens/history_screen.dart';
// Note: Changed import path to use the newly defined component
import 'package:vms_resident_app/src/features/shell/presentation/bottom_nav_bar.dart'; // Assuming this file now contains GoldBlackBottomNavBar

class ShellScreen extends StatefulWidget {
static const routeName = '/shell';
const ShellScreen({super.key});
@override
State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
int _selectedIndex = 0;
static const List<Widget> _widgetOptions = <Widget>[
  HomeScreen(),
  GenerateCodeScreen(),
  VisitHistoryScreen(),
  ProfileScreen(),
];

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    // Set scaffold background to black for a consistent theme
    backgroundColor: Colors.black, 
    body: Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    ),
    
    // 💡 Use the new custom bottom navigation bar for the theme
    bottomNavigationBar: GoldBlackBottomNavBar( // Renamed the custom widget for clarity
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    ),
  );
}
}
