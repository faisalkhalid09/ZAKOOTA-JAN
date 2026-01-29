// Path: screens/client_home_screen.dart (Settings Icon Linking Fix)

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

import 'my_cases_screen.dart';
import 'my_appointments_screen.dart';
import 'document_screen.dart';
import 'messages_screen.dart';
import 'notifications_screen.dart';
import 'payment_screen.dart';
import '../widgets/app_nav_bar.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);

  Widget _buildDashboardTile(
    BuildContext context,
    String title,
    IconData icon,
    Widget targetScreen,
    String subtitle,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200), // Subtle border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03), // Very subtle black shadow
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.maroonVeryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: primaryMaroon, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black), // Black text
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600), // Grey subtitle
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(context),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explore Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Strict Black
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5, // Adjusted for new tile design
                          children: [
                            _buildDashboardTile(
                              context,
                              'My Cases',
                              Icons.balance,
                              const MyCasesScreen(),
                              'View case details',
                            ),
                            _buildDashboardTile(
                              context,
                              'Appointments',
                              Icons.calendar_month,
                              const MyAppointmentsScreen(),
                              'Check upcoming hearings',
                            ),
                            _buildDashboardTile(
                              context,
                              'Messages',
                              Icons.chat_bubble_outline,
                              const MessagesScreen(),
                              'Chat with lawyer',
                            ),
                            _buildDashboardTile(
                              context,
                              'Documents',
                              Icons.description_outlined,
                              const DocumentsScreen(),
                              'Upload or view files',
                            ),
                            _buildDashboardTile(
                              context,
                              'Notifications',
                              Icons.notifications_outlined,
                              const NotificationsScreen(),
                              'Case updates',
                            ),
                            _buildDashboardTile(
                              context,
                              'Payments',
                              Icons.receipt_long,
                              const PaymentsScreen(),
                              'Invoices & receipts',
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Upcoming Appointment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildUpcomingAppointmentCard(
                          context,
                          lawyerName: 'Lawyer Name',
                          time: 'Tomorrow, 10:00 AM',
                          count: 3,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Recent Messages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRecentMessageCard(
                          lawyerName: 'Lawyer Name',
                          message: 'Thanks for providing the documents.',
                          time: 'Yesterday',
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Recent Documents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDocumentCard(
                          fileName: 'Evidence.pdf',
                          date: 'April 20',
                          color: primaryMaroon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔑 Custom Maroon Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.maroonPrimary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo Section
          Row(
            children: [
              Icon(Icons.gavel, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Text(
                'ZAKOOTA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          // Action Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderIcon(Icons.notifications_none, () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
              }),
              const SizedBox(width: 8),
              _buildHeaderIcon(Icons.chat_bubble_outline, () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesScreen()));
              }),
              const SizedBox(width: 12),
              // Profile Avatar
              InkWell(
                onTap: () {
                    // Open Profile
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.maroonLight,
                    child: const Text("JD", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // 🔑 Search Section
  Widget _buildSearchSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find the best lawyer to help you',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search lawyer, service...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Icon(Icons.tune, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(
    BuildContext context, {
    required String lawyerName,
    required String time,
    required int count,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lawyerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryMaroon,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyAppointmentsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMessageCard({
    required String lawyerName,
    required String message,
    required String time,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline, color: primaryMaroon, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lawyerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String fileName,
    required String date,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: color, size: 24),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  'Upload Document',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
