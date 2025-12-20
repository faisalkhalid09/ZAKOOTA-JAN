import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LawyerCasesScreen extends StatefulWidget {
  const LawyerCasesScreen({super.key});

  @override
  State<LawyerCasesScreen> createState() => _LawyerCasesScreenState();
}

class _LawyerCasesScreenState extends State<LawyerCasesScreen> {
  String selectedTab = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildCasesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.maroonDark, AppColors.maroonPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroonPrimary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'My Cases',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          // Message Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message_outlined,
                    color: AppColors.white, size: 22),
                onPressed: () {
                  // TODO: Open messages
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Notification Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.white, size: 22),
                onPressed: () {
                  // TODO: Open notifications
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray200.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.gray600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search cases...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.gray600,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              // TODO: Show filter options
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.maroonPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.maroonPrimary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.filter_list, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: _buildStatCard('24', 'Active', AppColors.maroonPrimary)),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('8', 'Pending', AppColors.amber)),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('127', 'Completed', AppColors.green)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTab('Active', 24),
          const SizedBox(width: 6),
          _buildTab('Pending', 8),
          const SizedBox(width: 6),
          _buildTab('Completed', 127),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int count) {
    final isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.maroonPrimary : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.maroonPrimary : AppColors.gray200,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white.withOpacity(0.2)
                      : AppColors.gray200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.gray600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCasesList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildCaseCard(
          title: 'Property Dispute Case',
          caseNumber: 'CASE-2024-001',
          client: 'Ahmed Hassan',
          clientPhone: '+92 300 1234567',
          type: 'Property Law',
          priority: 'High',
          progress: 85,
          nextHearing: 'Jan 25, 2024',
          fee: 'PKR 50,000',
          documents: 12,
          notes:
              'Property ownership dispute over land in Lahore. Multiple hearings completed.',
        ),
        const SizedBox(height: 12),
        _buildCaseCard(
          title: 'Divorce Settlement',
          caseNumber: 'CASE-2024-002',
          client: 'Fatima Ali',
          clientPhone: '+92 301 2345678',
          type: 'Family Law',
          priority: 'Medium',
          progress: 60,
          nextHearing: 'Feb 2, 2024',
          fee: 'PKR 35,000',
          documents: 8,
          notes: 'Mutual divorce case with property settlement ongoing.',
        ),
        const SizedBox(height: 12),
        _buildCaseCard(
          title: 'Corporate Contract Review',
          caseNumber: 'CASE-2024-003',
          client: 'Usman Khan',
          clientPhone: '+92 302 3456789',
          type: 'Corporate Law',
          priority: 'Low',
          progress: 40,
          nextHearing: 'Feb 10, 2024',
          fee: 'PKR 75,000',
          documents: 15,
          notes: 'Contract review for merger and acquisition deal.',
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildCaseCard({
    required String title,
    required String caseNumber,
    required String client,
    required String clientPhone,
    required String type,
    required String priority,
    required int progress,
    required String nextHearing,
    required String fee,
    required int documents,
    required String notes,
  }) {
    Color priorityColor = priority == 'High'
        ? AppColors.red
        : priority == 'Medium'
            ? AppColors.amber
            : AppColors.green;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.maroonVeryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.gavel, color: AppColors.maroonPrimary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      caseNumber,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: priorityColor.withOpacity(0.3)),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    fontSize: 10,
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Client Info
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray200.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    size: 16, color: AppColors.maroonPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        clientPhone,
                        style:
                            TextStyle(fontSize: 11, color: AppColors.gray600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone,
                      size: 18, color: AppColors.maroonPrimary),
                  onPressed: () {
                    // TODO: Call client
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.message,
                      size: 18, color: AppColors.maroonPrimary),
                  onPressed: () {
                    // TODO: Message client
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Details Grid
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.category_outlined, 'Type', type),
              ),
              Expanded(
                child: _buildDetailItem(Icons.attach_money, 'Fee', fee),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                    Icons.calendar_today_outlined, 'Next Hearing', nextHearing),
              ),
              Expanded(
                child: _buildDetailItem(
                    Icons.folder_outlined, 'Documents', '$documents files'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Notes
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.amber.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amber.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notes_outlined, size: 14, color: AppColors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notes,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Case Progress',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.maroonPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation(AppColors.maroonPrimary),
                  minHeight: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: View case details
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.maroonPrimary,
                    side: BorderSide(color: AppColors.maroonPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View Details',
                      style: TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Update case
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroonPrimary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Update', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gray600),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.gray600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
