import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/app_header.dart';

class TraderDetailScreen extends StatelessWidget {
  const TraderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
        title: "Mike Wilson",
        headerHeight: 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 0.0.w),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileCard(),
                    const SizedBox(height: 16),
                    _buildRatingSection(),
                    const SizedBox(height: 16),
                    _buildAboutMeSection(),
                    const SizedBox(height: 16),
                    _buildPortfolioSection(),
                    const SizedBox(height: 16),
                    _buildServicesSection(),
                    const SizedBox(height: 16),
                    _buildReviewsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // --- Profile Card ---
  Widget _buildProfileCard() {
    return _buildCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=150',
              width: 90,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plumber',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A334E),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '10+ years experience',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      '2 Km away',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '8 jobs completed nearby',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Available Today',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Rating Breakdown Card ---
  Widget _buildRatingSection() {
    return _buildCard(
      child: Row(
        children: [
          // Overall Rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A334E),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '125 Reviews',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const ContainerDivider(),
          // Progress Bars
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRatingBar(5, 0.85, '84'),
                _buildRatingBar(4, 0.40, '25'),
                _buildRatingBar(3, 0.90, '10', highlighted: true),
                _buildRatingBar(2, 0.20, '3'),
                _buildRatingBar(1, 0.15, '3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int starNum, double percent, String count,
      {bool highlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$starNum',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star, size: 10, color: Colors.orange),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
                border: highlighted
                    ? Border.all(color: Colors.blue, width: 1)
                    : null,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: highlighted ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 16,
            child: Text(
              count,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // --- About Me Section ---
  Widget _buildAboutMeSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A334E),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          const Text(
            'Skilled handyman offering plumbing, electrical, and home repair services reliable and professional.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF556575),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- Portfolio Section ---
  Widget _buildPortfolioSection() {
    final List<String> images = [
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=150',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150',
      'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=150',
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A334E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: images.map((url) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- My Services Section ---
  Widget _buildServicesSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Services',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A334E),
            ),
          ),
          const SizedBox(height: 10),
          _buildBulletPoint('Plumbing, Electrical, Carpentry'),
          const SizedBox(height: 6),
          _buildBulletPoint('Starting at \$50'),
          const SizedBox(height: 6),
          _buildBulletPoint('Typically responds in 1 hour'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF556575)),
        ),
      ],
    );
  }

  // --- Reviews Section ---
  Widget _buildReviewsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A334E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A334E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
                ),
              ),
              const SizedBox(width: 10),
              // Name, Rating & Comment
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Sarah M.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A334E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            5,
                                (index) => const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Great work! Fixed my leaky sink quickly. Highly recommended!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF556575),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Reusable Card Builder Container ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Vertical Line Divider Component
class ContainerDivider extends StatelessWidget {
  const ContainerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}