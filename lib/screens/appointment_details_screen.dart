import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String docId;
  final String lawyer;
  final String date;
  final String time;
  final String type;
  final String venue;
  final String status;
  final String purpose;

  const AppointmentDetailsScreen({
    super.key,
    required this.docId,
    required this.lawyer,
    required this.date,
    required this.time,
    required this.type,
    required this.venue,
    required this.status,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryMaroon = AppColors.primaryColor;

    Color getStatusColor(String status) {
      switch (status) {
        case 'Upcoming':
          return const Color(0xFF4CAF50);
        case 'Completed':
          return const Color(0xFF1976D2);
        case 'Cancelled':
          return const Color(0xFFF44336);
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Appointment Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Lawyer Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lawyer',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          lawyer,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: getStatusColor(status).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: getStatusColor(status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Details List
            _buildDetailRow(Icons.calendar_today, 'Date', date),
            _buildDetailRow(Icons.access_time, 'Time', time),
            _buildDetailRow(Icons.videocam, 'Type', type),
            _buildDetailRow(Icons.location_on, 'Venue / Platform',
                venue.isEmpty ? 'N/A' : venue),

            const SizedBox(height: 25),

            // Purpose / Description
            const Text(
              'Purpose / Case Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                purpose.isEmpty ? 'No additional details provided.' : purpose,
                style: const TextStyle(
                    fontSize: 15, color: Colors.black87, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 22),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
