import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6B1E1E),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.maroonPrimary,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF6B1E1E),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Schedule',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.white),
              onPressed: () {
                // TODO: Add new appointment
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildDateSelector(),
              const SizedBox(height: 12),
              _buildFilterTabs(),
              const SizedBox(height: 12),
              Expanded(
                child: _buildScheduleList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: AppColors.maroonPrimary, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Today, Jan 20, 2024',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon:
                Icon(Icons.arrow_back_ios, size: 16, color: AppColors.gray600),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.gray600),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Hearings', 'Meetings', 'Consultations'];
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => selectedFilter = filters[index]),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.maroonPrimary : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.maroonPrimary
                        : AppColors.gray200,
                  ),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.gray600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScheduleCard(
          'Court Hearing - Property Dispute',
          'District Court, Room 304',
          '10:00 AM - 11:30 AM',
          'Ahmed Hassan',
          'hearing',
          'upcoming',
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(
          'Client Consultation',
          'Office',
          '2:00 PM - 3:00 PM',
          'Fatima Ali',
          'consultation',
          'upcoming',
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(
          'Contract Review Meeting',
          'Online - Zoom',
          '4:30 PM - 5:30 PM',
          'Usman Khan',
          'meeting',
          'upcoming',
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(
          'Court Hearing - Divorce Case',
          'Family Court, Room 102',
          'Yesterday - 9:00 AM',
          'Sana Ahmed',
          'hearing',
          'completed',
        ),
      ],
    );
  }

  Widget _buildScheduleCard(
    String title,
    String location,
    String time,
    String clientName,
    String type,
    String status,
  ) {
    IconData typeIcon;
    Color typeColor;

    switch (type) {
      case 'hearing':
        typeIcon = Icons.gavel;
        typeColor = AppColors.maroonPrimary;
        break;
      case 'meeting':
        typeIcon = Icons.groups;
        typeColor = Colors.blue;
        break;
      case 'consultation':
        typeIcon = Icons.chat_bubble_outline;
        typeColor = AppColors.green;
        break;
      default:
        typeIcon = Icons.event;
        typeColor = AppColors.gray600;
    }

    final isPast = status == 'completed';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPast ? AppColors.gray200.withOpacity(0.3) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPast ? AppColors.gray200 : AppColors.gray200,
        ),
        boxShadow: isPast
            ? []
            : [
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPast ? AppColors.gray600 : AppColors.textColor,
                        decoration: isPast ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12, color: AppColors.gray600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isPast)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gray400.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: AppColors.gray600),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.person_outline, size: 14, color: AppColors.gray600),
              const SizedBox(width: 4),
              Text(
                clientName,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
          if (!isPast) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.videocam, size: 16),
                  label: Text('Join'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.maroonPrimary,
                    side: BorderSide(color: AppColors.maroonPrimary),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 16),
                  label: Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gray600,
                    side: BorderSide(color: AppColors.gray200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.notifications_outlined, size: 20),
                  color: AppColors.amber,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
