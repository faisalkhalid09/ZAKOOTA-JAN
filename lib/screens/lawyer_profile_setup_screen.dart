import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_colors.dart';
import 'lawyer_main_screen.dart';

class LawyerProfileSetupScreen extends StatefulWidget {
  final String userId;

  const LawyerProfileSetupScreen({super.key, required this.userId});

  @override
  State<LawyerProfileSetupScreen> createState() =>
      _LawyerProfileSetupScreenState();
}

class _LawyerProfileSetupScreenState extends State<LawyerProfileSetupScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  final PageController _pageController = PageController();

  int _currentStep = 0;
  final int _totalSteps = 4;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  // Dropdown value
  String? selectedBarCouncil;

  // Image files
  XFile? licenseFrontImage;
  XFile? licenseBackImage;
  XFile? selfieWithLicenseImage;

  bool _isLoading = false;

  // Bar Council options (STRICT ENUM)
  final List<String> barCouncils = [
    'Pakistan Bar Council',
    'Punjab Bar Council',
    'Sindh Bar Council',
    'Khyber Pakhtunkhwa Bar Council',
    'Balochistan Bar Council',
    'Islamabad Bar Council',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    fullNameController.dispose();
    cnicController.dispose();
    licenseNumberController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String imageType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (imageType == 'front') {
          licenseFrontImage = image;
        } else if (imageType == 'back') {
          licenseBackImage = image;
        } else if (imageType == 'selfie') {
          selfieWithLicenseImage = image;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image selected successfully!')),
      );
    }
  }

  Future<String?> _uploadImageToStorage(
      XFile imageFile, String fileName) async {
    try {
      final File file = File(imageFile.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('zakoota/lawyers/${widget.userId}/$fileName');

      await storageRef.putFile(file);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitProfile() async {
    // Validation
    if (fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    if (cnicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your CNIC number')),
      );
      return;
    }

    if (selectedBarCouncil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Bar Council')),
      );
      return;
    }

    if (licenseNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your license number')),
      );
      return;
    }

    if (licenseFrontImage == null || licenseBackImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload front and back of license card')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload images to Firebase Storage
      String? frontURL;
      String? backURL;
      String? selfieURL;

      if (licenseFrontImage != null) {
        frontURL = await _uploadImageToStorage(
            licenseFrontImage!, 'license_front.jpg');
      }

      if (licenseBackImage != null) {
        backURL =
            await _uploadImageToStorage(licenseBackImage!, 'license_back.jpg');
      }

      if (selfieWithLicenseImage != null) {
        selfieURL =
            await _uploadImageToStorage(selfieWithLicenseImage!, 'selfie.jpg');
      }

      // Parse years of experience
      int yearsOfExperience = 0;
      if (experienceController.text.trim().isNotEmpty) {
        yearsOfExperience = int.tryParse(experienceController.text.trim()) ?? 0;
      }

      // Update lawyerProfiles collection
      await FirebaseFirestore.instance
          .collection('lawyerProfiles')
          .doc(widget.userId)
          .update({
        'fullName': fullNameController.text.trim(),
        'cnic': cnicController.text.trim(),
        'yearsOfExperience': yearsOfExperience,
        'barCouncil': selectedBarCouncil,
        'licenseNumber': licenseNumberController.text.trim(),
        'licenseCardFrontURL': frontURL ?? '',
        'licenseCardBackURL': backURL ?? '',
        'selfieWithLicenseURL': selfieURL ?? '',
        'verificationStatus': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile submitted! Waiting for verification.')),
      );

      // Navigate to Lawyer Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LawyerMainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLength = 50,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryMaroon, width: 2.0),
        ),
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
    );
  }

  Widget _buildBarCouncilDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedBarCouncil,
      decoration: InputDecoration(
        hintText: 'Select Bar Council',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryMaroon, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      items: barCouncils.map((String council) {
        return DropdownMenuItem<String>(
          value: council,
          child: Text(council),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedBarCouncil = newValue;
        });
      },
    );
  }

  Widget _buildImageUploadCard(
      String title, XFile? imageFile, String imageType) {
    return GestureDetector(
      onTap: () => _pickImage(imageType),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(
              imageFile == null
                  ? Icons.add_photo_alternate
                  : Icons.check_circle,
              size: 50,
              color: imageFile == null ? Colors.grey : primaryMaroon,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              imageFile == null ? 'Tap to upload' : 'Image selected ✓',
              style: TextStyle(
                fontSize: 14,
                color: imageFile == null ? Colors.grey : primaryMaroon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentStep ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index <= _currentStep ? primaryMaroon : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // Step 1: Face Verification (Placeholder)
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(Icons.face_retouching_natural, size: 100, color: primaryMaroon),
        const SizedBox(height: 20),
        const Text(
          'Face Verification',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'This feature will be enabled soon',
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            children: [
              Icon(Icons.info_outline, size: 40, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'Face ID verification will be used to ensure account security and prevent fraud.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 2: Personal Information
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please provide your details as per your Bar Council license',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 30),
        _buildTextField(
          hintText: 'Full Name (as per license)',
          controller: fullNameController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'CNIC Number (xxxxx-xxxxxxx-x)',
          controller: cnicController,
          keyboardType: TextInputType.text,
          maxLength: 15,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Years of Experience',
          controller: experienceController,
          keyboardType: TextInputType.number,
          maxLength: 2,
        ),
      ],
    );
  }

  // Step 3: Bar Council Details
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bar Council Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Provide your Bar Council registration information',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 30),
        _buildBarCouncilDropdown(),
        const SizedBox(height: 20),
        _buildTextField(
          hintText: 'License / Enrollment Number',
          controller: licenseNumberController,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  // Step 4: Document Upload
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Documents',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Upload clear photos of your Bar Council license',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 30),
        _buildImageUploadCard(
          'Bar License Card (Front) *',
          licenseFrontImage,
          'front',
        ),
        const SizedBox(height: 15),
        _buildImageUploadCard(
          'Bar License Card (Back) *',
          licenseBackImage,
          'back',
        ),
        const SizedBox(height: 15),
        _buildImageUploadCard(
          'Selfie Holding License (Optional)',
          selfieWithLicenseImage,
          'selfie',
        ),
        const SizedBox(height: 10),
        const Text(
          '* Required fields\nTip: A selfie with your license helps prevent fraud and speeds up verification.',
          style: TextStyle(
              fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title:
            const Text('Profile Setup', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // PageView for Steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildStep1(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildStep2(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildStep3(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildStep4(),
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: primaryMaroon),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(fontSize: 16, color: primaryMaroon),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _currentStep == _totalSteps - 1
                            ? _submitProfile
                            : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryMaroon,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
