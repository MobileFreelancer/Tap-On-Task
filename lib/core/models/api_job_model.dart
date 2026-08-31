class JobListResponseModel {
  final String status;
  final String message;
  final JobListData data;

  JobListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobListResponseModel.fromJson(Map<String, dynamic> json) {
    return JobListResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: JobListData.fromJson(json['data'] ?? {}),
    );
  }
}

class JobListData {
  final List<ApiJobModel> jobs;

  JobListData({required this.jobs});

  factory JobListData.fromJson(Map<String, dynamic> json) {
    return JobListData(
      jobs: (json['jobs'] as List? ?? [])
          .map((e) => ApiJobModel.fromJson(e))
          .toList(),
    );
  }
}

class ApiJobModel {
  final int id;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String description;
  final String address;
  final String latitude;
  final String longitude;
  final int? savedLocationId;
  final DateTime? preferredDate;
  final String preferredTimeStart;
  final String preferredTimeEnd;
  final String budgetType;
  final String? estimatedBudget;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ApiJobCategory? category;
  final ApiJobSubcategory? subcategory;
  final List<ApiJobPhoto> photos;

  ApiJobModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.savedLocationId,
    this.preferredDate,
    required this.preferredTimeStart,
    required this.preferredTimeEnd,
    required this.budgetType,
    this.estimatedBudget,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.subcategory,
    required this.photos,
  });

  factory ApiJobModel.fromJson(Map<String, dynamic> json) {
    return ApiJobModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subcategoryId: json['subcategory_id'] ?? 0,
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      savedLocationId: json['saved_location_id'],
      preferredDate: json['preferred_date'] != null 
          ? DateTime.tryParse(json['preferred_date']) 
          : null,
      preferredTimeStart: json['preferred_time_start'] ?? '',
      preferredTimeEnd: json['preferred_time_end'] ?? '',
      budgetType: json['budget_type'] ?? '',
      estimatedBudget: json['estimated_budget']?.toString(),
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      category: json['category'] != null 
          ? ApiJobCategory.fromJson(json['category']) 
          : null,
      subcategory: json['subcategory'] != null 
          ? ApiJobSubcategory.fromJson(json['subcategory']) 
          : null,
      photos: (json['photos'] as List? ?? [])
          .map((e) => ApiJobPhoto.fromJson(e))
          .toList(),
    );
  }
}

class ApiJobCategory {
  final int id;
  final String name;
  final String slug;

  ApiJobCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ApiJobCategory.fromJson(Map<String, dynamic> json) {
    return ApiJobCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ApiJobSubcategory {
  final int id;
  final String name;
  final String slug;

  ApiJobSubcategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ApiJobSubcategory.fromJson(Map<String, dynamic> json) {
    return ApiJobSubcategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ApiJobPhoto {
  final int id;
  final int taskId;
  final String photoPath;

  ApiJobPhoto({
    required this.id,
    required this.taskId,
    required this.photoPath,
  });

  factory ApiJobPhoto.fromJson(Map<String, dynamic> json) {
    return ApiJobPhoto(
      id: json['id'] ?? 0,
      taskId: json['task_id'] ?? 0,
      photoPath: json['photo_path'] ?? '',
    );
  }
}
