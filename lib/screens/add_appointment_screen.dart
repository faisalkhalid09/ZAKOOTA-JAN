import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String? _selectedLawyerId;
  String? _selectedLawyerName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _appointmentType = 'Virtual'; // 'Virtual', 'In-Person'
  final TextEditingController _venueController =
      TextEditingController(text: 'Zoom');
  final TextEditingController _purposeController = TextEditingController();

  // Lawyer Data
  List<Map<String, dynamic>> _lawyers = [];
  bool _isLoadingLawyers = true;

  @override
  void initState() {
    super.initState();
    _fetchLawyers();
  }

  // Fetch Lawyers from Firestore
  Future<void> _fetchLawyers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'lawyer')
          .get();

      setState(() {
        _lawyers = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown Lawyer',
          };
        }).toList();
        _isLoadingLawyers = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLawyers = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching lawyers: $e')),
        );
      }
    }
  }

  // Date Picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryMaroon),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Time Picker
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryMaroon),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Save Appointment
  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedLawyerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a lawyer')),
        );
        return;
      }
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      try {
        final formattedDate = DateFormat('MMM dd, yyyy').format(_selectedDate!);
        final formattedTime = _selectedTime!.format(context);

        await FirebaseFirestore.instance.collection('appointments').add({
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'lawyerId': _selectedLawyerId,
          'lawyerName': _selectedLawyerName,
          'date': formattedDate,
          'time': formattedTime,
          'type': _appointmentType,
          'venue': _venueController.text,
          'status': 'Upcoming',
          'purpose': _purposeController.text,
          'timestamp': FieldValue.serverTimestamp(), // For sorting
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment booked successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error booking appointment: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment',
            style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoadingLawyers
          ? Center(child: CircularProgressIndicator(color: primaryMaroon))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lawyer Selection
                    const Text('Select Lawyer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                      ),
                      hint: const Text('Choose a lawyer'),
                      initialValue: _selectedLawyerId,
                      items: _lawyers.map((lawyer) {
                        return DropdownMenuItem<String>(
                          value: lawyer['id'],
                          child: Text(lawyer['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLawyerId = value;
                          _selectedLawyerName = _lawyers
                              .firstWhere((l) => l['id'] == value)['name'];
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a lawyer' : null,
                    ),
                    const SizedBox(height: 20),

                    // Date & Time
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _pickDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedDate == null
                                            ? 'Select Date'
                                            : DateFormat('MMM dd, yyyy')
                                                .format(_selectedDate!),
                                        style: TextStyle(
                                            color: _selectedDate == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          color: Colors.grey, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _pickTime,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedTime == null
                                            ? 'Select Time'
                                            : _selectedTime!.format(context),
                                        style: TextStyle(
                                            color: _selectedTime == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      const Icon(Icons.access_time,
                                          color: Colors.grey, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Appointment Type
                    const Text('Appointment Type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Virtual'),
                            value: 'Virtual',
                            groupValue: _appointmentType,
                            activeColor: primaryMaroon,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() {
                                _appointmentType = value!;
                                _venueController.text = 'Zoom';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('In-Person'),
                            value: 'In-Person',
                            groupValue: _appointmentType,
                            activeColor: primaryMaroon,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() {
                                _appointmentType = value!;
                                _venueController.text = ''; // Clear default
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Venue / Virtual Link
                    const Text('Venue / Platform',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _venueController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: _appointmentType == 'Virtual'
                            ? 'e.g., Zoom, Google Meet'
                            : 'e.g., Office Address',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter venue/platform'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Purpose
                    const Text('Case Details / Purpose',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _purposeController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText:
                            'Briefly describe your case or reason for appointment',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter purpose'
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryMaroon,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Confirm Appointment',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
