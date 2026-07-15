import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? imageUrl;

  const ImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.icon = Icons.image_rounded,
    this.backgroundColor,
    this.iconColor,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primarySurface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColors.primaryLight,
        size: (height ?? 48) * 0.4,
      ),
    );
  }
}

class AvatarPlaceholder extends StatelessWidget {
  final double radius;
  final String? name;
  final String? imageUrl;
  final Color? backgroundColor;

  const AvatarPlaceholder({
    super.key,
    this.radius = 24,
    this.name,
    this.imageUrl,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, _) {},
        child: imageUrl == null ? _buildInitials() : null,
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primarySurface,
      child: _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = name != null && name!.isNotEmpty
        ? name!.split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';
    return Text(
      initials,
      style: TextStyle(
        fontSize: radius * 0.6,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryPurple,
      ),
    );
  }
}
