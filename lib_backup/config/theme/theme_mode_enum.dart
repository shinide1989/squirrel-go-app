/// 主题模式枚举
enum ThemeModeEnum {
  coinquest,      // 趣玩派
  familyCfo,      // 极客派
  harmonyLedger,  // 温情派
}

/// 主题模式扩展 - 显示名称和吉祥物
extension ThemeModeExtension on ThemeModeEnum {
  String get displayName {
    switch (this) {
      case ThemeModeEnum.coinquest:
        return '趣玩派';
      case ThemeModeEnum.familyCfo:
        return '极客派';
      case ThemeModeEnum.harmonyLedger:
        return '温情派';
    }
  }

  String get mascotName {
    switch (this) {
      case ThemeModeEnum.coinquest:
        return '栗栗';
      case ThemeModeEnum.familyCfo:
        return '零号';
      case ThemeModeEnum.harmonyLedger:
        return '暖暖';
    }
  }

  String get description {
    switch (this) {
      case ThemeModeEnum.coinquest:
        return '游戏化养成，记账即冒险';
      case ThemeModeEnum.familyCfo:
        return '专业智管，数据驱动决策';
      case ThemeModeEnum.harmonyLedger:
        return '家庭协作，共创美好未来';
    }
  }
}
