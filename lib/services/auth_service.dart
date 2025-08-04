import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/network_utils.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      // Check internet connection
      bool hasInternet = await NetworkUtils.hasInternetConnection();
      if (!hasInternet) {
        throw Exception(AppConstants.networkErrorMessage);
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Demo validation
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username dan password harus diisi');
      }

      if (username.length < AppConstants.minUsernameLength) {
        throw Exception(
            'Username minimal ${AppConstants.minUsernameLength} karakter');
      }

      if (password.length < AppConstants.minPasswordLength) {
        throw Exception(
            'Password minimal ${AppConstants.minPasswordLength} karakter');
      }

      // Save user data to local storage
      await _saveUserData(username);

      return true;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // Check internet connection
      bool hasInternet = await NetworkUtils.hasInternetConnection();
      if (!hasInternet) {
        throw Exception(AppConstants.networkErrorMessage);
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Validate old password (demo: any non-empty password is valid)
      if (oldPassword.isEmpty) {
        throw Exception('Password lama harus diisi');
      }

      // Validate new password
      if (!_isPasswordValid(newPassword)) {
        throw Exception('Password baru tidak memenuhi persyaratan');
      }

      return true;
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  // Check if user needs to force change password
  bool needsForceChangePassword(String username) {
    return AppConstants.demoUsernames.contains(username.toLowerCase());
  }

  // Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get current username
  Future<String?> getCurrentUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username');
    } catch (e) {
      return null;
    }
  }

  // Password validation
  bool _isPasswordValid(String password) {
    if (password.length < AppConstants.minPasswordLength) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    if (password.contains(' ')) return false;
    if (_hasSequentialPattern(password)) return false;
    if (_hasRepeatingPattern(password)) return false;
    if (_isCommonPassword(password)) return false;
    return true;
  }

  // Check for sequential patterns
  bool _hasSequentialPattern(String password) {
    if (password.length < 3) return false;
    for (int i = 0; i <= password.length - 3; i++) {
      String sequence = password.substring(i, i + 3);
      if (_isSequentialLetters(sequence) || _isSequentialNumbers(sequence)) {
        return true;
      }
    }
    return false;
  }

  bool _isSequentialLetters(String sequence) {
    if (sequence.length != 3) return false;
    if (!RegExp(r'^[a-zA-Z]{3}$').hasMatch(sequence)) return false;
    String lower = sequence.toLowerCase();
    return (lower.codeUnitAt(1) == lower.codeUnitAt(0) + 1 &&
        lower.codeUnitAt(2) == lower.codeUnitAt(1) + 1);
  }

  bool _isSequentialNumbers(String sequence) {
    if (sequence.length != 3) return false;
    if (!RegExp(r'^[0-9]{3}$').hasMatch(sequence)) return false;
    return (sequence.codeUnitAt(1) == sequence.codeUnitAt(0) + 1 &&
        sequence.codeUnitAt(2) == sequence.codeUnitAt(1) + 1);
  }

  // Check for repeating patterns
  bool _hasRepeatingPattern(String password) {
    if (password.length < 3) return false;
    for (int i = 0; i <= password.length - 3; i++) {
      String pattern = password.substring(i, i + 3);
      if (pattern[0] == pattern[1] && pattern[1] == pattern[2]) {
        return true;
      }
    }
    return false;
  }

  // Check for common passwords
  bool _isCommonPassword(String password) {
    List<String> commonPasswords = [
      'password',
      '123456',
      '123456789',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      'dragon',
      'master',
      'sunshine',
      'princess',
      'qwerty123',
      'admin123',
      'user123',
      'test123',
      'demo123',
      'guest123',
    ];
    return commonPasswords.contains(password.toLowerCase());
  }
}
