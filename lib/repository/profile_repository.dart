import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/apilist.dart';
import '../models/profile.dart';

class ProfileRepository {
  final String apiUrl = api_updateprofile; // URL của API

  Future<bool> updateProfile(Profile profile) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token, // Nếu có token
        },
        body: jsonEncode(profile.toJson()),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return true; // Cập nhật thành công
      } else {
        print('Failed to update profile: ${response.body}');
        return false; // Thất bại
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
