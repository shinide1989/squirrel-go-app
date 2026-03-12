import 'package:flutter/material.dart';
import 'theme_mode_enum.dart';

/// 应用主题配置 - 支持三种产品模式
class AppThemes {
  
  /// 趣玩派主题 (CoinQuest) - 游戏化养成风格
  static ThemeData get coinquestTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFF6B35),
      scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      fontFamily: 'RoundedMplus',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF6B35),
        secondary: Color(0xFFF7C548),
        tertiary: Color(0xFF4ECDC4),
        error: Color(0xFFFF4757),
        surface: Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFFF6B35),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF7C548).withOpacity(0.3),
        selectedColor: const Color(0xFFF7C548),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// 极客派主题 (Family CFO) - 专业化智管风格
  static ThemeData get familyCfoTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1E3A5F),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E3A5F),
        secondary: Color(0xFF2C5282),
        tertiary: Color(0xFF4299E1),
        error: Color(0xFFE53E3E),
        surface: Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF1E3A5F),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C5282).withOpacity(0.2),
        selectedColor: const Color(0xFF2C5282),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// 温情派主题 (Harmony Ledger) - 家庭协作型风格
  static ThemeData get harmonyLedgerTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFF5E6D3),
      scaffoldBackgroundColor: const Color(0xFFFFFBF7),
      fontFamily: 'Noto Sans SC',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD4A574),
        secondary: Color(0xFFFF8B94),
        tertiary: Color(0xFFFFB7B2),
        error: Color(0xFFFF6B6B),
        surface: Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFD4A574),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF8B94),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFD4A574),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFF8B94).withOpacity(0.2),
        selectedColor: const Color(0xFFFF8B94),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// 根据模式获取主题
  static ThemeData getTheme(ThemeModeEnum mode) {
    switch (mode) {
      case ThemeModeEnum.coinquest:
        return coinquestTheme;
      case ThemeModeEnum.familyCfo:
        return familyCfoTheme;
      case ThemeModeEnum.harmonyLedger:
        return harmonyLedgerTheme;
    }
  }
}
