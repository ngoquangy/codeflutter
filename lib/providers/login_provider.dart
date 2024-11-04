import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constant/apilist.dart';
import '../models/profile.dart';

// Định nghĩa trạng thái cho quá trình đăng nhập
enum LoginStatus { initial, loading, success, error }

// Provider để quản lý trạng thái đăng nhập
class LoginNotifier extends StateNotifier<LoginStatus> {
  LoginNotifier() : super(LoginStatus.initial);

  Future<void> login(String email, String password) async {
    state = LoginStatus.loading;
    final url = Uri.parse(api_login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('RESPONSE CODE: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Giả sử API trả về token trong response
        String token = data['token']['token']; // Đảm bảo biến token được định nghĩa
        Profile initialProfile = Profile(
            phone: data['user']['phone'],
            full_name: data['user']['full_name'],
            address: data['user']['address'],
            photo: data['user']['photo']);
        
        // Lưu token hoặc thực hiện các tác vụ khác tại đây
        state = LoginStatus.success;
        print('Login successful: $initialProfile');
      } else {
        state = LoginStatus.error;
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      state = LoginStatus.error;
      print('Error: $error');
    }
  }
}

// Khởi tạo provider cho việc đăng nhập
final loginProvider = StateNotifierProvider<LoginNotifier, LoginStatus>((ref) {
  return LoginNotifier();
});
