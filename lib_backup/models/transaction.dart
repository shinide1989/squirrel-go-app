import 'category.dart';
/// 交易数据模型
class Transaction {
  final int? id;
  final int userId;
  final int? familyId;
  final int? categoryId;
  final double amount;
  final String type; // INCOME or EXPENSE
  final String? description;
  final DateTime transactionAt;
  final String source; // MANUAL, SMS, API, OCR, VOICE
  final bool isPrivate;
  final Category? category;

  Transaction({
    this.id,
    required this.userId,
    this.familyId,
    this.categoryId,
    required this.amount,
    required this.type,
    this.description,
    required this.transactionAt,
    this.source = 'MANUAL',
    this.isPrivate = false,
    this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      familyId: json['family_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      description: json['description'],
      transactionAt: DateTime.parse(json['transaction_at']),
      source: json['source'] ?? 'MANUAL',
      isPrivate: json['is_private'] ?? false,
      category: json['category'] != null 
          ? Category.fromJson(json['category']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'family_id': familyId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'description': description,
      'transaction_at': transactionAt.toIso8601String(),
      'source': source,
      'is_private': isPrivate,
    };
  }

  /// 获取格式化金额
  String get formattedAmount {
    return '¥${amount.toStringAsFixed(2)}';
  }

  /// 获取交易类型图标
  IconData get typeIcon {
    return type == 'INCOME' ? Icons.arrow_downward : Icons.arrow_upward;
  }

  /// 获取交易类型颜色
  int get typeColor {
    return type == 'INCOME' ? 0xFF52C41A : 0xFFFA541C;
  }
}
