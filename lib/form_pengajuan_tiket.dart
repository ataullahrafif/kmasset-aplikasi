// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:kmasset_aplikasi/employee_data.dart';
import 'utils/network_utils.dart';
import 'widgets/modern_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Added for Timer
import 'package:kmasset_aplikasi/home_page.dart'; // Added for HomePage
import 'package:file_picker/file_picker.dart';

class FormPengajuanTiketPage extends StatefulWidget {
  const FormPengajuanTiketPage({super.key});

  @override
  State<FormPengajuanTiketPage> createState() => _FormPengajuanTiketPageState();
}

class _FormPengajuanTiketPageState extends State<FormPengajuanTiketPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulTiketController = TextEditingController();
  final TextEditingController _klasifikasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _organisasiController = TextEditingController();
  final TextEditingController _userController =
      TextEditingController(); // Ganti dari _karyawanController
  final TextEditingController _extensiController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();

  DateTime? _selectedDate;

  // Dropdown selections
  String? _selectedClassification;

  // File upload
  final List<File> _selectedImages = [];
  final List<File> _selectedPdfFiles = [];
  final ImagePicker _picker = ImagePicker();

  // Auto-save
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(seconds: 2);

  final List<Map<String, String>> _classificationOptions = [
    {'code': 'CLS001', 'name': 'Perbaikan Alat Medis'},
    {'code': 'CLS002', 'name': 'Kalibrasi Alat'},
    {'code': 'CLS003', 'name': 'Maintenance Rutin'},
    {'code': 'CLS004', 'name': 'Penggantian Spare Part'},
    {'code': 'CLS005', 'name': 'Instalasi Baru'},
  ];

  // List dummy organisasi tujuan dan variabel state untuk dropdown
  final List<Map<String, String>> _pusatKendaliOptions = [
    {'code': 'ORG001', 'name': 'IT Support'},
    {'code': 'ORG002', 'name': 'Logistik'},
    {'code': 'ORG003', 'name': 'Keuangan'},
    {'code': 'ORG004', 'name': 'Umum'},
    {'code': 'ORG005', 'name': 'Manajemen'},
  ];
  String? _selectedPusatKendali;

  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  bool _isOffline = false; // Add offline state

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadDraft();
  }

  void _initializeForm() {
    _selectedDate = DateTime.now();
    _tanggalController.text = _formatDate(_selectedDate!);
    _organisasiController.text = EmployeeData.organization;
    _userController.text = EmployeeData.employeeName;
    _selectedPusatKendali = null; // Set null agar user wajib memilih

    // Add listeners for auto-save
    _judulTiketController.addListener(_onFieldChanged);
    _deskripsiController.addListener(_onFieldChanged);
    _extensiController.addListener(_onFieldChanged);
    _nomorTeleponController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    _hasUnsavedChanges = true;
    _scheduleAutoSave();
  }

  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, _saveDraft);
  }

  // Check internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      // Check connectivity first
      bool hasConnectivity = await NetworkUtils.hasConnectivity();
      debugPrint('Form - Has connectivity: $hasConnectivity');

      if (!hasConnectivity) {
        debugPrint('Form - No connectivity detected');
        return false;
      }

      // For now, just return true if we have connectivity
      debugPrint('Form - Has connectivity, assuming internet is available');
      return true;
    } catch (e) {
      debugPrint('Form - Error checking internet connection: $e');
      return false;
    }
  }

  // Retry connection
  void _retryConnection() {
    _submitForm();
  }

  Future<void> _saveDraft() async {
    if (!_hasUnsavedChanges) return;

    // Check if there's meaningful content to save
    final hasContent = _judulTiketController.text.trim().isNotEmpty ||
        _deskripsiController.text.trim().isNotEmpty ||
        _selectedClassification != null ||
        _nomorTeleponController.text.trim().isNotEmpty;

    if (!hasContent) {
      // If no meaningful content, clear any existing draft
      await _clearDraft();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = {
        'judul': _judulTiketController.text,
        'deskripsi': _deskripsiController.text,
        'klasifikasi': _selectedClassification,
        'ekstensi': _extensiController.text,
        'nomor_telepon': _nomorTeleponController.text,
        'tanggal': _selectedDate?.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      await prefs.setString('ticket_draft', jsonEncode(draftData));
      _hasUnsavedChanges = false;

      // Show subtle indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft tersimpan'),
            duration: Duration(seconds: 1),
            backgroundColor: Color.fromARGB(255, 16, 91, 16),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      print('Error saving draft: $e');
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftString = prefs.getString('ticket_draft');

      if (draftString != null) {
        final draftData = jsonDecode(draftString);
        final draftDate = DateTime.parse(draftData['timestamp']);

        // Only load draft if it's from today
        if (draftDate.day == DateTime.now().day) {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 9, 57, 81)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.save,
                        color: Color.fromARGB(255, 9, 57, 81),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Draft Ditemukan',
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 57, 81),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Draft tiket tersimpan ditemukan dari sesi sebelumnya.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Judul: ${draftData['judul'] ?? 'Tidak ada'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Deskripsi: ${draftData['deskripsi'] ?? 'Tidak ada'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Apakah Anda ingin melanjutkan draft ini?',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _clearDraft();
                      // Reset form to initial state
                      setState(() {
                        _judulTiketController.clear();
                        _deskripsiController.clear();

                        _selectedClassification = null;
                        _extensiController.clear();
                        _nomorTeleponController.clear();
                        _selectedDate = DateTime.now();
                        _tanggalController.text = _formatDate(_selectedDate!);
                        _selectedImages.clear();
                        _selectedPdfFiles.clear();
                        _selectedPusatKendali = null; // Reset pusat kendali
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Draft telah dihapus'),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Hapus Draft',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Load draft data into form
                      setState(() {
                        _judulTiketController.text = draftData['judul'] ?? '';
                        _deskripsiController.text =
                            draftData['deskripsi'] ?? '';

                        _selectedClassification = draftData['klasifikasi'];
                        _extensiController.text = draftData['ekstensi'] ?? '';
                        _nomorTeleponController.text =
                            draftData['nomor_telepon'] ?? '';
                        if (draftData['tanggal'] != null) {
                          _selectedDate = DateTime.parse(draftData['tanggal']);
                          _tanggalController.text = _formatDate(_selectedDate!);
                        }
                        _selectedPusatKendali = _pusatKendaliOptions.any(
                                (org) =>
                                    org['code'] == draftData['pusat_kendali'])
                            ? draftData['pusat_kendali']
                            : null;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Draft dimuat'),
                            backgroundColor: Color.fromARGB(255, 16, 91, 16),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Lanjutkan Draft'),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error loading draft: $e');
    }
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('ticket_draft');
      _hasUnsavedChanges = false;
      print('Draft cleared successfully');
    } catch (e) {
      print('Error clearing draft: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        _onFieldChanged();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error mengambil foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        _onFieldChanged();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error memilih foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _onFieldChanged();
  }

  Future<void> _pickPdfFile() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur hanya tersedia di Android/iOS'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (file.path.toLowerCase().endsWith('.pdf')) {
          setState(() {
            _selectedPdfFiles.add(file);
          });
          _onFieldChanged();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hanya file PDF yang diperbolehkan!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error memilih file PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePdfFile(int index) {
    setState(() {
      _selectedPdfFiles.removeAt(index);
    });
    _onFieldChanged();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _judulTiketController.dispose();
    _klasifikasiController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    _organisasiController.dispose();
    _userController.dispose(); // Ganti dari _karyawanController.dispose();
    _extensiController.dispose();
    _nomorTeleponController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 9, 57, 81),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = _formatDate(picked);
      });
      _onFieldChanged();
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _isOffline = false; // Reset offline state
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

      // Clear draft after successful submission
      _clearDraft();

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                SizedBox(width: 8),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 16, 91, 16).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color.fromARGB(255, 16, 91, 16),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tiket Anda telah berhasil diajukan dan akan diproses oleh tim terkait.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Judul: ${_judulTiketController.text}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          // Kembali ke home page dengan tab riwayat tiket aktif
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomePage(initialIndex: 1),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Lihat Riwayat',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.05),
      appBar: const ModernAppBar(
        title: 'Pengajuan Tiket',
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header dengan gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 9, 57, 81),
                        const Color.fromARGB(255, 9, 57, 81).withOpacity(0.8),
                      ],
                    ),
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
                          Icons.add_task,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Form Pengajuan Tiket',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Isi form di bawah untuk mengajukan tiket baru',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Form content
                Container(
                  margin: const EdgeInsets.all(20),
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
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul Tiket
                          TextFormField(
                            controller: _judulTiketController,
                            decoration: InputDecoration(
                              labelText: 'Judul Tiket *',
                              hintText: 'Masukkan judul tiket',
                              prefixIcon: const Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Judul tiket harus diisi';
                              }
                              if (value.trim().length < 5) {
                                return 'Judul tiket minimal 5 karakter';
                              }
                              if (value.trim().length > 100) {
                                return 'Judul tiket maksimal 100 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // User (readonly)
                          TextFormField(
                            controller: _userController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'User',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Organisasi User (readonly)
                          TextFormField(
                            controller: _organisasiController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Organisasi User',
                              prefixIcon: const Icon(Icons.business),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Pusat Kendali (dropdown)
                          DropdownButtonFormField<String>(
                            value: _selectedPusatKendali,
                            decoration: InputDecoration(
                              labelText: 'Pusat Kendali *',
                              prefixIcon: const Icon(Icons.account_tree),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _pusatKendaliOptions.map((org) {
                              return DropdownMenuItem<String>(
                                value: org['code'],
                                child: Text(org['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPusatKendali = value;
                              });
                              _onFieldChanged();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pusat Kendali harus dipilih';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Klasifikasi
                          DropdownButtonFormField<String>(
                            value: _selectedClassification,
                            decoration: InputDecoration(
                              labelText: 'Klasifikasi *',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _classificationOptions.map((classification) {
                              return DropdownMenuItem<String>(
                                value: classification['code'],
                                child: Text(classification['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedClassification = value;
                                _klasifikasiController.text =
                                    _classificationOptions.firstWhere((item) =>
                                        item['code'] == value)['name']!;
                              });
                              _onFieldChanged();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Klasifikasi harus dipilih';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Ekstensi Telepon
                          TextFormField(
                            controller: _extensiController,
                            decoration: InputDecoration(
                              labelText: 'Ekstensi Telepon',
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(r'^\d+$').hasMatch(value)) {
                                  return 'Ekstensi harus berupa angka';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Nomor Telepon
                          TextFormField(
                            controller: _nomorTeleponController,
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon *',
                              prefixIcon: const Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon harus diisi';
                              }
                              if (!RegExp(r'^\d{10,13}$').hasMatch(
                                  value.replaceAll(RegExp(r'[^\d]'), ''))) {
                                return 'Nomor telepon harus 10-13 digit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Tanggal
                          TextFormField(
                            controller: _tanggalController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              labelText: 'Tanggal',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Deskripsi
                          TextFormField(
                            controller: _deskripsiController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi Masalah *',
                              hintText:
                                  'Jelaskan detail masalah yang ditemukan',
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Deskripsi masalah harus diisi';
                              }
                              if (value.trim().length < 10) {
                                return 'Deskripsi minimal 10 karakter';
                              }
                              if (value.trim().length > 500) {
                                return 'Deskripsi maksimal 500 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Foto Bukti
                          const Text(
                            'Unggah Foto / Document',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 9, 57, 81),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Kamera'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 9, 57, 81),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImageFromGallery,
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Galeri'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 16, 91, 16),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _pickPdfFile,
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Display selected images and PDF
                          if (_selectedImages.isNotEmpty ||
                              _selectedPdfFiles.isNotEmpty) ...[
                            const Text(
                              'File yang dipilih:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_selectedImages.isNotEmpty)
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _selectedImages[index],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            if (_selectedPdfFiles.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    _selectedPdfFiles.length, (index) {
                                  final file = _selectedPdfFiles[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.picture_as_pdf,
                                            color: Colors.red),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            file.path.split('/').last,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red, size: 18),
                                          onPressed: () =>
                                              _removePdfFile(index),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            const SizedBox(height: 16),
                          ],

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 9, 57, 81),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Ajukan Tiket',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 9, 57, 81)),
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 18),
                    Text(
                      'Mengirim tiket...',
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 57, 81),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isOffline)
            Container(
              color: Colors.black.withOpacity(0.3),
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
    );
  }
}
