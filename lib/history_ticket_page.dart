// lib/history_ticket_page.dart

// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:kmasset_aplikasi/employee_data.dart';
import 'utils/priority_utils.dart';
import 'widgets/modern_appbar.dart';

class HistoryTicketPage extends StatefulWidget {
  const HistoryTicketPage({super.key});

  @override
  State<HistoryTicketPage> createState() => _HistoryTicketPageState();
}

class _HistoryTicketPageState extends State<HistoryTicketPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // JSON data structure
  List<Map<String, dynamic>> _tickets = [];
  List<Map<String, dynamic>> _filteredTickets = [];

  // Filter variables
  String? _selectedStatus;
  String? _selectedPriority;
  // String? _selectedLocation; // Dihapus

  // Filter options
  final List<String> _statusOptions = [
    'Semua',
    'Reject',
    'Request',
    'Waiting List',
    'On Progress',
    'Solved',
    'Closed'
  ];
  final List<String> _priorityOptions = [
    'Semua',
    'Low',
    'Medium',
    'High',
    'Critical'
  ];
  // final List<String> _locationOptions = [ ... ]; // Dihapus
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    _loadTicketData();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  // Load data dari JSON dengan perulangan dan percabangan
  void _loadTicketData() {
    // JSON data yang kompleks
    const String jsonString = '''
    {
      "departments": [
        {
          "name": "Radiologi",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-001",
              "pusat_kendali": "IT Support",
              "lokasi": "Gedung A - Lantai 1",
              "judul_tiket": "Perbaikan Alat X-Ray",
              "klarifikasi_tiket": "Perbaikan Alat X-Ray Rusak",
              "deskripsi": "Alat X-Ray tidak bisa menyala sejak kemarin. Sudah dicoba restart namun tetap gagal.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM001",
              "status": "On Progress",
              "prioritas": "Medium"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-002",
              "pusat_kendali": "Logistik",
              "lokasi": "Gedung A - Lantai 2",
              "judul_tiket": "Kalibrasi Mikroskop",
              "klarifikasi_tiket": "Kalibrasi Mikroskop Laboratorium",
              "deskripsi": "Mikroskop laboratorium perlu dikalibrasi ulang untuk hasil pengamatan yang akurat.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM002",
              "status": "Solved",
              "prioritas": "Medium"
            }
          ]
        },
        {
          "name": "UGD",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-003",
              "pusat_kendali": "Keuangan",
              "lokasi": "Gedung B - Lantai 1",
              "judul_tiket": "Penggantian Lampu",
              "klarifikasi_tiket": "Penggantian Lampu Ruangan UGD",
              "deskripsi": "Lampu di ruangan UGD sudah mati selama beberapa hari. Perlu penggantian lampu baru.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM003",
              "status": "Request",
              "prioritas": "Low"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-004",
              "pusat_kendali": "Umum",
              "lokasi": "Gedung B - Lantai 2",
              "judul_tiket": "Maintenance Ventilator",
              "klarifikasi_tiket": "Maintenance Rutin Ventilator ICU",
              "deskripsi": "Ventilator ICU perlu di maintenance rutin untuk menjaga kualitas udara dan kenyamanan pasien.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM004",
              "status": "Request",
              "prioritas": "Critical"
            }
          ]
        },
        {
          "name": "Farmasi",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-005",
              "pusat_kendali": "Manajemen",
              "lokasi": "Gedung C - Lantai 1",
              "judul_tiket": "Perbaikan Kulkas",
              "klarifikasi_tiket": "Perbaikan Kulkas Penyimpanan Obat Farmasi",
              "deskripsi": "Kulkas di ruang penyimpanan obat Farmasi tidak bisa dingin. Perlu perbaikan komponen pendingin.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM005",
              "status": "Solved",
              "prioritas": "High"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-006",
              "pusat_kendali": "IT Support",
              "lokasi": "Gedung A - Lantai 1",
              "judul_tiket": "Servis Blender",
              "klarifikasi_tiket": "Servis Blender Industri Gizi",
              "deskripsi": "Blender yang digunakan untuk mencampur bahan makanan di ruang gizi perlu di servis rutin untuk menjaga kualitas produk.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM006",
              "status": "On Progress",
              "prioritas": "Medium"
            }
          ]
        },
        {
          "name": "Poli",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-007",
              "pusat_kendali": "Keuangan",
              "lokasi": "Gedung A - Lantai 2",
              "judul_tiket": "Perbaikan AC",
              "klarifikasi_tiket": "Perbaikan AC Rusak Poli Anak",
              "deskripsi": "AC di ruang poli anak tidak bisa dingin. Perlu perbaikan komponen pendingin dan filter.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM007",
              "status": "Reject",
              "prioritas": "Low"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-008",
              "pusat_kendali": "Umum",
              "lokasi": "Gedung B - Lantai 1",
              "judul_tiket": "Penggantian Lampu Operasi",
              "klarifikasi_tiket": "Penggantian Bola Lampu Operasi Bedah",
              "deskripsi": "Lampu operasi bedah perlu diganti karena sudah rusak dan tidak bisa menyala.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM008",
              "status": "Waiting List",
              "prioritas": "Critical"
            }
          ]
        },
        {
          "name": "Administrasi",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-009",
              "pusat_kendali": "Manajemen",
              "lokasi": "Gedung C - Lantai 1",
              "judul_tiket": "Perbaikan Printer",
              "klarifikasi_tiket": "Perbaikan Printer Macet Administrasi",
              "deskripsi": "Printer yang digunakan untuk mencetak laporan administrasi tidak bisa mencetak. Perlu perbaikan komponen dan ink.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM009",
              "status": "Reject",
              "prioritas": "High"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-010",
              "pusat_kendali": "Umum",
              "lokasi": "Gedung B - Lantai 2",
              "judul_tiket": "Perbaikan Lemari Pendingin",
              "klarifikasi_tiket": "Perbaikan Lemari Pendingin Kamar Mayat",
              "deskripsi": "Lemari pendingin di kamar mayat perlu di perbaiki karena tidak bisa mendinginkan kamar.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM010",
              "status": "Waiting List",
              "prioritas": "Medium"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-011",
              "pusat_kendali": "IT Support",
              "lokasi": "Gedung A - Lantai 3",
              "judul_tiket": "Perbaikan Sistem Komputer",
              "klarifikasi_tiket": "Perbaikan Sistem Komputer Administrasi",
              "deskripsi": "Sistem komputer di ruang administrasi mengalami gangguan. Perlu perbaikan hardware dan software.",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM011",
              "status": "Closed",
              "prioritas": "High"
            }
          ]
        }
      ]
    }
    ''';

    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // PERULANGAN dengan PERCABANGAN di dalamnya
      for (var department in jsonData['departments']) {
        // Percabangan: Cek apakah department memiliki tickets
        if (department['tickets'] != null && department['tickets'].isNotEmpty) {
          // Perulangan: Loop melalui setiap ticket dalam department
          for (var ticket in department['tickets']) {
            // Percabangan: Cek apakah ticket memiliki data yang valid
            if (ticket['kode_tiket'] != null && ticket['judul_tiket'] != null) {
              _tickets.add(ticket);
            }
          }
        }
      }

      // Set filtered tickets to all tickets initially
      _filteredTickets = List.from(_tickets);
    } catch (e) {
      print('Error loading ticket data: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTickets = _tickets.where((ticket) {
        // Search filter - hanya berdasarkan kode tiket
        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          matchesSearch =
              ticket['kode_tiket'].toString().toLowerCase().contains(query);
        }
        // Status filter
        bool matchesStatus = true;
        if (_selectedStatus != null && _selectedStatus != 'Semua') {
          matchesStatus = ticket['status'] == _selectedStatus;
        }
        // Priority filter
        bool matchesPriority = true;
        if (_selectedPriority != null && _selectedPriority != 'Semua') {
          matchesPriority = ticket['prioritas'] == _selectedPriority;
        }
        // Location filter dihapus
        return matchesSearch && matchesStatus && matchesPriority;
      }).toList();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedStatus = null;
      _selectedPriority = null;
      // _selectedLocation = null; // Dihapus
      _searchController.clear();
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.05),
      appBar: const ModernAppBar(
        title: 'Riwayat Tiket',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan kode tiket...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Toggle Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                          });
                        },
                        icon: Icon(_showAdvancedFilters
                            ? Icons.expand_less
                            : Icons.expand_more),
                        label: Text(_showAdvancedFilters
                            ? 'Sembunyikan Filter'
                            : 'Filter Lanjutan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _clearAllFilters,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                // Advanced Filters
                if (_showAdvancedFilters) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: _statusOptions.map((status) {
                            return DropdownMenuItem<String>(
                              value: status == 'Semua' ? null : status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Prioritas',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: _priorityOptions.map((priority) {
                            return DropdownMenuItem<String>(
                              value: priority == 'Semua' ? null : priority,
                              child: Text(priority),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  // Dropdown lokasi dihapus
                ],
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Ditemukan ${_filteredTickets.length} tiket',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 9, 57, 81),
                  ),
                ),
                const Spacer(),
                if (_filteredTickets.isNotEmpty)
                  Text(
                    'Total: ${_tickets.length} tiket',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),

          // Tickets List
          Expanded(
            child: _filteredTickets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada tiket ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba ubah kata kunci pencarian',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = _filteredTickets[index];
                      return _buildTicketCard(ticket);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final priorityColor = priorityColorMap[ticket['prioritas']] ?? Colors.grey;
    final statusColor = () {
      switch (ticket['status']) {
        case 'Reject':
          return const Color(0xFFE53935); // Merah
        case 'Request':
          return const Color(0xFF1E88E5); // Biru muda
        case 'Waiting List':
          return const Color(0xFFFF9800); // Oranye
        case 'On Progress':
          return const Color(0xFF3949AB); // Biru tua
        case 'Solved':
          return const Color(0xFF388E3C); // Hijau
        case 'Closed':
          return const Color(0xFF757575); // Abu-abu
        default:
          return Colors.grey;
      }
    }();

    return GestureDetector(
      onTap: () => _showTicketDetails(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ticket code and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket['kode_tiket'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 9, 57, 81),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      ticket['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                ticket['judul_tiket'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Details
              _buildDetailRow('Lokasi', ticket['lokasi'], Icons.location_on),
              _buildDetailRow(
                  'Tanggal', ticket['tanggal'], Icons.calendar_today),
              _buildDetailRow(
                  'Pusat Kendali', ticket['pusat_kendali'], Icons.business),

              const SizedBox(height: 12),

              // Priority
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: priorityColor),
                    ),
                    child: Text(
                      ticket['prioritas'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    final priorityColor = priorityColorMap[ticket['prioritas']] ?? Colors.grey;
    final statusColor = () {
      switch (ticket['status']) {
        case 'Reject':
          return const Color(0xFFE53935); // Merah
        case 'Request':
          return const Color(0xFF1E88E5); // Biru muda
        case 'Waiting List':
          return const Color(0xFFFF9800); // Oranye
        case 'On Progress':
          return const Color(0xFF3949AB); // Biru tua
        case 'Solved':
          return const Color(0xFF388E3C); // Hijau
        case 'Closed':
          return const Color(0xFF757575); // Abu-abu
        default:
          return Colors.grey;
      }
    }();
    final statusIcon = () {
      switch (ticket['status']) {
        case 'Reject':
          return Icons.cancel;
        case 'Request':
          return Icons.add_circle;
        case 'Waiting List':
          return Icons.schedule;
        case 'On Progress':
          return Icons.engineering;
        case 'Solved':
          return Icons.check_circle;
        case 'Closed':
          return Icons.archive;
        default:
          return Icons.info;
      }
    }();

    showDialog(
      context: context,
      builder: (context) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: isLandscape
                  ? MediaQuery.of(context).size.height * 0.9
                  : double.infinity,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.75, // Maksimal 75% tinggi layar
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 9, 57, 81)),
                  trackColor:
                      MaterialStateProperty.all(Colors.grey.withOpacity(0.15)),
                  trackBorderColor:
                      MaterialStateProperty.all(Colors.transparent),
                  radius: const Radius.circular(12),
                  thickness: MaterialStateProperty.all(8),
                  thumbVisibility: MaterialStateProperty.all(true),
                  minThumbLength: 48,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Container(
                          width: double.infinity,
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
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
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
                                  Icons.receipt,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                ticket['kode_tiket'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ticket['judul_tiket'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Status and Priority Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: statusColor),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            statusIcon,
                                            color: statusColor,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: statusColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            ticket['status'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: priorityColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            Border.all(color: priorityColor),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.priority_high,
                                            color: priorityColor,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Prioritas',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: priorityColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            ticket['prioritas'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: priorityColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Details
                              _buildDetailItem(
                                  'Nomor Tiket',
                                  ticket['nomor_tiket'],
                                  Icons.confirmation_number),
                              _buildDetailItem('Klasifikasi',
                                  ticket['klarifikasi_tiket'], Icons.category),
                              _buildDetailItem('Lokasi', ticket['lokasi'],
                                  Icons.location_on),
                              _buildDetailItem('Tanggal', ticket['tanggal'],
                                  Icons.calendar_today),
                              _buildDetailItem('Organisasi Saya',
                                  EmployeeData.organization, Icons.apartment),
                              _buildDetailItem('Pusat Kendali',
                                  ticket['pusat_kendali'], Icons.business),
                              if (ticket['deskripsi'] != null &&
                                  ticket['deskripsi'].toString().isNotEmpty)
                                _buildDetailItem('Deskripsi Masalah',
                                    ticket['deskripsi'], Icons.description),
                            ],
                          ),
                        ),

                        // Actions
                        Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: ticket['kode_tiket']));
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Kode tiket disalin ke clipboard'),
                                          backgroundColor:
                                              Color.fromARGB(255, 16, 91, 16),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(16),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.copy),
                                  label: const Text('Salin Kode'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color.fromARGB(255, 9, 57, 81),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
