import 'package:flutter/material.dart';

/// 用户数据模型
class User {
  final int? id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String themeMode;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.themeMode = 'COINQUEST',
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      themeMode: json['theme_mode'] ?? 'COINQUEST',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'theme_mode': themeMode,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// 用户状态 Provider
class UserProvider extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null && _token != null;

  /// 设置当前用户
  void setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  /// 设置认证 Token
  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  /// 设置加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 登出
  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }
}
