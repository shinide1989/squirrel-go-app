import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _speechService = SpeechService();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _agreePrivacy = false;
  bool _agreeTerms = false;
  
  // 权限开关
  bool _allowDataSync = true;      // 数据同步
  bool _allowAnalytics = true;     // 使用分析
  bool _allowNotifications = false; // 通知提醒
  bool _allowBackup = true;        // 云端备份
  
  // 显示隐私详情
  bool _showPrivacyDetails = false;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                const Text(
                  '🐿️',
                  style: TextStyle(fontSize: 80),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // 标题
                const Text(
                  '松鼠账本',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? '欢迎回来' : '创建新账号',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // 用户名
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? '请输入用户名' : null,
                ),
                const SizedBox(height: 16),
                
                // 邮箱 (仅注册)
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => !v!.contains('@') ? '请输入有效邮箱' : null,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // 密码
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.length < 6 ? '密码至少 6 位' : null,
                ),
                const SizedBox(height: 24),
                
                // 隐私安全提示
                _buildPrivacySection(),
                const SizedBox(height: 24),
                
                // 权限开关
                _buildPermissionSection(),
                const SizedBox(height: 24),
                
                // 登录/注册按钮
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(_isLogin ? '登录' : '注册', style: const TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 切换登录/注册
                TextButton(
                  onPressed: () {
                    setState(() => _isLogin = !_isLogin);
                  },
                  child: Text(_isLogin ? '没有账号？去注册' : '已有账号？去登录'),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 隐私安全提示区域
  Widget _buildPrivacySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: Color(0xFFFF6B35), size: 20),
              const SizedBox(width: 8),
              const Text(
                '隐私与安全',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 同意隐私政策
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _agreePrivacy,
            onChanged: (v) => setState(() => _agreePrivacy = v!),
            title: const Text('我已阅读并同意'),
            subtitle: GestureDetector(
              onTap: () => _showPrivacyDetailsDialog(),
              child: const Text(
                '《隐私政策》',
                style: TextStyle(color: Color(0xFFFF6B35), decoration: TextDecoration.underline),
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          // 同意服务条款
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v!),
            title: const Text('我已阅读并同意'),
            subtitle: GestureDetector(
              onTap: () => _showTermsDialog(),
              child: const Text(
                '《服务条款》',
                style: TextStyle(color: Color(0xFFFF6B35), decoration: TextDecoration.underline),
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }
  
  // 权限开关区域
  Widget _buildPermissionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                '数据权限设置',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 数据同步
          _buildPermissionTile(
            icon: Icons.cloud_sync,
            title: '云端数据同步',
            subtitle: '自动同步您的账本数据到云端',
            value: _allowDataSync,
            onChanged: (v) => setState(() => _allowDataSync = v!),
          ),
          const Divider(),
          
          // 使用分析
          _buildPermissionTile(
            icon: Icons.analytics,
            title: '使用数据分析',
            subtitle: '帮助我们改进产品体验',
            value: _allowAnalytics,
            onChanged: (v) => setState(() => _allowAnalytics = v!),
          ),
          const Divider(),
          
          // 通知提醒
          _buildPermissionTile(
            icon: Icons.notifications,
            title: '预算预警通知',
            subtitle: '预算超支时发送提醒',
            value: _allowNotifications,
            onChanged: (v) => setState(() => _allowNotifications = v!),
          ),
          const Divider(),
          
          // 云端备份
          _buildPermissionTile(
            icon: Icons.backup,
            title: '自动备份',
            subtitle: '定期备份您的数据',
            value: _allowBackup,
            onChanged: (v) => setState(() => _allowBackup = v!),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFF6B35),
        ),
      ],
    );
  }
  
  void _showPrivacyDetailsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. 数据收集', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 我们仅收集必要的账户信息（用户名、邮箱）'),
              Text('• 您的账本数据仅存储在您指定的服务器上'),
              Text('• 不会收集您的地理位置、通讯录等敏感信息'),
              SizedBox(height: 16),
              
              Text('2. 数据使用', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 您的数据仅用于提供记账服务'),
              Text('• 不会向第三方出售或出租您的数据'),
              Text('• 仅在法律要求时配合提供数据'),
              SizedBox(height: 16),
              
              Text('3. 数据安全', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 使用 HTTPS 加密传输'),
              Text('• 密码使用 bcrypt 加密存储'),
              Text('• 定期安全审计'),
              SizedBox(height: 16),
              
              Text('4. 您的权利', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 随时查看和导出您的数据'),
              Text('• 随时删除您的账户和数据'),
              Text('• 随时更改权限设置'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('服务条款'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. 服务内容', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('松鼠账本提供免费的家庭收支管理服务'),
              SizedBox(height: 16),
              
              Text('2. 用户责任', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 保证账户信息安全'),
              Text('• 不从事违法活动'),
              Text('• 不使用自动化脚本'),
              SizedBox(height: 16),
              
              Text('3. 免责声明', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• 不保证服务 100% 可用'),
              Text('• 不对数据丢失承担责任'),
              Text('• 建议定期备份数据'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreePrivacy || !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请同意隐私政策和服务条款')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      bool success;
      if (_isLogin) {
        success = await _apiService.login(
          _usernameController.text,
          _passwordController.text,
        );
      } else {
        success = await _apiService.register(
          _usernameController.text,
          _passwordController.text,
          _emailController.text,
        );
      }
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isLogin ? '登录成功' : '注册成功')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isLogin ? '登录失败' : '注册失败')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败：$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
