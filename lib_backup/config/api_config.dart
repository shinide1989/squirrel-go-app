/// API 配置
class ApiConfig {
  // 开发环境
  static const String baseUrl = 'http://localhost:8080/api/v1';
  
  // 生产环境
  // static const String baseUrl = 'https://api.squirrelgo.com/api/v1';
  
  // 超时时间（毫秒）
  static const int timeout = 30000;
  
  // 分页大小
  static const int defaultPageSize = 20;
}
