import 'package:flutter/material.dart';
import '../config/theme/theme_mode_enum.dart';

/// 主题状态管理 Provider
class ThemeProvider extends ChangeNotifier {
  ThemeModeEnum _currentMode = ThemeModeEnum.coinquest;

  ThemeModeEnum get currentMode => _currentMode;

  String get mascotName => _currentMode.mascotName;

  /// 切换主题模式
  void setThemeMode(ThemeModeEnum mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      notifyListeners();
    }
  }

  /// 获取当前模式的诙谐预警文案
  String getWarningMessage(double progress, WarningType type) {
    switch (_currentMode) {
      case ThemeModeEnum.coinquest:
        return _getCoinquestWarning(progress, type);
      case ThemeModeEnum.familyCfo:
        return _getFamilyCfoWarning(progress, type);
      case ThemeModeEnum.harmonyLedger:
        return _getHarmonyLedgerWarning(progress, type);
    }
  }

  /// 趣玩派 - 毒舌吐槽风格
  String _getCoinquestWarning(double progress, WarningType type) {
    if (type == WarningType.threshold80) {
      const messages = [
        '哎哟！预算只剩两成血了！再花小松鼠要绝食抗议啦！',
        '警告！钱包君正在掉血！主人你是打算吃土吗？',
        '喵呜～金坚果快要被啃光啦！快停下！',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    } else if (type == WarningType.overBudget) {
      const messages = [
        '警报！钱包君已晕倒！要卖肾还是吃土？',
        '超支啦！小松鼠的存粮告急，你看着办吧！',
        '完了完了，这个月要喝西北风了！',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    }
    return '';
  }

  /// 极客派 - 专业幽默风格
  String _getFamilyCfoWarning(double progress, WarningType type) {
    if (type == WarningType.threshold80) {
      const messages = [
        'CFO 提示：预算进度 80%。按此速度，月底需削减非必要支出。',
        '数据预警：现金流偏离预测值。建议启动「冷静期」协议。',
        '风险提示：继续当前消费模式将导致月度赤字。',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    } else if (type == WarningType.overBudget) {
      const messages = [
        '红色预警：预算已超支。这是在向未来的自己借高利贷！',
        '严重偏离：实际支出超出预测模型。需立即调整消费策略。',
        '财务告急：建议重新评估资产配置方案。',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    }
    return '';
  }

  /// 温情派 - 家庭温暖风格
  String _getHarmonyLedgerWarning(double progress, WarningType type) {
    if (type == WarningType.threshold80) {
      const messages = [
        '爸爸妈妈，小金库漏水啦！为了宝宝的梦想，我们要加油哦～',
        '亲爱的家人们，预算快用完啦！接下来我们一起省着点花吧～',
        '暖暖提醒：距离本月结束还有几天，我们要合理分配剩余预算哦～',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    } else if (type == WarningType.overBudget) {
      const messages = [
        '紧急呼叫！预算用完啦！接下来请大厨们展现真正的技术（在家做饭）吧！',
        '家人们，超支啦！不过没关系，我们一起努力，下月一定会更好的～',
        '小金库告急！但是暖暖相信，只要我们齐心协力，一定能渡过难关！',
      ];
      return messages[DateTime.now().millisecond % messages.length];
    }
    return '';
  }
}

/// 预警类型
enum WarningType {
  threshold80,    // 达到 80% 阈值
  overBudget,     // 超支
  lowBudget,      // 预算不足
}
