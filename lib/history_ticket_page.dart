// lib/history_ticket_page.dart

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

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

  // Filter variables
  String? _selectedStatus;
  String? _selectedPriority;

  // JSON data structure
  List<Map<String, dynamic>> _tickets = [];

  // Filter options
  final List<String> _statusOptions = ['Semua', 'Pending', 'Selesai'];
  final List<String> _priorityOptions = [
    'Semua',
    'Low',
    'Medium',
    'High',
    'Critical'
  ];

  @override
  void initState() {
    super.initState();
    _loadTicketData();
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
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung A - Lantai 1",
              "judul_tiket": "Perbaikan Alat X-Ray",
              "klarifikasi_tiket": "Perbaikan Alat X-Ray Rusak",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM001",
              "status": "Pending",
              "prioritas": "Medium"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-002",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung A - Lantai 2",
              "judul_tiket": "Kalibrasi Mikroskop",
              "klarifikasi_tiket": "Kalibrasi Mikroskop Laboratorium",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM002",
              "status": "Selesai",
              "prioritas": "Medium"
            }
          ]
        },
        {
          "name": "UGD",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-003",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung B - Lantai 1",
              "judul_tiket": "Penggantian Lampu",
              "klarifikasi_tiket": "Penggantian Lampu Ruangan UGD",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM003",
              "status": "Pending",
              "prioritas": "Low"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-004",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung B - Lantai 2",
              "judul_tiket": "Maintenance Ventilator",
              "klarifikasi_tiket": "Maintenance Rutin Ventilator ICU",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM004",
              "status": "Selesai",
              "prioritas": "Critical"
            }
          ]
        },
        {
          "name": "Farmasi",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-005",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung C - Lantai 1",
              "judul_tiket": "Perbaikan Kulkas",
              "klarifikasi_tiket": "Perbaikan Kulkas Penyimpanan Obat Farmasi",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM005",
              "status": "Pending",
              "prioritas": "High"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-006",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung A - Lantai 1",
              "judul_tiket": "Servis Blender",
              "klarifikasi_tiket": "Servis Blender Industri Gizi",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM006",
              "status": "Selesai",
              "prioritas": "Medium"
            }
          ]
        },
        {
          "name": "Poli",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-007",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung A - Lantai 2",
              "judul_tiket": "Perbaikan AC",
              "klarifikasi_tiket": "Perbaikan AC Rusak Poli Anak",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM007",
              "status": "Pending",
              "prioritas": "Low"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-008",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung B - Lantai 1",
              "judul_tiket": "Penggantian Lampu Operasi",
              "klarifikasi_tiket": "Penggantian Bola Lampu Operasi Bedah",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM008",
              "status": "Selesai",
              "prioritas": "Critical"
            }
          ]
        },
        {
          "name": "Administrasi",
          "tickets": [
            {
              "nomor_tiket": "TK-RSKM-20240626-009",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung C - Lantai 1",
              "judul_tiket": "Perbaikan Printer",
              "klarifikasi_tiket": "Perbaikan Printer Macet Administrasi",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM009",
              "status": "Pending",
              "prioritas": "High"
            },
            {
              "nomor_tiket": "TK-RSKM-20240626-010",
              "pusat_kendali": "${EmployeeData.organization}",
              "lokasi": "Gedung B - Lantai 2",
              "judul_tiket": "Perbaikan Lemari Pendingin",
              "klarifikasi_tiket": "Perbaikan Lemari Pendingin Kamar Mayat",
              "tanggal": "2024-06-26",
              "kode_tiket": "RSKM010",
              "status": "Selesai",
              "prioritas": "Medium"
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
            if (ticket['nomor_tiket'] != null &&
                ticket['status'] != null &&
                ticket['prioritas'] != null) {
              // Percabangan: Validasi status ticket
              if (ticket['status'] == 'Pending' ||
                  ticket['status'] == 'Selesai') {
                // Percabangan: Validasi prioritas ticket
                if (ticket['prioritas'] == 'Low' ||
                    ticket['prioritas'] == 'Medium' ||
                    ticket['prioritas'] == 'High' ||
                    ticket['prioritas'] == 'Critical') {
                  _tickets.add(ticket);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      // Jika error parsing JSON, fallback ke data kosong
      _tickets = [];
    }
    setState(() {});
  }

  // Filter tickets berdasarkan pencarian dan filter
  List<Map<String, dynamic>> get _filteredTickets {
    List<Map<String, dynamic>> filtered = _tickets;

    // Filter berdasarkan pencarian
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((ticket) {
        return ticket['nomor_tiket'].toLowerCase().contains(query) ||
            ticket['kode_tiket'].toLowerCase().contains(query);
      }).toList();
    }

    // Filter berdasarkan status
    if (_selectedStatus != null && _selectedStatus != 'Semua') {
      filtered = filtered.where((ticket) {
        return ticket['status'] == _selectedStatus;
      }).toList();
    }

    // Filter berdasarkan prioritas
    if (_selectedPriority != null && _selectedPriority != 'Semua') {
      filtered = filtered.where((ticket) {
        return ticket['prioritas'] == _selectedPriority;
      }).toList();
    }

    // Sort berdasarkan tanggal (terbaru ke terlama)
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['tanggal']);
      final dateB = DateTime.parse(b['tanggal']);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    return priorityColorMap[priority] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernAppBar(
        title: 'Riwayat Tiket',
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 9, 57, 81),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          Column(
            children: [
              // Search and filter section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari tiket...',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    // Filter row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            dropdownColor: const Color.fromARGB(255, 9, 57, 81),
                            style: const TextStyle(color: Colors.white),
                            items: _statusOptions.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStatus = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPriority,
                            decoration: InputDecoration(
                              labelText: 'Prioritas',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            dropdownColor: const Color.fromARGB(255, 9, 57, 81),
                            style: const TextStyle(color: Colors.white),
                            items: _priorityOptions.map((String priority) {
                              return DropdownMenuItem<String>(
                                value: priority,
                                child: Text(priority),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPriority = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = null;
                              _selectedPriority = null;
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Ticket list
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _filteredTickets.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada tiket ditemukan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTickets.length,
                          itemBuilder: (context, index) {
                            final ticket = _filteredTickets[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () => _showTicketDetail(ticket),
                                borderRadius: BorderRadius.circular(15),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ticket['nomor_tiket'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 9, 57, 81),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                  ticket['status']),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              ticket['status'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        ticket['klarifikasi_tiket'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${ticket['pusat_kendali']} - ${ticket['lokasi']}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            ticket['tanggal'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getPriorityColor(
                                                  ticket['prioritas']),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              ticket['prioritas'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTicketDetail(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Color.fromARGB(255, 9, 57, 81),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Detail Tiket',
              style: TextStyle(
                color: Color.fromARGB(255, 9, 57, 81),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status dan Prioritas
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(ticket['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _getStatusColor(ticket['status'])),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(ticket['status']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ticket['status'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(ticket['status']),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(ticket['prioritas'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _getPriorityColor(ticket['prioritas'])),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Prioritas',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(ticket['prioritas']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ticket['prioritas'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _getPriorityColor(ticket['prioritas']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Judul Tiket
              _buildDetailRow('Nomor Tiket', ticket['nomor_tiket'],
                  Icons.confirmation_number),
              _buildDetailRowWithCopy(
                  'Kode Tiket', ticket['kode_tiket'], Icons.qr_code),
              _buildDetailRow(
                  'Judul Tiket', ticket['judul_tiket'], Icons.title),
              _buildDetailRow(
                  'Pusat Kendali', ticket['pusat_kendali'], Icons.apartment),
              _buildDetailRow('Lokasi', ticket['lokasi'], Icons.location_on),
              _buildDetailRow('Klarifikasi', ticket['klarifikasi_tiket'],
                  Icons.description),
              _buildDetailRow(
                  'Tanggal', ticket['tanggal'], Icons.calendar_today),
            ],
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tutup',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithCopy(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        size: 20,
                        color: Color.fromARGB(255, 9, 57, 81),
                      ),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: value));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$label disalin ke clipboard!'),
                              backgroundColor:
                                  const Color.fromARGB(255, 9, 57, 81),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      tooltip: 'Salin $label',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
