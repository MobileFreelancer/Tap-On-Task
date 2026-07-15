import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/image_placeholder.dart';
class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceModel? _service;
  ProviderModel? _provider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final searchService = context.read<SearchService>();
    _service = await searchService.getServiceById(widget.serviceId);
    if (_service?.providerId != null) {
      _provider = await searchService.getProviderById(_service!.providerId!);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ImagePlaceholder(
                width: double.infinity,
                height: 220,
                borderRadius: 0,
                imageUrl: _service!.imageUrl,
                icon: Icons.home_repair_service_rounded,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_service!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: AppColors.ratingStar),
                      const SizedBox(width: 4),
                      Text(
                        '${_service!.rating} (${_service!.reviewCount} reviews)',
                        style: const TextStyle(fontSize: 14, color: AppColors.textGray600),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.formatCurrency(_service!.price),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(_service!.description, style: const TextStyle(fontSize: 14, color: AppColors.textGray600, height: 1.5)),
                  if (_provider != null) ...[
                    const SizedBox(height: 24),
                    const Text('Provider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.pushNamed('providerDetail', pathParameters: {'providerId': _provider!.id}),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            AvatarPlaceholder(radius: 24, name: _provider!.name),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_provider!.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(_provider!.title, style: const TextStyle(fontSize: 12, color: AppColors.textGray500)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textGray400),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed('messages'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  label: const Text('Chat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => context.pushNamed('locationSelect', queryParameters: {
                    'serviceId': _service!.id,
                    'title': _service!.title,
                    'price': _service!.price.toString(),
                    'providerId': _service!.providerId ?? '',
                  }),
                  child: const Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderDetailScreen extends StatefulWidget {
  final String providerId;
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  ProviderModel? _provider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _provider = await context.read<SearchService>().getProviderById(widget.providerId);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_provider == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Provider not found')));

    final p = _provider!;
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  AvatarPlaceholder(radius: 48, name: p.name, imageUrl: p.avatarUrl),
                  const SizedBox(height: 12),
                  Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(p.title, style: const TextStyle(fontSize: 14, color: AppColors.textGray500)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: AppColors.ratingStar),
                      Text(' ${p.rating} (${p.reviewCount} reviews)'),
                      const SizedBox(width: 16),
                      Text('${p.completedJobs} jobs done', style: const TextStyle(color: AppColors.textGray500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${Formatters.formatCurrency(p.hourlyRate)}/hr',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(p.bio, style: const TextStyle(fontSize: 14, color: AppColors.textGray600, height: 1.5)),
            if (p.portfolioImages.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Portfolio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: p.portfolioImages.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ImagePlaceholder(width: 100, height: 100, imageUrl: p.portfolioImages[i]),
                  ),
                ),
              ),
            ],
            if (p.reviews.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Reviews (${p.reviews.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ...p.reviews.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Row(
                              children: List.generate(5, (i) => Icon(
                                    i < r.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                                    size: 14,
                                    color: AppColors.ratingStar,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r.comment, style: const TextStyle(fontSize: 13, color: AppColors.textGray600)),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.pushNamed('messages'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  label: const Text('Chat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => context.pushNamed('locationSelect', queryParameters: {
                    'providerId': p.id,
                    'title': p.title,
                    'price': p.hourlyRate.toString(),
                  }),
                  child: const Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
