import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'create_service_screen.dart';

class LawyerGigsScreen extends StatefulWidget {
  const LawyerGigsScreen({super.key});

  @override
  State<LawyerGigsScreen> createState() => _LawyerGigsScreenState();
}

class _LawyerGigsScreenState extends State<LawyerGigsScreen> {
  String selectedCategory = 'All';

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
            _buildCategoryTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildGigsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'lawyer_gigs_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateServiceScreen(),
            ),
          );
        },
        backgroundColor: AppColors.maroonPrimary,
        icon: const Icon(Icons.add, color: AppColors.white, size: 20),
        label: const Text(
          'Create Service',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
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
            'My Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          // Revenue Icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.white, size: 18),
                const SizedBox(width: 4),
                const Text(
                  'PKR 68K',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  hintText: 'Search services...',
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
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: _buildStatCard('8', 'Active', Icons.check_circle_outline)),
          const SizedBox(width: 10),
          Expanded(
              child: _buildStatCard('25', 'Bookings', Icons.bookmark_border)),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('4.8', 'Rating', Icons.star_outline)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
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
          Icon(icon, color: AppColors.maroonPrimary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.maroonPrimary,
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

  Widget _buildCategoryTabs() {
    final categories = ['All', 'Consultation', 'Review', 'Representation'];
    return SizedBox(
      height: 36,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = categories[index]),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.maroonPrimary : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.maroonPrimary
                        : AppColors.gray200,
                  ),
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 12,
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

  Widget _buildGigsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGigCard(
          title: 'Legal Consultation - 1 Hour',
          price: 'PKR 5,000',
          category: 'Consultation',
          description:
              'Professional legal advice for criminal and family law cases. Includes case analysis and strategy planning.',
          bookings: 12,
          revenue: 'PKR 60,000',
          rating: 4.9,
          reviews: 8,
          deliveryTime: '1 Day',
          isActive: true,
        ),
        const SizedBox(height: 12),
        _buildGigCard(
          title: 'Contract Review & Analysis',
          price: 'PKR 8,000',
          category: 'Review',
          description:
              'Comprehensive review of legal contracts and agreements with detailed feedback and recommendations.',
          bookings: 8,
          revenue: 'PKR 64,000',
          rating: 5.0,
          reviews: 6,
          deliveryTime: '2 Days',
          isActive: true,
        ),
        const SizedBox(height: 12),
        _buildGigCard(
          title: 'Court Representation',
          price: 'PKR 25,000',
          category: 'Representation',
          description:
              'Full representation in court proceedings for criminal and civil cases.',
          bookings: 5,
          revenue: 'PKR 125,000',
          rating: 4.8,
          reviews: 4,
          deliveryTime: 'Varies',
          isActive: false,
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildGigCard({
    required String title,
    required String price,
    required String category,
    required String description,
    required int bookings,
    required String revenue,
    required double rating,
    required int reviews,
    required String deliveryTime,
    required bool isActive,
  }) {
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
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.maroonVeryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.maroonPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Active/Inactive Toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.green.withOpacity(0.1)
                      : AppColors.gray200,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isActive ? AppColors.green : AppColors.gray400,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.green : AppColors.gray600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Active' : 'Paused',
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive ? AppColors.green : AppColors.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Stats Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray200.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child:
                      _buildStatItem(Icons.bookmark, '$bookings', 'Bookings'),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.gray200,
                ),
                Expanded(
                  child: _buildStatItem(
                      Icons.star, rating.toString(), '$reviews reviews'),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.gray200,
                ),
                Expanded(
                  child: _buildStatItem(
                      Icons.access_time, deliveryTime, 'Delivery'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Price and Revenue Row
          Row(
            children: [
              // Price
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money, size: 14, color: AppColors.green),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Total Revenue
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: 14, color: AppColors.amber),
                    const SizedBox(width: 4),
                    Text(
                      revenue,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Edit
              InkWell(
                onTap: () {
                  // TODO: Edit service
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.edit_outlined,
                      size: 18, color: AppColors.maroonPrimary),
                ),
              ),
              const SizedBox(width: 10),
              // Delete
              InkWell(
                onTap: () {
                  // TODO: Delete service
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.delete_outline,
                      size: 18, color: AppColors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.maroonPrimary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
