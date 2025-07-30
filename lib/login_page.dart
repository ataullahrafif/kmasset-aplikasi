// lib/login_page.dart

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kmasset_aplikasi/home_page.dart';
import 'utils/device_utils.dart';
import 'utils/logo_utils.dart';
import 'utils/network_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isOffline = false; // Add offline state

  String? _usernameErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();

    // Set orientasi berdasarkan device type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeviceUtils.setOrientation(context);
    });
  }

  // Check internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      // Check connectivity first
      bool hasConnectivity = await NetworkUtils.hasConnectivity();
      debugPrint('Login - Has connectivity: $hasConnectivity');

      if (!hasConnectivity) {
        debugPrint('Login - No connectivity detected');
        return false;
      }

      // For now, just return true if we have connectivity
      debugPrint('Login - Has connectivity, assuming internet is available');
      return true;
    } catch (e) {
      debugPrint('Login - Error checking internet connection: $e');
      return false;
    }
  }

  // Retry connection
  void _retryConnection() {
    _login();
  }

  void _login() async {
    // Reset pesan error sebelum validasi
    setState(() {
      _usernameErrorText = null;
      _passwordErrorText = null;
      _isOffline = false; // Reset offline state
    });

    // Validasi input
    bool isValid = true;

    if (_usernameController.text.length < 5) {
      setState(() {
        _usernameErrorText = 'Username minimal 5 karakter';
      });
      isValid = false;
    }

    if (_passwordController.text.length < 12) {
      setState(() {
        _passwordErrorText = 'Password minimal 12 karakter';
      });
      isValid = false;
    } else if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_\-\.,:;\^%\$\(\)\[\]\{\}]).{12,}$')
        .hasMatch(_passwordController.text)) {
      setState(() {
        _passwordErrorText =
            'Password harus kombinasi huruf besar, kecil, angka, dan karakter spesial';
      });
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Check internet connection first
    bool hasInternet = await _checkInternetConnection();

    if (!hasInternet) {
      setState(() {
        _isOffline = true;
        _isLoading = false;
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Simulasi login: jika username dan password valid format, izinkan login
    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 9, 57, 81),
              const Color.fromARGB(255, 9, 57, 81).withOpacity(0.8),
              const Color.fromARGB(255, 16, 91, 16).withOpacity(0.9),
              const Color.fromARGB(255, 16, 91, 16),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      LogoUtils.buildLoginLogo(context),

                      const SizedBox(height: 50),

                      // Login form
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Welcome text
                              Text(
                                'Selamat Datang di KMAsset',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      (MediaQuery.of(context).size.width > 600
                                          ? 0.055
                                          : 0.06),
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 9, 57, 81),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Silakan masuk ke akun Anda',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      (MediaQuery.of(context).size.width > 600
                                          ? 0.035
                                          : 0.04),
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Username field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    hintText: 'Masukkan username Anda',
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 9, 57, 81)
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline,
                                        color: Color.fromARGB(255, 9, 57, 81),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    errorText: _usernameErrorText,
                                    errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length < 5) {
                                        _usernameErrorText =
                                            'Username minimal 5 karakter';
                                      } else {
                                        _usernameErrorText = null;
                                      }
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Password field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color.fromARGB(255, 9, 57, 81),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color.fromARGB(
                                            255, 9, 57, 81),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    errorText: _passwordErrorText,
                                    errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                    errorMaxLines: 3,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length < 12) {
                                        _passwordErrorText =
                                            'Password minimal 12 karakter';
                                      } else if (!RegExp(
                                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_\-\.,:;\^%\$\(\)\[\]\{\}]).{12,}$')
                                          .hasMatch(value)) {
                                        _passwordErrorText =
                                            'Password harus kombinasi huruf besar, kecil, angka, dan karakter spesial';
                                      } else {
                                        _passwordErrorText = null;
                                      }
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Login button
                              _isLoading
                                  ? Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 9, 57, 81),
                                            Color.fromARGB(255, 16, 91, 16),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 9, 57, 81),
                                            Color.fromARGB(255, 16, 91, 16),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 9, 57, 81)
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _login,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: const Center(
                                            child: Text(
                                              'Masuk',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Column(
                        children: [
                          Text(
                            '© 2025 RS Krakatau Medika',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hak Cipta Dilindungi',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Offline error overlay
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
                        // Icon
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

                        // Title
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

                        // Description
                        Text(
                          'Mohon periksa koneksi internet Anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Action Buttons
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
      ),
    );
  }
}
