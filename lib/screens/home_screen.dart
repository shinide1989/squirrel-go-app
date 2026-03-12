import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/speech_service.dart';
import '../services/api_service.dart';
import '../widgets/transaction_list.dart';
import '../widgets/category_stats.dart';
import '../widgets/analysis_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final SpeechService _speechService = SpeechService();
  final TextEditingController _inputController = TextEditingController();
  int _selectedIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    if (!_isInitialized) {
      await _speechService.initialize();
      setState(() => _isInitialized = true);
    }
  }

  void _toggleSpeech() {
    if (_speechService.isListening) {
      _speechService.stopListening();
    } else {
      _speechService.startListening(
        onPartialResult: (text) {
          setState(() => _inputController.text = text);
        },
      );
    }
    setState(() {});
  }

  Future<void> _parseAndSubmit() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入内容')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final transactions = await _apiService.parseTransactions(text);
      Navigator.pop(context); // 关闭加载对话框

      if (transactions.isNotEmpty) {
        // 显示预览
        final confirmed = await _showPreview(transactions);
        if (confirmed == true) {
          // 提交
          for (var t in transactions) {
            await _apiService.createTransaction(t);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('成功添加 ${transactions.length} 条记录')),
            );
            _inputController.clear();
            // 刷新数据
            // TODO: Notify providers
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('未识别到收支记录')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('解析失败：$e')),
        );
      }
    }
  }

  Future<bool?> _showPreview(List<dynamic> transactions) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('确认收支记录'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(_getCategoryIcon(t['category'])),
                  ),
                  title: Text(t['description']),
                  subtitle: Text(t['type'] == 'INCOME' ? '收入' : '支出'),
                  trailing: Text(
                    '${t['type'] == 'INCOME" ? "+" : "-"}¥${t['amount']}',
                    style: TextStyle(
                      color: t['type'] == 'INCOME' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('确认 (${transactions.length}条)'),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String? category) {
    const icons = {
      '餐饮': '🍔', '交通': '🚗', '购物': '🛍️', '娱乐': '🎬',
      '医疗': '💊', '教育': '📚', '住房': '🏠', '工资': '💰',
      '奖金': '🧧', '投资': '📈', '其他': '💵',
    };
    return icons[category] ?? '💰';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐿️ 松鼠账本'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          TransactionList(),
          CategoryStats(),
          AnalysisPanel(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) _initializeSpeech();
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: '记录'),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: '统计'),
          NavigationDestination(icon: Icon(Icons.analytics), label: '分析'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleSpeech,
        icon: Icon(_speechService.isListening ? Icons.mic : Icons.mic_none),
        label: Text(_speechService.isListening ? '停止' : '语音'),
        backgroundColor: _speechService.isListening ? Colors.red : null,
      ),
      persistentFooterButtons: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: '输入收支，如：打车 35 元 发工资 15000',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _parseAndSubmit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _parseAndSubmit,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _speechService.stopListening();
    _inputController.dispose();
    super.dispose();
  }
}
