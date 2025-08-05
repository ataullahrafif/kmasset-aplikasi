// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kmasset_aplikasi/employee_data.dart';
import 'package:kmasset_aplikasi/login_page.dart';
import 'utils/network_utils.dart';
import 'widgets/modern_appbar.dart';

class ForceChangePasswordPage extends StatefulWidget {
  const ForceChangePasswordPage({super.key});

  @override
  State<ForceChangePasswordPage> createState() =>
      _ForceChangePasswordPageState();
}

class _ForceChangePasswordPageState extends State<ForceChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isOffline = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _showAllPasswords = false; // New checkbox state

  // Password validation states
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasNoSpaces = false;
  bool _hasNoSequential = false;
  bool _hasNoRepeating = false;
  bool _hasNoCommonPassword = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 12;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasNoSpaces = !password.contains(' ');
      _hasNoSequential = !_hasSequentialPattern(password);
      _hasNoRepeating = !_hasRepeatingPattern(password);
      _hasNoCommonPassword = !_isCommonPassword(password);
    });
  }

  // Update password visibility based on checkbox
  void _updatePasswordVisibility() {
    setState(() {
      _showOldPassword = _showAllPasswords;
      _showNewPassword = _showAllPasswords;
      _showConfirmPassword = _showAllPasswords;
    });
  }

  // Clear session and return to login
  void _clearSessionAndReturnToLogin() async {
    // Clear session data (simulate)
    // In real implementation, this would clear SharedPreferences or other session storage
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  // Check for sequential patterns (abc, 123, etc.)
  bool _hasSequentialPattern(String password) {
    if (password.length < 3) return false;

    for (int i = 0; i <= password.length - 3; i++) {
      String sequence = password.substring(i, i + 3);

      // Check for sequential letters (abc, def, etc.)
      if (_isSequentialLetters(sequence)) return true;

      // Check for sequential numbers (123, 456, etc.)
      if (_isSequentialNumbers(sequence)) return true;
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

  // Check for repeating patterns (aaa, 111, etc.)
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

  // Check for common/weak passwords
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
      'password1',
      '12345678',
      'qwertyuiop',
      'asdfghjkl',
      'zxcvbnm',
      '111111',
      '000000',
      '123123',
      'abcabc',
      'qweqwe',
      'password12',
      'admin1234',
      'user1234',
      'test1234',
      'demo1234',
      'password1234',
      'admin12345',
      'user12345',
      'test12345',
      'demo12345',
    ];

    return commonPasswords.contains(password.toLowerCase());
  }

  bool _isPasswordValid() {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar &&
        _hasNoSpaces &&
        _hasNoSequential &&
        _hasNoRepeating &&
        _hasNoCommonPassword;
  }

  Future<bool> _checkInternetConnection() async {
    try {
      bool hasConnectivity = await NetworkUtils.hasConnectivity();
      if (!hasConnectivity) {
        return false;
      }
      bool hasInternet = await NetworkUtils.hasInternetConnection();
      return hasInternet;
    } catch (e) {
      return false;
    }
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isOffline = false;
    });

    // Check internet connection
    bool hasInternet = await _checkInternetConnection();
    if (!hasInternet) {
      setState(() {
        _isOffline = true;
        _isLoading = false;
      });
      return;
    }

    try {
      // Simulate API call with potential failure
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response - in real implementation, this would come from your backend
      // For demo purposes, we'll simulate a 95% success rate
      bool isSuccess =
          DateTime.now().millisecondsSinceEpoch % 20 != 0; // 95% success rate

      if (isSuccess) {
        // Success case
        setState(() {
          _isLoading = false;
        });

        // Show success notification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Password berhasil diubah!',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 16, 91, 16),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );

          // Redirect to login page after a short delay
          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false,
            );
          }
        }
      } else {
        // Failure case
        setState(() {
          _isLoading = false;
        });

        // Show error notification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gagal mengubah password. Silakan coba lagi.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              action: SnackBarAction(
                label: 'Tutup',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Terjadi kesalahan: ${e.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
            action: SnackBarAction(
              label: 'Tutup',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const ModernAppBar(
        title: 'Ubah Kata Sandi',
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(255, 9, 57, 81),
                            const Color.fromARGB(255, 9, 57, 81)
                                .withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.lock_reset,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ubah Kata Sandi Wajib',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Untuk keamanan akun, Anda harus mengganti password terlebih dahulu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Password Requirements (moved above username)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 9, 57, 81)
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color.fromARGB(255, 9, 57, 81)
                                .withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Persyaratan Kata Sandi:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 9, 57, 81),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirement(
                              'Minimal 12 karakter', _hasMinLength),
                          _buildRequirement('Huruf besar (A-Z)', _hasUppercase),
                          _buildRequirement('Huruf kecil (a-z)', _hasLowercase),
                          _buildRequirement('Angka (0-9)', _hasNumber),
                          _buildRequirement(
                              'Karakter khusus (!@#\$%^&*)', _hasSpecialChar),
                          _buildRequirement(
                              'Tidak boleh mengandung spasi', _hasNoSpaces),
                          _buildRequirement(
                              'Tidak boleh pola berurutan (abc, 123)',
                              _hasNoSequential),
                          _buildRequirement(
                              'Tidak boleh karakter berulang (aaa)',
                              _hasNoRepeating),
                          _buildRequirement('Tidak boleh password umum/lemah',
                              _hasNoCommonPassword),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Username (readonly)
                    TextFormField(
                      initialValue: EmployeeData.employeeName,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Old Password
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: !_showOldPassword,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi Lama *',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showOldPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showOldPassword = !_showOldPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata sandi lama harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showNewPassword,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi Baru *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata sandi baru harus diisi';
                        }
                        if (!_isPasswordValid()) {
                          return 'Kata sandi tidak memenuhi persyaratan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password (moved below new password)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Kata Sandi Baru *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi kata sandi harus diisi';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Konfirmasi kata sandi tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Show Password Checkbox (moved below confirm password)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _showAllPasswords,
                            onChanged: (value) {
                              setState(() {
                                _showAllPasswords = value ?? false;
                              });
                              _updatePasswordVisibility();
                            },
                            activeColor: const Color.fromARGB(255, 9, 57, 81),
                          ),
                          const Text(
                            'Tampilkan Kata Sandi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit and Cancel Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : _clearSessionAndReturnToLogin,
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (_isLoading || !_isPasswordValid())
                                ? null
                                : _submitForm,
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.save, size: 20),
                            label: _isLoading
                                ? const SizedBox.shrink()
                                : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 9, 57, 81),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // No Internet Connection Error
          if (_isOffline)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tidak Ada Koneksi Internet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mohon periksa koneksi internet Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isOffline = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                                side: BorderSide(color: Colors.grey[300]!),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Kembali'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _retryConnection,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Coba Lagi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 9, 57, 81),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? const Color.fromARGB(255, 16, 91, 16) : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
