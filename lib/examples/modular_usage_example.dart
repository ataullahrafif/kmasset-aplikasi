// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/qr_data_model.dart';
import '../services/ticket_service.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dialog.dart';

/// Contoh penggunaan struktur modular dalam aplikasi
class ModularUsageExample extends StatefulWidget {
  const ModularUsageExample({super.key});

  @override
  State<ModularUsageExample> createState() => _ModularUsageExampleState();
}

class _ModularUsageExampleState extends State<ModularUsageExample> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contoh Penggunaan Modular'),
        backgroundColor: const Color(AppConstants.primaryColorValue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contoh penggunaan CustomTextField
              CustomTextField(
                labelText: 'Username',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username harus diisi';
                  }
                  if (value.length < AppConstants.minUsernameLength) {
                    return 'Username minimal ${AppConstants.minUsernameLength} karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contoh penggunaan CustomTextField dengan obscureText
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  if (value.length < AppConstants.minPasswordLength) {
                    return 'Password minimal ${AppConstants.minPasswordLength} karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Contoh penggunaan CustomButton
              CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: _isLoading,
                icon: Icons.login,
              ),
              const SizedBox(height: 16),

              // Contoh penggunaan CustomButton dengan warna berbeda
              CustomButton(
                text: 'Demo QR Scan',
                onPressed: _handleQRScan,
                backgroundColor: Colors.orange,
                icon: Icons.qr_code_scanner,
              ),
              const SizedBox(height: 16),

              // Contoh penggunaan CustomOutlinedButton
              CustomOutlinedButton(
                text: 'Lihat Tiket',
                onPressed: _handleViewTickets,
                icon: Icons.list,
              ),
              const SizedBox(height: 24),

              // Contoh penggunaan Constants
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Aplikasi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Min Username: ${AppConstants.minUsernameLength}'),
                    const Text(
                        'Min Password: ${AppConstants.minPasswordLength}'),
                    const Text('Demo Asset: ${AppConstants.demoAssetName}'),
                    Text(
                        'Status Options: ${AppConstants.ticketStatusOptions.length}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Contoh penggunaan AuthService
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final success = await authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        // Contoh penggunaan CustomDialog
        await CustomDialog.showSuccessDialog(
          context: context,
          title: 'Login Berhasil',
          message: 'Selamat datang di aplikasi KMAsset!',
        );
      }
    } catch (e) {
      // Contoh penggunaan CustomDialog untuk error
      await CustomDialog.showErrorDialog(
        context: context,
        title: 'Login Gagal',
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Contoh penggunaan TicketService
  Future<void> _handleViewTickets() async {
    try {
      final ticketService = TicketService();
      final tickets = await ticketService.getTickets();

      // Contoh penggunaan Model
      final firstTicket = tickets.first;
      final updatedTicket = firstTicket.copyWith(status: 'Solved');

      // Contoh penggunaan CustomDialog dengan konfirmasi
      final confirmed = await CustomDialog.showConfirmationDialog(
        context: context,
        title: 'Lihat Tiket',
        message:
            'Ditemukan ${tickets.length} tiket. Tiket pertama: ${firstTicket.judul}',
        confirmText: 'Lihat Detail',
        cancelText: 'Tutup',
      );

      if (confirmed == true) {
        // Navigate to ticket detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status tiket: ${updatedTicket.status}'),
            backgroundColor: const Color(AppConstants.successColorValue),
          ),
        );
      }
    } catch (e) {
      await CustomDialog.showErrorDialog(
        context: context,
        title: 'Error',
        message: 'Gagal memuat tiket: $e',
      );
    }
  }

  // Contoh penggunaan QRData Model
  Future<void> _handleQRScan() async {
    try {
      final ticketService = TicketService();

      // Simulate QR scan
      const qrString = 'DEMO_QR_CODE_123456';
      final qrData = ticketService.parseQRData(qrString);

      // Contoh penggunaan QRData Model
      final qrModel = QRData.fromJson(qrData.toJson());

      await CustomDialog.showSuccessDialog(
        context: context,
        title: 'QR Scan Berhasil',
        message: 'Asset: ${qrModel.namaAsset}\nKategori: ${qrModel.kategori}',
      );
    } catch (e) {
      await CustomDialog.showErrorDialog(
        context: context,
        title: 'QR Scan Gagal',
        message: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

/// Contoh penggunaan dalam main.dart
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KMAsset Modular Example',
      theme: ThemeData(
        primaryColor: const Color(AppConstants.primaryColorValue),
        useMaterial3: true,
      ),
      home: const ModularUsageExample(),
    );
  }
}
*/
