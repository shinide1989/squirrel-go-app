import 'package:flutter/material.dart';
/// 分类数据模型
class Category {
  final int? id;
  final int? userId;
  final String name;
  final String icon;
  final String type; // INCOME or EXPENSE
  final int? parentId;
  final bool isSystem;

  Category({
    this.id,
    this.userId,
    required this.name,
    required this.icon,
    required this.type,
    this.parentId,
    this.isSystem = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      icon: json['icon'] ?? 'category',
      type: json['type'],
      parentId: json['parent_id'],
      isSystem: json['is_system'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'type': type,
      'parent_id': parentId,
      'is_system': isSystem,
    };
  }

  /// 获取分类图标
  IconData get iconData {
    return _getIconFromString(icon);
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'housing':
        return Icons.home;
      case 'income':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }
}

/// 系统预定义分类
class SystemCategories {
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': '餐饮美食', 'icon': 'food'},
    {'name': '交通出行', 'icon': 'transport'},
    {'name': '购物消费', 'icon': 'shopping'},
    {'name': '娱乐休闲', 'icon': 'entertainment'},
    {'name': '居家生活', 'icon': 'housing'},
    {'name': '医疗保健', 'icon': 'medical'},
    {'name': '教育培训', 'icon': 'education'},
    {'name': '人情往来', 'icon': 'gift'},
    {'name': '其他支出', 'icon': 'other'},
  ];

  static const List<Map<String, dynamic>> incomeCategories = [
    {'name': '工资收入', 'icon': 'salary'},
    {'name': '奖金收入', 'icon': 'bonus'},
    {'name': '投资收益', 'icon': 'investment'},
    {'name': '兼职收入', 'icon': 'parttime'},
    {'name': '其他收入', 'icon': 'other'},
  ];
}
