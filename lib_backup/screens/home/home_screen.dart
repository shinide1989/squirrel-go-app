import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../widgets/mascot/mascot_widget.dart';
import '../../widgets/charts/budget_progress_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('松鼠账本'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer3<ThemeProvider, TransactionProvider, BudgetProvider>(
        builder: (context, themeProvider, transactionProvider, budgetProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MascotWidget(
                  mode: themeProvider.currentMode,
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                BudgetProgressCard(
                  budgets: budgetProvider.budgets,
                  spentAmount: transactionProvider.calculateMonthlyExpense(),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('本月概览', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Icon(Icons.arrow_upward, color: Color(0xFFFA541C)),
                                  const SizedBox(height: 8),
                                  Text('支出', style: Theme.of(context).textTheme.bodyMedium),
                                  Text('¥${transactionProvider.calculateMonthlyExpense().toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFFA541C))),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: Column(
                                children: [
                                  const Icon(Icons.arrow_downward, color: Color(0xFF52C41A)),
                                  const SizedBox(height: 8),
                                  Text('收入', style: Theme.of(context).textTheme.bodyMedium),
                                  Text('¥${transactionProvider.calculateMonthlyIncome().toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF52C41A))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
