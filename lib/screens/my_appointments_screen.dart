// Path: screens/my_appointments_screen.dart (FINAL Stateful, Filtered & Updated UI)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import 'add_appointment_screen.dart';
import 'appointment_details_screen.dart';

// 🔑 Data Structure
class Appointment {
  final String docId; // Firestore Document ID
  final String id;
  final String lawyer;
  final String date;
  final String time;
  final String type; // 'Virtual' or 'In-Person'
  final String venue;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final String purpose; // Case details/reason
  final Timestamp? timestamp; // For client-side sorting

  Appointment({
    required this.docId,
    required this.id,
    required this.lawyer,
    required this.date,
    required this.time,
    required this.type,
    required this.venue,
    required this.status,
    required this.purpose,
    this.timestamp,
  });
}

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  String _selectedStatus = 'Upcoming'; // Default selected tab
  String _searchQuery = '';

  // 🔑 Status Color Getter
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return const Color(0xFF4CAF50); // Green shade
      case 'Completed':
        return const Color(0xFF1976D2); // Blue shade
      case 'Cancelled':
        return const Color(0xFFF44336); // Red shade
      default:
        return Colors.grey;
    }
  }

  // 🔑 Update Appointment Status
  Future<void> _updateAppointmentStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(docId)
          .update({'status': newStatus});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment marked as $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    }
  }

  // 🔑 Appointment Card Widget (Updated UI)
  Widget _buildAppointmentCard(Appointment appointment) {
    final statusColor = _getStatusColor(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Lawyer Name
                          Text(
                            appointment.lawyer,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          // Status Actions (Menu) & Badge
                          Row(
                            children: [
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  appointment.status,
                                  style: TextStyle(
                                      color: statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // 3-Dot Menu
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.grey),
                                onSelected: (String newStatus) {
                                  _updateAppointmentStatus(
                                      appointment.docId, newStatus);
                                },
                                itemBuilder: (BuildContext context) {
                                  return {'Upcoming', 'Completed', 'Cancelled'}
                                      .where((status) =>
                                          status != appointment.status)
                                      .map((String status) {
                                    return PopupMenuItem<String>(
                                      value: status,
                                      child: Text('Mark as $status'),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Date and Time
                      Text(
                        '${appointment.date} - ${appointment.time}',
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      // Appointment Type & Venue
                      Text(
                        '${appointment.type} (${appointment.venue})',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // View Details Button (Full width)
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetailsScreen(
                        docId: appointment.docId,
                        lawyer: appointment.lawyer,
                        date: appointment.date,
                        time: appointment.time,
                        type: appointment.type,
                        venue: appointment.venue,
                        status: appointment.status,
                        purpose: appointment.purpose,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon, // Maroon background
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔑 Status Tab Widget (Interactive)
  Widget _buildStatusTab(String label) {
    final isSelected = _selectedStatus == label;
    final color = isSelected ? primaryMaroon : Colors.grey.shade500;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          // Selected tab mein solid color, unselected mein white background
          color: isSelected ? primaryMaroon : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryMaroon : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by lawyer or date',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),

          // 2. Status Tabs (Upcoming, Completed, Cancelled)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusTab('Upcoming'),
                _buildStatusTab('Completed'),
                _buildStatusTab('Cancelled'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 3. Filtered Appointment List (StreamBuilder)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  // Removed orderBy to avoid missing index issues. Sorting client-side.
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: primaryMaroon));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No appointments found.'));
                }

                var appointments = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Appointment(
                    docId: doc.id,
                    id: doc.id,
                    lawyer: data['lawyerName'] ?? 'Unknown',
                    date: data['date'] ?? '',
                    time: data['time'] ?? '',
                    type: data['type'] ?? 'Virtual',
                    venue: data['venue'] ?? '',
                    status: data['status'] ?? 'Upcoming',
                    purpose: data['purpose'] ?? '',
                    timestamp: data['timestamp'] as Timestamp?,
                  );
                }).where((appointment) {
                  final matchesStatus = appointment.status == _selectedStatus;
                  final matchesQuery = appointment.lawyer
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      appointment.date.contains(_searchQuery);
                  return matchesStatus && matchesQuery;
                }).toList();

                // Sort client-side by timestamp descending
                appointments.sort((a, b) {
                  if (b.timestamp == null || a.timestamp == null) return 0;
                  return b.timestamp!.compareTo(a.timestamp!);
                });

                if (appointments.isEmpty) {
                  return const Center(
                      child: Text('No appointments match your filter.'));
                }

                return ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: appointments.map((appointment) {
                    return _buildAppointmentCard(appointment);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),

      // 4. Floating Action Button (Add Appointment)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddAppointmentScreen()),
          );
        },
        backgroundColor: primaryMaroon,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // 5. Bottom Navigation Bar
      bottomNavigationBar: AppNavBar(
        currentIndex: 2, // Calendar Icon
        context: context,
      ),
    );
  }
}
