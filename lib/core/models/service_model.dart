import 'package:flutter/material.dart';
import 'task_model.dart';

class ServiceCategoryModel {
  final String id;
  final String name;
  final String? iconName;
  final IconData icon;
  final Color color;
  final int serviceCount;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    this.iconName,
    required this.icon,
    required this.color,
    this.serviceCount = 0,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      iconName: json['iconName'] as String?,
      icon: Icons.category_rounded,
      color: const Color(0xFF7C3AED),
      serviceCount: (json['serviceCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'serviceCount': serviceCount,
      };

  TaskCategory? get taskCategory {
    switch (id) {
      case 'cleaning':
        return TaskCategory.cleaning;
      case 'moving':
        return TaskCategory.moving;
      case 'repairs':
        return TaskCategory.repairs;
      case 'delivery':
        return TaskCategory.delivery;
      case 'shopping':
        return TaskCategory.shopping;
      case 'tutoring':
        return TaskCategory.tutoring;
      case 'events':
        return TaskCategory.events;
      default:
        return TaskCategory.other;
    }
  }
}

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String? imageUrl;
  final double price;
  final String currency;
  final double rating;
  final int reviewCount;
  final String? providerId;
  final String? providerName;
  final double? distanceKm;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    this.imageUrl,
    required this.price,
    this.currency = 'EGP',
    this.rating = 0,
    this.reviewCount = 0,
    this.providerId,
    this.providerName,
    this.distanceKm,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      providerId: json['providerId'] as String?,
      providerName: json['providerName'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'price': price,
        'currency': currency,
        'rating': rating,
        'reviewCount': reviewCount,
        'providerId': providerId,
        'providerName': providerName,
        'distanceKm': distanceKm,
      };
}

class ProviderModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String title;
  final String bio;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final double hourlyRate;
  final String currency;
  final double? distanceKm;
  final List<String> portfolioImages;
  final List<ReviewModel> reviews;
  final String categoryId;

  const ProviderModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.title,
    required this.bio,
    this.rating = 0,
    this.reviewCount = 0,
    this.completedJobs = 0,
    required this.hourlyRate,
    this.currency = 'EGP',
    this.distanceKm,
    this.portfolioImages = const [],
    this.reviews = const [],
    required this.categoryId,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      completedJobs: (json['completedJobs'] as num?)?.toInt() ?? 0,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      portfolioImages: (json['portfolioImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categoryId: json['categoryId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'title': title,
        'bio': bio,
        'rating': rating,
        'reviewCount': reviewCount,
        'completedJobs': completedJobs,
        'hourlyRate': hourlyRate,
        'currency': currency,
        'distanceKm': distanceKm,
        'portfolioImages': portfolioImages,
        'reviews': reviews.map((e) => e.toJson()).toList(),
        'categoryId': categoryId,
      };
}

class ReviewModel {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };
}

class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Color backgroundColor;
  final String? actionRoute;

  const BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.backgroundColor = const Color(0xFF7C3AED),
    this.actionRoute,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      actionRoute: json['actionRoute'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        'actionRoute': actionRoute,
      };
}
