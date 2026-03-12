import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// API 服务 - 封装所有后端接口调用
class ApiService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// 获取认证 Token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// 保存认证 Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// 清除 Token
  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// 通用请求头
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// 用户注册
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    return _handleResponse(response);
  }

  /// 用户登录
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/user/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = _handleResponse(response);
    if (data['token'] != null) {
      await saveToken(data['token']);
    }
    return data;
  }

  /// 获取用户信息
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/user/profile'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  /// 更新用户信息
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('${ApiConfig.baseUrl}/user/profile'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// 获取交易列表
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int size = 20,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/transactions').replace(
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
        if (type != null) 'type': type,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );

    final response = await _client.get(
      uri,
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  /// 创建交易
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/transactions'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// 更新交易
  Future<Map<String, dynamic>> updateTransaction(int id, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('${ApiConfig.baseUrl}/transactions/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// 删除交易
  Future<void> deleteTransaction(int id) async {
    final response = await _client.delete(
      Uri.parse('${ApiConfig.baseUrl}/transactions/$id'),
      headers: await _getHeaders(),
    );
    _handleResponse(response);
  }

  /// 获取预算列表
  Future<Map<String, dynamic>> getBudgets() async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/budgets'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  /// 创建预算
  Future<Map<String, dynamic>> createBudget(Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/budgets'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// 获取预算进度
  Future<Map<String, dynamic>> getBudgetProgress() async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/budgets/progress'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  /// AI 智能分类
  Future<Map<String, dynamic>> aiCategorize({
    required String description,
    required double amount,
    required String type,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/ai/categorize'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'description': description,
        'amount': amount,
        'type': type,
      }),
    );
    return _handleResponse(response);
  }

  /// 获取 AI 分析建议
  Future<Map<String, dynamic>> getAiSuggestions() async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/ai/suggestions'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  /// 通用响应处理
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      String message = '请求失败';
      try {
        final data = jsonDecode(response.body);
        message = data['message'] ?? message;
      } catch (e) {
        // Ignore parse error
      }
      throw ApiException(message, response.statusCode);
    }
  }

  /// 关闭客户端
  void dispose() {
    _client.close();
  }
}

/// API 异常
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() {
    return 'ApiException: $message (status: $statusCode)';
  }
}
