import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/service_model.dart';
import '../utils/formatters.dart';
import 'image_placeholder.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCard();
    }
    return _buildVerticalCard();
  }

  Widget _buildHorizontalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePlaceholder(
              width: double.infinity,
              height: 110,
              borderRadius: 16,
              imageUrl: service.imageUrl,
              icon: Icons.home_repair_service_rounded,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, color: AppColors.textGray600),
                      ),
                      if (service.distanceKm != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textGray400),
                        Text(
                          '${service.distanceKm!.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 11, color: AppColors.textGray400),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Formatters.formatCurrency(service.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            ImagePlaceholder(
              width: 80,
              height: 80,
              borderRadius: 12,
              imageUrl: service.imageUrl,
              icon: Icons.home_repair_service_rounded,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (service.providerName != null)
                    Text(
                      service.providerName!,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        '${service.rating} (${service.reviewCount})',
                        style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.formatCurrency(service.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final VoidCallback? onTap;

  const ProviderCard({super.key, required this.provider, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            AvatarPlaceholder(radius: 28, name: provider.name, imageUrl: provider.avatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    provider.title,
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        '${provider.rating} (${provider.reviewCount})',
                        style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                      ),
                      if (provider.distanceKm != null) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textGray400),
                        Text(
                          '${provider.distanceKm!.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 11, color: AppColors.textGray400),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatCurrency(provider.hourlyRate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const Text('/hr', style: TextStyle(fontSize: 11, color: AppColors.textGray400)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  final ServiceCategoryModel category;
  final VoidCallback? onTap;

  const CategoryGridItem({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final BannerModel banner;

  const PromoBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: banner.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            banner.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (banner.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              banner.subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
