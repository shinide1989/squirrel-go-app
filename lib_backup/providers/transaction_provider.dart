import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';

/// 交易状态 Provider
class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 获取收支列表
  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  /// 添加交易
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  /// 删除交易
  void removeTransaction(int id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// 设置分类列表
  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  /// 加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 错误处理
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// 计算月度总支出
  double calculateMonthlyExpense() {
    final now = DateTime.now();
    return _transactions
        .where((t) => 
            t.type == 'EXPENSE' &&
            t.transactionAt.year == now.year &&
            t.transactionAt.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// 计算月度总收入
  double calculateMonthlyIncome() {
    final now = DateTime.now();
    return _transactions
        .where((t) => 
            t.type == 'INCOME' &&
            t.transactionAt.year == now.year &&
            t.transactionAt.month == now.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
