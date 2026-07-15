class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? type;
  final String? referenceId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.type,
    this.referenceId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      type: json['type'] as String?,
      referenceId: json['referenceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        'type': type,
        'referenceId': referenceId,
      };
}

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answer': answer,
        'category': category,
      };
}
