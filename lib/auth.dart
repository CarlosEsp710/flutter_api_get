import 'package:flutter/cupertino.dart';
import 'package:flutter_get_api/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    final response = await http.post('$API_URL/api/auth/login', body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  logout() async {
    _isAuthenticated = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
