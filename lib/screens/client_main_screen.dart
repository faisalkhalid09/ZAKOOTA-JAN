import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import 'client_home_screen.dart';
import 'my_cases_screen.dart';
import 'my_appointments_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key});

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends State<ClientMainScreen> {
  int _currentIndex = 0;

  // Keep instances to preserve state
  final List<Widget> _screens = const [
    ClientHomeScreen(),
    MyCasesScreen(),
    MyAppointmentsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        // From any other tab, go back to home tab (index 0)
        setState(() {
          _currentIndex = 0;
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.gray200,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray400.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                  _buildNavItem(
                      1, Icons.balance_outlined, Icons.balance, 'Cases'),
                  _buildNavItem(2, Icons.calendar_today_outlined,
                      Icons.calendar_today, 'Schedule'),
                  _buildNavItem(3, Icons.chat_bubble_outline, Icons.chat_bubble,
                      'Messages'),
                  _buildNavItem(
                      4, Icons.person_outline, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_currentIndex != index) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          splashColor: AppColors.maroonPrimary.withOpacity(0.1),
          highlightColor: AppColors.maroonPrimary.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with animated transition
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSelected ? 6 : 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.maroonPrimary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    color: isSelected
                        ? AppColors.maroonPrimary
                        : AppColors.gray600,
                    size: isSelected ? 24 : 22,
                  ),
                ),
                const SizedBox(height: 3),
                // Label with size constraint
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.0,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.maroonPrimary
                        : AppColors.gray600,
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
