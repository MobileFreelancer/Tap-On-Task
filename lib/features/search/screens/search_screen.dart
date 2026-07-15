import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_mock_data.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/service_card.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchService = context.watch<SearchService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (q) => searchService.search(q),
              decoration: InputDecoration(
                hintText: 'Search services, providers...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          searchService.clearSearch();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: searchService.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchService.query.isEmpty
                    ? _buildTrending()
                    : _buildResults(searchService),
          ),
        ],
      ),
    );
  }

  Widget _buildTrending() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Trending Searches',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppMockData.trendingSearches.map((term) {
            return ActionChip(
              label: Text(term),
              avatar: const Icon(Icons.trending_up_rounded, size: 16),
              onPressed: () {
                _searchController.text = term;
                context.read<SearchService>().search(term);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Popular Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...AppMockData.categories.take(4).map((cat) => ListTile(
              leading: CircleAvatar(
                backgroundColor: cat.color.withValues(alpha: 0.1),
                child: Icon(cat.icon, color: cat.color, size: 20),
              ),
              title: Text(cat.name),
              subtitle: Text('${cat.serviceCount} services'),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textGray400),
              onTap: () => context.pushNamed('serviceListing', queryParameters: {'categoryId': cat.id, 'categoryName': cat.name}),
            )),
      ],
    );
  }

  Widget _buildResults(SearchService searchService) {
    if (searchService.results.isEmpty && searchService.providerResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppColors.textGray400),
            SizedBox(height: 16),
            Text('No results found', style: TextStyle(fontSize: 16, color: AppColors.textGray500)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (searchService.results.isNotEmpty) ...[
          Text(
            'Services (${searchService.results.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...searchService.results.map((s) => ServiceCard(
                service: s,
                isHorizontal: false,
                onTap: () => context.pushNamed('serviceDetail', pathParameters: {'serviceId': s.id}),
              )),
        ],
        if (searchService.providerResults.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Providers (${searchService.providerResults.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...searchService.providerResults.map((p) => ProviderCard(
                provider: p,
                onTap: () => context.pushNamed('providerDetail', pathParameters: {'providerId': p.id}),
              )),
        ],
      ],
    );
  }
}
