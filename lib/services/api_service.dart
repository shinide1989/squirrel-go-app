import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://8.152.160.123:8080/api/v1';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: 'token');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<bool> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (data['code'] == 200 && data['data'] != null) {
        await _storage.write(key: 'token', value: data['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      print('登录失败：$e');
      return false;
    }
  }

  Future<List<dynamic>> parseTransactions(String text) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/ai/parse-transactions'),
        headers: await _getHeaders(),
        body: jsonEncode({'text': text}),
      );
      final data = jsonDecode(res.body);
      if (data['code'] == 200 && data['data'] != null) {
        return data['data'];
      }
      return [];
    } catch (e) {
      print('解析失败：$e');
      return [];
    }
  }

  Future<bool> createTransaction(Map<String, dynamic> transaction) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: await _getHeaders(),
        body: jsonEncode(transaction),
      );
      final data = jsonDecode(res.body);
      return data['code'] == 200;
    } catch (e) {
      print('创建失败：$e');
      return false;
    }
  }

  Future<List<dynamic>> getTransactions() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: await _getHeaders(),
      );
      final data = jsonDecode(res.body);
      if (data['code'] == 200 && data['data'] != null) {
        return data['data'];
      }
      return [];
    } catch (e) {
      print('获取失败：$e');
      return [];
    }
  }
}

  Future<bool> register(String username, String password, String email) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: await _getHeaders(),
        body: jsonEncode({'username': username, 'password': password, 'email': email}),
      );
      final data = jsonDecode(res.body);
      if (data['code'] == 200 && data['data'] != null) {
        await _storage.write(key: 'token', value: data['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      print('注册失败：$e');
      return false;
    }
  }
