import 'package:flutter/material.dart';
import '../models/budget.dart';

/// 预算状态 Provider
class BudgetProvider extends ChangeNotifier {
  List<Budget> _budgets = [];
  bool _isLoading = false;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  /// 设置预算列表
  void setBudgets(List<Budget> budgets) {
    _budgets = budgets;
    notifyListeners();
  }

  /// 添加预算
  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  /// 更新预算
  void updateBudget(Budget budget) {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
      notifyListeners();
    }
  }

  /// 删除预算
  void removeBudget(int id) {
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// 加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 获取当前月度预算执行进度
  BudgetProgress getMonthlyProgress(int budgetId) {
    final budget = _budgets.firstWhere((b) => b.id == budgetId);
    return budget.calculateProgress();
  }

  /// 检查是否触发预警
  bool checkWarning(int budgetId) {
    final progress = getMonthlyProgress(budgetId);
    return progress.percentage >= 0.8 || progress.remaining < 0;
  }
}
