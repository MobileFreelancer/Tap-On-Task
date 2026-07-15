enum TaskStatus { open, assigned, inProgress, completed, cancelled }
enum TaskCategory { cleaning, moving, repairs, delivery, shopping, tutoring, events, other }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskStatus status;
  final double budget;
  final String? currency;
  final String location;
  final double? latitude;
  final double? longitude;
  final String customerId;
  final String? customerName;
  final String? customerAvatar;
  final String? traderId;
  final String? traderName;
  final String? traderAvatar;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final List<String> imageUrls;
  final int bidCount;
  final double? traderRating;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.status = TaskStatus.open,
    required this.budget,
    this.currency = 'EGP',
    required this.location,
    this.latitude,
    this.longitude,
    required this.customerId,
    this.customerName,
    this.customerAvatar,
    this.traderId,
    this.traderName,
    this.traderAvatar,
    DateTime? createdAt,
    this.updatedAt,
    this.completedAt,
    this.imageUrls = const [],
    this.bidCount = 0,
    this.traderRating,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: _parseCategory(json['category'] as String? ?? 'other'),
      status: _parseStatus(json['status'] as String? ?? 'open'),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EGP',
      location: json['location'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      customerId: json['customerId'] as String? ?? '',
      customerName: json['customerName'] as String?,
      customerAvatar: json['customerAvatar'] as String?,
      traderId: json['traderId'] as String?,
      traderName: json['traderName'] as String?,
      traderAvatar: json['traderAvatar'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      bidCount: (json['bidCount'] as num?)?.toInt() ?? 0,
      traderRating: (json['traderRating'] as num?)?.toDouble(),
    );
  }

  static TaskCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
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

  static TaskStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return TaskStatus.assigned;
      case 'in_progress':
      case 'inprogress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.open;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'status': status.name,
        'budget': budget,
        'currency': currency,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'customerId': customerId,
        'customerName': customerName,
        'customerAvatar': customerAvatar,
        'traderId': traderId,
        'traderName': traderName,
        'traderAvatar': traderAvatar,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'imageUrls': imageUrls,
        'bidCount': bidCount,
        'traderRating': traderRating,
      };

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskStatus? status,
    double? budget,
    String? currency,
    String? location,
    double? latitude,
    double? longitude,
    String? customerId,
    String? customerName,
    String? customerAvatar,
    String? traderId,
    String? traderName,
    String? traderAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    List<String>? imageUrls,
    int? bidCount,
    double? traderRating,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerAvatar: customerAvatar ?? this.customerAvatar,
      traderId: traderId ?? this.traderId,
      traderName: traderName ?? this.traderName,
      traderAvatar: traderAvatar ?? this.traderAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      imageUrls: imageUrls ?? this.imageUrls,
      bidCount: bidCount ?? this.bidCount,
      traderRating: traderRating ?? this.traderRating,
    );
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.assigned:
        return 'Assigned';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive => status == TaskStatus.open || status == TaskStatus.assigned || status == TaskStatus.inProgress;
}

class TaskBidModel {
  final String id;
  final String taskId;
  final String traderId;
  final String? traderName;
  final String? traderAvatar;
  final double amount;
  final String? message;
  final DateTime createdAt;

  TaskBidModel({
    required this.id,
    required this.taskId,
    required this.traderId,
    this.traderName,
    this.traderAvatar,
    required this.amount,
    this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskBidModel.fromJson(Map<String, dynamic> json) {
    return TaskBidModel(
      id: json['id'] as String? ?? '',
      taskId: json['taskId'] as String? ?? '',
      traderId: json['traderId'] as String? ?? '',
      traderName: json['traderName'] as String?,
      traderAvatar: json['traderAvatar'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'traderId': traderId,
        'traderName': traderName,
        'traderAvatar': traderAvatar,
        'amount': amount,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };
}
