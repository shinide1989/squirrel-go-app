/// 预算数据模型
class Budget {
  final int? id;
  final int? userId;
  final int? familyId;
  final int? categoryId;
  final double amount;
  final String periodType; // DAY, MONTH, YEAR
  final DateTime startDate;
  final DateTime endDate;
  final double warningThreshold;
  final String? categoryName;

  Budget({
    this.id,
    this.userId,
    this.familyId,
    this.categoryId,
    required this.amount,
    this.periodType = 'MONTH',
    required this.startDate,
    required this.endDate,
    this.warningThreshold = 0.80,
    this.categoryName,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      userId: json['user_id'],
      familyId: json['family_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
      periodType: json['period_type'] ?? 'MONTH',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      warningThreshold: (json['warning_threshold'] as num?)?.toDouble() ?? 0.80,
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'family_id': familyId,
      'category_id': categoryId,
      'amount': amount,
      'period_type': periodType,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'warning_threshold': warningThreshold,
      'category_name': categoryName,
    };
  }

  /// 计算预算执行进度
  BudgetProgress calculateProgress({double spentAmount = 0.0}) {
    final percentage = amount > 0 ? spentAmount / amount : 0.0;
    final remaining = amount - spentAmount;
    final isOverBudget = remaining < 0;
    final isWarning = percentage >= warningThreshold && !isOverBudget;

    return BudgetProgress(
      total: amount,
      spent: spentAmount,
      remaining: remaining,
      percentage: percentage,
      isOverBudget: isOverBudget,
      isWarning: isWarning,
    );
  }

  /// 获取格式化金额
  String get formattedAmount {
    return '¥${amount.toStringAsFixed(2)}';
  }

  /// 获取周期显示名称
  String get periodDisplayName {
    switch (periodType) {
      case 'DAY':
        return '日预算';
      case 'MONTH':
        return '月预算';
      case 'YEAR':
        return '年预算';
    }
  }
}

/// 预算执行进度
class BudgetProgress {
  final double total;
  final double spent;
  final double remaining;
  final double percentage;
  final bool isOverBudget;
  final bool isWarning;

  BudgetProgress({
    required this.total,
    required this.spent,
    required this.remaining,
    required this.percentage,
    required this.isOverBudget,
    required this.isWarning,
  });

  /// 获取剩余天数
  int get remainingDays {
    final now = DateTime.now();
    // 简化计算，实际应从 Budget 对象获取结束日期
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return endOfMonth.difference(now).inDays;
  }

  /// 获取日均可用额度
  double get dailyAvailable {
    if (remainingDays <= 0) return 0.0;
    return remaining > 0 ? remaining / remainingDays : 0.0;
  }

  /// 获取格式化进度
  String get formattedPercentage {
    return '${(percentage * 100).toStringAsFixed(1)}%';
  }

  /// 获取格式化剩余
  String get formattedRemaining {
    return '¥${remaining.toStringAsFixed(2)}';
  }
}
