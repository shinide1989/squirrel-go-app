import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/budget.dart';

/// 预算进度卡片
class BudgetProgressCard extends StatelessWidget {
  final List<Budget> budgets;
  final double spentAmount;

  const BudgetProgressCard({
    super.key,
    required this.budgets,
    required this.spentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // 获取月度总预算
    final monthlyBudget = budgets
        .where((b) => b.periodType == 'MONTH')
        .fold<double>(0, (sum, b) => sum + b.amount);

    // 计算进度
    final progress = monthlyBudget > 0 ? spentAmount / monthlyBudget : 0.0;
    final remaining = monthlyBudget - spentAmount;
    final isOverBudget = remaining < 0;
    final isWarning = progress >= 0.8 && !isOverBudget;

    // 获取预警文案
    String warningText = '';
    if (isWarning) {
      warningText = themeProvider.getWarningMessage(progress, WarningType.threshold80);
    } else if (isOverBudget) {
      warningText = themeProvider.getWarningMessage(progress, WarningType.overBudget);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '本月预算',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '¥${monthlyBudget.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 进度条 - 根据模式显示不同样式
            _buildProgressBar(context, progress, isOverBudget),
            const SizedBox(height: 12),

            // 进度详情
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '已支出',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '¥${spentAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '剩余',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '¥${remaining.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverBudget 
                            ? const Color(0xFFFA541C)
                            : const Color(0xFF52C41A),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 预警提示
            if (warningText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getWarningColor(themeProvider.currentMode).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getWarningColor(themeProvider.currentMode),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isOverBudget ? Icons.error : Icons.warning,
                      color: _getWarningColor(themeProvider.currentMode),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warningText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getWarningColor(themeProvider.currentMode),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    double progress,
    bool isOverBudget,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // 根据模式选择进度条样式
    switch (themeProvider.currentMode) {
      case ThemeModeEnum.coinquest:
        // 趣玩派 - 血量条风格
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getHealthBarColor(progress),
            ),
          ),
        );

      case ThemeModeEnum.familyCfo:
        // 极客派 - 环形进度条风格（简化为线性）
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget ? const Color(0xFFE53E3E) : const Color(0xFF1E3A5F),
            ),
          ),
        );

      case ThemeModeEnum.harmonyLedger:
        // 温情派 - 柔和渐变风格
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 16,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget 
                  ? const Color(0xFFFF6B6B) 
                  : const Color(0xFFD4A574),
            ),
          ),
        );
    }
  }

  Color _getHealthBarColor(double progress) {
    if (progress >= 1.0) {
      return const Color(0xFFFF4757); // 红色 - 危险
    } else if (progress >= 0.8) {
      return const Color(0xFFFFA502); // 橙色 - 警告
    } else if (progress >= 0.5) {
      return const Color(0xFFFFE138); // 黄色 - 一般
    } else {
      return const Color(0xFF2ED573); // 绿色 - 安全
    }
  }

  Color _getWarningColor(ThemeModeEnum mode) {
    switch (mode) {
      case ThemeModeEnum.coinquest:
        return const Color(0xFFFF6B35);
      case ThemeModeEnum.familyCfo:
        return const Color(0xFFE53E3E);
      case ThemeModeEnum.harmonyLedger:
        return const Color(0xFFFF6B6B);
    }
  }
}
