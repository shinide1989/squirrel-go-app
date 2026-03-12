import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme/theme_mode_enum.dart';

/// 吉祥物组件 - 根据主题模式显示不同 IP
class MascotWidget extends StatelessWidget {
  final ThemeModeEnum mode;
  final VoidCallback? onTap;

  const MascotWidget({
    super.key,
    required this.mode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            _buildMascotAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getMascotName(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getMascotGreeting(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chat_bubble_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildMascotAvatar() {
    switch (mode) {
      case ThemeModeEnum.coinquest:
        return _buildCoinquestAvatar();
      case ThemeModeEnum.familyCfo:
        return _buildFamilyCfoAvatar();
      case ThemeModeEnum.harmonyLedger:
        return _buildHarmonyLedgerAvatar();
    }
  }

  Widget _buildCoinquestAvatar() {
    // 趣玩派 - 松鼠栗栗
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(
        Icons.pets,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildFamilyCfoAvatar() {
    // 极客派 - AI 零号
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF4299E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildHarmonyLedgerAvatar() {
    // 温情派 - 灯笼暖暖
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF8B94),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(
        Icons.lightbulb,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (mode) {
      case ThemeModeEnum.coinquest:
        return const Color(0xFFFFF3E0);
      case ThemeModeEnum.familyCfo:
        return const Color(0xFFE3F2FD);
      case ThemeModeEnum.harmonyLedger:
        return const Color(0xFFFFF0F5);
    }
  }

  String _getMascotName() {
    return mode.mascotName;
  }

  String _getMascotGreeting() {
    switch (mode) {
      case ThemeModeEnum.coinquest:
        return '今天也要好好记账哦！';
      case ThemeModeEnum.familyCfo:
        return '资产状况良好，继续保持';
      case ThemeModeEnum.harmonyLedger:
        return '全家一起向梦想出发！';
    }
  }
}
