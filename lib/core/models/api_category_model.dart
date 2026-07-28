class CategoryResponseModel {
  final String status;
  final String message;
  final CategoryData data;

  CategoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: CategoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class CategoryData {
  final List<ApiCategory> categories;

  CategoryData({required this.categories});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories: (json['categories'] as List? ?? [])
          .map((e) => ApiCategory.fromJson(e))
          .toList(),
    );
  }
}

class ApiCategory {
  final int id;
  final String name;
  final String slug;
  final List<ApiSubcategory> subcategories;

  ApiCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.subcategories,
  });

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      subcategories: (json['subcategories'] as List? ?? [])
          .map((e) => ApiSubcategory.fromJson(e))
          .toList(),
    );
  }
}

class ApiSubcategory {
  final int id;
  final String name;
  final String slug;

  ApiSubcategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ApiSubcategory.fromJson(Map<String, dynamic> json) {
    return ApiSubcategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
