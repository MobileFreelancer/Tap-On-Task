import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/service_card.dart';
import '../../../core/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerController = PageController();
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeService>().fetchHomeData();
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeService = context.watch<HomeService>();
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: SafeArea(
        child: homeService.isLoading
            ? const _HomeShimmer()
            : RefreshIndicator(
                onRefresh: () => homeService.fetchHomeData(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(auth)),
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    SliverToBoxAdapter(child: _buildBannerCarousel(homeService)),
                    SliverToBoxAdapter(child: _buildCategories(homeService)),
                    SliverToBoxAdapter(child: _buildSectionTitle('Popular Services', onSeeAll: () => context.goNamed('categories'))),
                    SliverToBoxAdapter(child: _buildPopularServices(homeService)),
                    if (homeService.recentBookings.isNotEmpty) ...[
                      SliverToBoxAdapter(child: _buildSectionTitle('Recent Bookings', onSeeAll: () => context.goNamed('myTasks'))),
                      SliverToBoxAdapter(child: _buildRecentBookings(homeService)),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('postTask'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Task'),
      ),
    );
  }

  Widget _buildHeader(AuthService auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.primaryPurple, size: 20),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'New Cairo, Egypt',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ),
          Consumer<NotificationService>(
            builder: (context, notif, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: AppColors.textGray600,
                  onPressed: () => context.pushNamed('notifications'),
                ),
                if (notif.unreadCount > 0)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: GestureDetector(
        onTap: () => context.goNamed('search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: const Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20),
              SizedBox(width: 12),
              Text('Search services, providers...', style: TextStyle(color: AppColors.textGray400, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(HomeService homeService) {
    if (homeService.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: homeService.banners.length,
            itemBuilder: (_, i) => PromoBanner(banner: homeService.banners[i]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(homeService.banners.length, (i) {
            return Container(
              width: _currentBanner == i ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentBanner == i ? AppColors.primaryPurple : AppColors.borderLight,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategories(HomeService homeService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSectionTitle('Categories', onSeeAll: () => context.goNamed('categories')),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: homeService.categories.length > 8 ? 8 : homeService.categories.length,
            itemBuilder: (_, i) {
              final cat = homeService.categories[i];
              return CategoryGridItem(
                category: cat,
                onTap: () => context.pushNamed('serviceListing', queryParameters: {'categoryId': cat.id, 'categoryName': cat.name}),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See All', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
    );
  }

  Widget _buildPopularServices(HomeService homeService) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: homeService.popularServices.length,
        itemBuilder: (_, i) => ServiceCard(
          service: homeService.popularServices[i],
          onTap: () => context.pushNamed('serviceDetail', pathParameters: {'serviceId': homeService.popularServices[i].id}),
        ),
      ),
    );
  }

  Widget _buildRecentBookings(HomeService homeService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: homeService.recentBookings.map((booking) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: AppColors.primaryPurple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(booking.providerName ?? booking.location, style: const TextStyle(fontSize: 12, color: AppColors.textGray500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(booking.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.statusLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor(booking.status)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return AppColors.accentBlue;
      case 'completed':
        return AppColors.accentGreen;
      case 'pending':
        return AppColors.accentOrange;
      default:
        return AppColors.textGray500;
    }
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ShimmerBox(height: 40, width: double.infinity),
          SizedBox(height: 16),
          ShimmerBox(height: 48, width: double.infinity),
          SizedBox(height: 16),
          ShimmerBox(height: 140, width: double.infinity),
          SizedBox(height: 24),
          TaskCardShimmer(),
        ],
      ),
    );
  }
}
