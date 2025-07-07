// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kmasset_aplikasi/employee_data.dart';
import 'utils/priority_utils.dart';
import 'widgets/modern_appbar.dart';

class FormPengajuanTiketPage extends StatefulWidget {
  const FormPengajuanTiketPage({super.key});

  @override
  State<FormPengajuanTiketPage> createState() => _FormPengajuanTiketPageState();
}

class _FormPengajuanTiketPageState extends State<FormPengajuanTiketPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kodeTiketController = TextEditingController();
  final TextEditingController _judulTiketController = TextEditingController();
  final TextEditingController _klasifikasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _organisasiController = TextEditingController();
  final TextEditingController _karyawanController = TextEditingController();

  DateTime? _selectedDate;
  static const int _ticketCounter =
      11; // Mulai dari 11 karena sudah ada 10 tiket di riwayat

  // Priority selection
  String? _selectedPriority = 'Medium';

  // Dropdown selections
  String? _selectedLocation;
  String? _selectedClassification;

  // Dropdown options
  final List<Map<String, String>> _locationOptions = [
    {'code': 'LOC001', 'name': 'Gedung A - Lantai 1'},
    {'code': 'LOC002', 'name': 'Gedung A - Lantai 2'},
    {'code': 'LOC003', 'name': 'Gedung B - Lantai 1'},
    {'code': 'LOC004', 'name': 'Gedung B - Lantai 2'},
    {'code': 'LOC005', 'name': 'Gedung C - Lantai 1'},
  ];

  final List<Map<String, String>> _classificationOptions = [
    {'code': 'CLS001', 'name': 'Perbaikan Alat Medis'},
    {'code': 'CLS002', 'name': 'Kalibrasi Alat'},
    {'code': 'CLS003', 'name': 'Maintenance Rutin'},
    {'code': 'CLS004', 'name': 'Penggantian Spare Part'},
    {'code': 'CLS005', 'name': 'Instalasi Baru'},
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Generate kode tiket sesuai format RSKM
    _kodeTiketController.text =
        'RSKM${_ticketCounter.toString().padLeft(3, '0')}';
    _selectedDate = DateTime.now();
    _tanggalController.text = _formatDate(_selectedDate!);

    // Set Organisasi berdasarkan sesi user (dari home page)
    _organisasiController.text = EmployeeData.organization;
    // Set Karyawan berdasarkan sesi user
    _karyawanController.text = EmployeeData.employeeName;
  }

  @override
  void dispose() {
    _kodeTiketController.dispose();
    _judulTiketController.dispose();
    _klasifikasiController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    _organisasiController.dispose();
    _karyawanController.dispose();
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
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Show success dialog (modern popup)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                // Icon(
                //   Icons.check_circle_outline,
                //   color: Color.fromARGB(255, 16, 91, 16),
                // ),
                SizedBox(width: 8),
                // Tidak ada teks judul
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
                              'Kode Tiket: ${_kodeTiketController.text}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 57, 81),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            const SizedBox(height: 4),
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
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                          'OK',
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
                          // Kode Tiket (readonly)
                          TextFormField(
                            controller: _kodeTiketController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Kode Tiket',
                              prefixIcon: const Icon(Icons.receipt),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Judul Tiket
                          TextFormField(
                            controller: _judulTiketController,
                            decoration: InputDecoration(
                              labelText: 'Judul Tiket',
                              hintText: 'Masukkan judul tiket',
                              prefixIcon: const Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Judul tiket harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Karyawan (readonly)
                          TextFormField(
                            controller: _karyawanController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Karyawan',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Organisasi (readonly)
                          TextFormField(
                            controller: _organisasiController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Pusat Kendali',
                              prefixIcon: const Icon(Icons.business),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Klasifikasi
                          DropdownButtonFormField<String>(
                            value: _selectedClassification,
                            decoration: InputDecoration(
                              labelText: 'Klasifikasi',
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
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Klasifikasi harus dipilih';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Lokasi
                          DropdownButtonFormField<String>(
                            value: _selectedLocation,
                            decoration: InputDecoration(
                              labelText: 'Lokasi',
                              prefixIcon: const Icon(Icons.location_on),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _locationOptions.map((location) {
                              return DropdownMenuItem<String>(
                                value: location['code'],
                                child: Text(location['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasi harus dipilih';
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

                          // Prioritas
                          const Text(
                            'Prioritas',
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
                                child: _buildPriorityChip(
                                    'Low', priorityColorMap['Low']!),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildPriorityChip(
                                    'Medium', priorityColorMap['Medium']!),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildPriorityChip(
                                    'High', priorityColorMap['High']!),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildPriorityChip(
                                    'Critical', priorityColorMap['Critical']!),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Deskripsi
                          TextFormField(
                            controller: _deskripsiController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi Masalah',
                              hintText:
                                  'Jelaskan detail masalah yang ditemukan',
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Deskripsi masalah harus diisi';
                              }
                              return null;
                            },
                          ),
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
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority, Color color) {
    final isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
          ),
        ),
        child: Text(
          priority,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
