// Path: screens/documents_screen.dart (Final Correct Code)

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/app_nav_bar.dart';

// 🔑 Data Structure
class Document {
  final String fileName;
  final String uploadedBy;
  final String date;
  final String format; // For file icon
  final bool isDeletable;

  Document({
    required this.fileName,
    required this.uploadedBy,
    required this.date,
    required this.format,
    this.isDeletable = false,
  });
}

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);
  String _searchQuery = '';

  // 🔑 Dummy Data
  final List<Document> allDocuments = [
    Document(
        fileName: 'Evidence.pdf',
        uploadedBy: 'You',
        date: 'April 20',
        format: 'pdf',
        isDeletable: true),
    Document(
        fileName: 'Contract_Agreement.docx',
        uploadedBy: 'Lawyer Name',
        date: 'April 22',
        format: 'docx',
        isDeletable: false),
    Document(
        fileName: 'ID_Proof.pdf',
        uploadedBy: 'You',
        date: 'April 20',
        format: 'pdf',
        isDeletable: true),
    Document(
        fileName: 'Case_Letter.pdf',
        uploadedBy: 'Lawyer Name',
        date: 'April 23',
        format: 'pdf',
        isDeletable: false),
  ];

  // 🔑 Filtering Logic
  List<Document> get filteredDocuments {
    if (_searchQuery.isEmpty) {
      return allDocuments;
    }
    return allDocuments.where((doc) {
      final query = _searchQuery.toLowerCase();
      return doc.fileName.toLowerCase().contains(query);
    }).toList();
  }

  // 🔑 Get File Icon
  IconData _getFileIcon(String format) {
    switch (format.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
      case 'doc':
        return Icons.description;
      case 'jpg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  // 🔑 Updated Document List Tile (UI Match & Overflow Fixed)
  Widget _buildDocumentListTile({required Document doc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

        // Leading: File Icon
        leading: Icon(_getFileIcon(doc.format), color: primaryMaroon, size: 30),

        // Title & Subtitle
        title: Text(doc.fileName,
            // Overflow fix ke liye ellipsis zaroori hai
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('Uploaded by: ${doc.uploadedBy} • ${doc.date}',
            style: const TextStyle(color: Colors.grey, fontSize: 12)),

        // Trailing: Icons (Overflow Fixed by setting zero constraints)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. View Icon (Eye)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon:
                  const Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
              onPressed: () {
                // TODO: View Document logic
              },
            ),
            const SizedBox(width: 10),
            // 2. Download Icon
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.file_download, color: primaryMaroon),
              onPressed: () {
                // TODO: Download Document logic
              },
            ),
            const SizedBox(width: 10),
            // 3. Delete Icon
            doc.isDeletable
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // TODO: Delete Document logic
                    },
                  )
                : const SizedBox(width: 0),
          ],
        ),
        onTap: () {
          // TODO: View Document on Tap
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Documents', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // TODO: Menu/Settings Action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar (Functional)
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
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
                    _searchQuery = value; // 🔑 Search Query updated
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Documents',
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

          // 2. Upload Button (Maroon, Functional)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Handle Document Upload
              },
              icon:
                  const Icon(Icons.cloud_upload_outlined, color: Colors.white),
              label: const Text('Upload Document',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 3. Filtered Document List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              children: filteredDocuments.map((doc) {
                return _buildDocumentListTile(doc: doc);
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),

      // 4. Bottom Navigation Bar
      bottomNavigationBar: AppNavBar(
        currentIndex: 4, // Assuming Documents is the 5th item (index 4)
        context: context,
      ),
    );
  }
}
