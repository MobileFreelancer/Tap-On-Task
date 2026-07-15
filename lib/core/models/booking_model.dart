enum PaymentMethodType { card, applePay, googlePay, wallet, paypal }

enum TransactionType { credit, debit }

class BookingModel {
  final String id;
  final String taskId;
  final String? serviceId;
  final String? providerId;
  final String? providerName;
  final String title;
  final String status;
  final DateTime scheduledAt;
  final String location;
  final double amount;
  final String currency;
  final String? categoryName;

  const BookingModel({
    required this.id,
    required this.taskId,
    this.serviceId,
    this.providerId,
    this.providerName,
    required this.title,
    required this.status,
    required this.scheduledAt,
    required this.location,
    required this.amount,
    this.currency = 'EGP',
    this.categoryName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      taskId: json['taskId'] as String? ?? '',
      serviceId: json['serviceId'] as String?,
      providerId: json['providerId'] as String?,
      providerName: json['providerName'] as String?,
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'] as String)
          : DateTime.now(),
      location: json['location'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      categoryName: json['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'serviceId': serviceId,
        'providerId': providerId,
        'providerName': providerName,
        'title': title,
        'status': status,
        'scheduledAt': scheduledAt.toIso8601String(),
        'location': location,
        'amount': amount,
        'currency': currency,
        'categoryName': categoryName,
      };

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'assigned':
        return 'Assigned';
      case 'in_progress':
      case 'inprogress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

class PaymentMethodModel {
  final String id;
  final PaymentMethodType type;
  final String label;
  final String? lastFour;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.label,
    this.lastFour,
    this.isDefault = false,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String? ?? '',
      type: _parseType(json['type'] as String? ?? 'card'),
      label: json['label'] as String? ?? '',
      lastFour: json['lastFour'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  static PaymentMethodType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'apple_pay':
        return PaymentMethodType.applePay;
      case 'google_pay':
        return PaymentMethodType.googlePay;
      case 'wallet':
        return PaymentMethodType.wallet;
      case 'paypal':
        return PaymentMethodType.paypal;
      default:
        return PaymentMethodType.card;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
        'lastFour': lastFour,
        'isDefault': isDefault,
      };
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final TransactionType type;
  final DateTime createdAt;
  final String status;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    this.currency = 'EGP',
    required this.type,
    required this.createdAt,
    this.status = 'completed',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      type: json['type'] == 'credit' ? TransactionType.credit : TransactionType.debit,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'currency': currency,
        'type': type == TransactionType.credit ? 'credit' : 'debit',
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };
}

class WalletModel {
  final double balance;
  final String currency;
  final List<TransactionModel> transactions;

  const WalletModel({
    required this.balance,
    this.currency = 'EGP',
    this.transactions = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'currency': currency,
        'transactions': transactions.map((e) => e.toJson()).toList(),
      };
}
