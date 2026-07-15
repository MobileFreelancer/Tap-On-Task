import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/service_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeService = context.read<HomeService>();
      if (homeService.categories.isEmpty) homeService.fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<HomeService>().categories;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('All Categories')),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                return CategoryGridItem(
                  category: cat,
                  onTap: () => context.pushNamed('serviceListing', queryParameters: {
                    'categoryId': cat.id,
                    'categoryName': cat.name,
                  }),
                );
              },
            ),
    );
  }
}
