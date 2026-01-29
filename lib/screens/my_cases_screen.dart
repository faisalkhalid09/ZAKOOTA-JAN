// Path: screens/my_cases_screen.dart (FINAL UI & Logic Adjustment)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import 'case_details_screen.dart'; // Assuming this screen exists
import 'add_case_screen.dart';

class MyCasesScreen extends StatefulWidget {
  const MyCasesScreen({super.key});

  @override
  State<MyCasesScreen> createState() => _MyCasesScreenState();
}

class Case {
  final String docId; // Firestore Document ID
  final String id; // Case Number (Display ID)
  final String type;
  final String lawyer;
  final String court;
  final String date;
  final String status; // 'Ongoing', 'Pending', 'Closed'
  final String description; // Case Description

  Case({
    required this.docId,
    required this.id,
    required this.type,
    required this.lawyer,
    required this.court,
    required this.date,
    required this.status,
    required this.description,
  });
}

class _MyCasesScreenState extends State<MyCasesScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  String _selectedStatus = 'Ongoing'; // Default selected tab
  String _searchQuery = '';

  // 🔑 Status Color Getter
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ongoing':
        return const Color(0xFF4CAF50); // Green shade
      case 'Closed':
        return const Color(0xFFF44336); // Red shade
      case 'Pending':
        return const Color(0xFFFFC107); // Yellow shade
      default:
        return Colors.grey;
    }
  }

  // 🔑 Update Case Status in Firestore
  Future<void> _updateCaseStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('cases')
          .doc(docId)
          .update({'status': newStatus});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Case moved to $newStatus')),
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

  // 🔑 Case Card Widget (Updated UI)
  Widget _buildCaseCard(BuildContext context, Case caseItem) {
    final statusColor = _getStatusColor(caseItem.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Case Type (e.g., Property Dispute - Case #1428)
                Flexible(
                  child: Text(
                    caseItem.type.split(' - ')[0], // Only show case type
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                // Status Actions (Menu) & Badge
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            statusColor.withOpacity(0.15), // Light background
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        caseItem.status,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    // 3-Dot Menu for Status Change
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (String newStatus) {
                        _updateCaseStatus(caseItem.docId, newStatus);
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Ongoing', 'Pending', 'Closed'}
                            .where((status) => status != caseItem.status)
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
            const SizedBox(height: 5),

            // Case ID
            Text('Case #${caseItem.id}',
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 10),

            // Details
            Text('Lawyer: ${caseItem.lawyer}',
                style: const TextStyle(color: Colors.black87, fontSize: 14)),

            // Next Hearing Detail
            Text('Next Hearing: ${caseItem.date}',
                style: const TextStyle(color: Colors.black87, fontSize: 14)),

            // Updated Days Ago detail (hardcoded for UI matching)
            const Text(
              'Updated 2 days ago',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 15),

            // View Details Button (Maroon, Full Width-like)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Case Details Screen with all data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailsScreen(
                          docId: caseItem.docId,
                          caseNumber: caseItem.id,
                          type: caseItem.type,
                          lawyer: caseItem.lawyer,
                          court: caseItem.court,
                          date: caseItem.date,
                          status: caseItem.status,
                          description: caseItem.description,
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
            ),
          ],
        ),
      ),
    );
  }

  // 🔑 Status Tab Widget (User Interaction ke liye)
  Widget _buildStatusTab(String label) {
    final isSelected = _selectedStatus == label;
    final color = isSelected ? primaryMaroon : Colors.grey.shade500;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = label;
          // Search query ko clear nahi kar rahe taaki filtering search aur tab dono par kaam kare
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
        title: const Text('My Cases', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 🆕 Floating Action Button to Add Case
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_cases_fab',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCaseScreen()));
        },
        backgroundColor: primaryMaroon,
        child: const Icon(Icons.add, color: Colors.white),
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
                      blurRadius: 3,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search by Case ID or Name',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),

          // 2. Status Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatusTab('Ongoing'),
                _buildStatusTab('Pending'),
                _buildStatusTab('Closed'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 3. Real-time Case List from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cases')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: primaryMaroon));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No cases found. Add a new case!'));
                }

                // Convert Docs to Case Objects
                final cases = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Case(
                    docId: doc.id, // Capture Firestore Doc ID
                    id: data['caseNumber'] ?? 'Unknown',
                    type: data['caseType'] ?? 'General',
                    lawyer: data['lawyer'] ?? 'None',
                    court: data['court'] ?? 'Unknown',
                    date: data['hearingDate'] ?? 'No Date',
                    status: data['status'] ?? 'Ongoing',
                    description: data['description'] ?? '', // Added Description
                  );
                }).where((caseItem) {
                  // Apply Filters
                  final matchesStatus = caseItem.status == _selectedStatus;
                  final matchesQuery = caseItem.type
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      caseItem.id
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  return matchesStatus && matchesQuery;
                }).toList();

                if (cases.isEmpty) {
                  return const Center(child: Text('No matching cases found.'));
                }

                return ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: cases
                      .map((caseItem) => _buildCaseCard(context, caseItem))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
