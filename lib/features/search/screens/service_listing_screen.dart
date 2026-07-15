import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/service_card.dart';

class ServiceListingScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ServiceListingScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ServiceModel> _services = [];
  List<ProviderModel> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final searchService = context.read<SearchService>();
    _services = await searchService.getServicesByCategory(widget.categoryId);
    _providers = await searchService.getProvidersByCategory(widget.categoryId);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: Text(widget.categoryName),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryPurple,
          unselectedLabelColor: AppColors.textGray500,
          indicatorColor: AppColors.primaryPurple,
          tabs: const [
            Tab(text: 'Services'),
            Tab(text: 'Providers'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildServicesList(),
                _buildProvidersList(),
              ],
            ),
    );
  }

  Widget _buildServicesList() {
    if (_services.isEmpty) {
      return const Center(child: Text('No services in this category', style: TextStyle(color: AppColors.textGray500)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _services.length,
      itemBuilder: (_, i) => ServiceCard(
        service: _services[i],
        isHorizontal: false,
        onTap: () => context.pushNamed('serviceDetail', pathParameters: {'serviceId': _services[i].id}),
      ),
    );
  }

  Widget _buildProvidersList() {
    if (_providers.isEmpty) {
      return const Center(child: Text('No providers in this category', style: TextStyle(color: AppColors.textGray500)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _providers.length,
      itemBuilder: (_, i) => ProviderCard(
        provider: _providers[i],
        onTap: () => context.pushNamed('providerDetail', pathParameters: {'providerId': _providers[i].id}),
      ),
    );
  }
}
