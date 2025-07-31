// lib/settings_page.dart - Kodingan final tanpa opsi Kebijakan Privasi

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'widgets/modern_appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const _ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const ModernAppBar(
        title: 'Pengaturan',
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color.fromARGB(255, 9, 57, 81).withOpacity(0.05),
              const Color.fromARGB(255, 16, 91, 16).withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Settings options
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color.fromARGB(255, 9, 57, 81)
                                  .withOpacity(0.1),
                              const Color.fromARGB(255, 16, 91, 16)
                                  .withOpacity(0.1),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 9, 57, 81),
                                    Color.fromARGB(255, 16, 91, 16),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'Pengaturan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 57, 81),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Change Password
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        subtitle: 'Ganti password akun Anda',
                        onTap: _showChangePasswordDialog,
                      ),
                      const Divider(height: 1, indent: 70, endIndent: 20),
                      // About App
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        subtitle: 'Informasi versi dan pengembang',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color.fromARGB(255, 9, 57, 81),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tentang Aplikasi',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 9, 57, 81),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KMAsset',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 9, 57, 81),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Sistem Manajemen Aset Rumah Sakit',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Versi: 1.0.0',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Pengembang: Tim IT RSKM',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '© 2025 RS Krakatau Medika',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 9, 57, 81),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 70, endIndent: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // App version
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '© 2025 RS Krakatau Medika',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hak Cipta Dilindungi',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 9, 57, 81).withOpacity(0.1),
              const Color.fromARGB(255, 16, 91, 16).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 9, 57, 81),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 9, 57, 81),
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Color.fromARGB(255, 9, 57, 81),
          size: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}

// Dialog untuk mengubah password
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password berhasil diubah!'),
          backgroundColor: const Color.fromARGB(255, 16, 91, 16),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: Color.fromARGB(255, 9, 57, 81),
          ),
          SizedBox(width: 8),
          Text(
            'Ubah Password',
            style: TextStyle(
              color: Color.fromARGB(255, 9, 57, 81),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_isCurrentPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password Saat Ini',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password saat ini harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorMaxLines: 3,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru harus diisi';
                  }
                  if (!_isPasswordValid()) {
                    return 'Password tidak memenuhi persyaratan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Requirements
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.05),
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
                    _buildRequirement('Minimal 12 karakter', _hasMinLength),
                    _buildRequirement('Huruf besar (A-Z)', _hasUppercase),
                    _buildRequirement('Huruf kecil (a-z)', _hasLowercase),
                    _buildRequirement('Angka (0-9)', _hasNumber),
                    _buildRequirement(
                        'Karakter khusus (!@#\$%^&*)', _hasSpecialChar),
                    _buildRequirement(
                        'Tidak boleh mengandung spasi', _hasNoSpaces),
                    _buildRequirement('Tidak boleh pola berurutan (abc, 123)',
                        _hasNoSequential),
                    _buildRequirement(
                        'Tidak boleh karakter berulang (aaa)', _hasNoRepeating),
                    _buildRequirement('Tidak boleh password umum/lemah',
                        _hasNoCommonPassword),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password harus diisi';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 9, 57, 81),
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ubah Password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
      ],
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
