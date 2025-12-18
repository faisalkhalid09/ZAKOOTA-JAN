// Path: widgets/app_nav_bar.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../screens/client_home_screen.dart'; // Index 0
import '../screens/my_cases_screen.dart'; // Index 1 (Assuming Search is My Cases)
import '../screens/my_appointments_screen.dart'; // Index 2
import '../screens/messages_screen.dart'; // Index 3 (Assuming Contact is Messages)
import '../screens/payment_screen.dart'; // Index 4 (Assuming Menu/More is Payments/Menu)


class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.context,
  });

  // Pages ki list jo navigation par khulengi
  // NOTE: Humne icons ke order ke mutabiq screens ko assign kiya hai:
  // 0: Home, 1: Search, 2: Calendar, 3: Contact, 4: More/Menu
  void _onItemTapped(int index) {
    if (index == currentIndex) return;

    Widget targetScreen;

    switch (index) {
      case 0:
        targetScreen = const ClientHomeScreen(); // Home Icon
        break;
      case 1:
        // Search Icon (Assuming yeh Cases screen hai, jismein search hota hai)
        targetScreen = const MyCasesScreen();
        break;
      case 2:
        targetScreen = const MyAppointmentsScreen(); // Calendar Icon
        break;
      case 3:
        // Contact Icon (Assuming yeh Messages ya Contacts screen hai)
        targetScreen = const MessagesScreen();
        break;
      case 4:
        // Menu Icon (Assuming yeh Payments ya More screen hai)
        targetScreen = const PaymentsScreen();
        break;
      default:
        targetScreen = const ClientHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryMaroon = AppColors.primaryColor;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, // Background color change nahi hoga
      backgroundColor: primaryMaroon, // Maroon background
      selectedItemColor: Colors.white, // Selected icon White
      unselectedItemColor: Colors.white70, // Unselected icon thoda halka
      
      // ✅ Zaroori FIX: Labels (text) ko empty string ("") set kiya gaya hai.
      selectedLabelStyle: const TextStyle(fontSize: 0),
      unselectedLabelStyle: const TextStyle(fontSize: 0),
      
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 28), // Home Icon
          label: '', // Label removed
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 28), // Search Icon
          label: '', // Label removed
        ),
        BottomNavigationBarItem(
          // Calendar icon with tick mark
          icon: Icon(Icons.calendar_month, size: 28), 
          label: '', // Label removed
        ),
        BottomNavigationBarItem(
          // Contact icon (man in a book/list)
          icon: Icon(Icons.recent_actors_outlined, size: 28), 
          label: '', // Label removed
        ),
        BottomNavigationBarItem(
          // Menu/More icon
          icon: Icon(Icons.menu, size: 28), 
          label: '', // Label removed
        ),
      ],
    );
  }
}

// NOTE: Please ensure that AppColors.primaryColor is correctly set 
// in utils/app_colors.dart to the dark maroon color (0xFF800000).