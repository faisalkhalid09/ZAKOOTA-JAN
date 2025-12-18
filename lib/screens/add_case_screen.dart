// Path: screens/add_case_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add simple date formatting if needed, or just use toString
import '../utils/app_colors.dart';

class AddCaseScreen extends StatefulWidget {
  const AddCaseScreen({super.key});

  @override
  State<AddCaseScreen> createState() => _AddCaseScreenState();
}

class _AddCaseScreenState extends State<AddCaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryMaroon = AppColors.primaryColor;

  // Controllers
  final TextEditingController _caseTypeController = TextEditingController();
  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lawyerNameController = TextEditingController(); // Or "Lawyer Required"
  final TextEditingController _courtNameController = TextEditingController();
  final TextEditingController _hearingDateController = TextEditingController();

  List<PlatformFile> _selectedFiles = [];
  bool _isLoading = false;
  DateTime? _selectedDate;

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryMaroon,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _hearingDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveCase() async {
    if (!_formKey.currentState!.validate()) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      List<String> documentUrls = [];

      // 1. Upload Files
      for (var file in _selectedFiles) {
        if (file.path != null) {
          final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
          final ref = FirebaseStorage.instance.ref().child('case_documents/${user.uid}/$fileName');
          await ref.putFile(File(file.path!));
          final url = await ref.getDownloadURL();
          documentUrls.add(url);
        }
      }

      // 2. Save to Firestore
      await FirebaseFirestore.instance.collection('cases').add({
        'uid': user.uid,
        'caseNumber': _caseNoController.text.trim(),
        'caseType': _caseTypeController.text.trim(),
        'description': _descriptionController.text.trim(),
        'lawyer': _lawyerNameController.text.trim(),
        'court': _courtNameController.text.trim(),
        'hearingDate': _hearingDateController.text.trim(),
        'status': 'Ongoing',
        'documentUrls': documentUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Case Added Successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving case: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    bool isReadOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: isReadOnly,
          onTap: onTap,
          validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: primaryMaroon) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Case', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(label: 'Case Type', controller: _caseTypeController, hint: 'e.g., Property Dispute'),
              _buildTextField(label: 'Case Number', controller: _caseNoController, hint: 'e.g., 1234/2025'),
              _buildTextField(label: 'Description', controller: _descriptionController, maxLines: 3, hint: 'Enter case details...'),
              _buildTextField(label: 'Lawyer Name (Optional)', controller: _lawyerNameController, hint: 'Enter name or "Require Lawyer"'),
              _buildTextField(label: 'Court Name / Address', controller: _courtNameController, hint: 'e.g., High Court Lahore'),
              
              _buildTextField(
                label: 'Hearing Date / Timeline',
                controller: _hearingDateController,
                hint: 'Select Date',
                isReadOnly: true,
                onTap: _pickDate,
                suffixIcon: Icons.calendar_today,
              ),

              const Text('Attach Documents', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (_selectedFiles.isNotEmpty)
                      ..._selectedFiles.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(child: Text(f.name, overflow: TextOverflow.ellipsis)),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20, color: Colors.red),
                              onPressed: () => setState(() => _selectedFiles.remove(f)),
                            )
                          ],
                        ),
                      )),
                    
                    TextButton.icon(
                      onPressed: _pickFiles,
                      icon: Icon(Icons.upload_file, color: primaryMaroon),
                      label: Text('Upload Documents', style: TextStyle(color: primaryMaroon)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryMaroon,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Save Case', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
