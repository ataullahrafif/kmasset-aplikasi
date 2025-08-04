import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket_model.dart';
import '../models/qr_data_model.dart';
import '../constants/app_constants.dart';
import '../utils/network_utils.dart';

class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  // Get tickets from local storage (for demo)
  Future<List<Ticket>> getTickets() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Return dummy data for demo
      return _getDummyTickets();
    } catch (e) {
      throw Exception('Failed to load tickets: $e');
    }
  }

  // Submit new ticket
  Future<bool> submitTicket(Ticket ticket) async {
    try {
      // Check internet connection
      bool hasInternet = await NetworkUtils.hasInternetConnection();
      if (!hasInternet) {
        throw Exception(AppConstants.networkErrorMessage);
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Clear draft after successful submission
      await _clearDraft();

      return true;
    } catch (e) {
      throw Exception('Failed to submit ticket: $e');
    }
  }

  // Parse QR data
  QRData parseQRData(String qrData) {
    try {
      // For demo purposes, create sample data
      return QRData(
        kodeAsset:
            'AST-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        namaAsset: AppConstants.demoAssetName,
        kategori: AppConstants.demoAssetCategory,
        rawData: qrData,
      );
    } catch (e) {
      // If parsing fails, return basic data
      return QRData(
        kodeAsset: 'N/A',
        namaAsset: 'N/A',
        kategori: 'N/A',
        rawData: qrData,
      );
    }
  }

  // Save draft ticket
  Future<void> saveDraft(Map<String, dynamic> draftData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.ticketDraftKey, jsonEncode(draftData));
    } catch (e) {
      throw Exception('Failed to save draft: $e');
    }
  }

  // Load draft ticket
  Future<Map<String, dynamic>?> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftString = prefs.getString(AppConstants.ticketDraftKey);
      if (draftString != null) {
        return jsonDecode(draftString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load draft: $e');
    }
  }

  // Clear draft ticket
  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.ticketDraftKey);
    } catch (e) {
      throw Exception('Failed to clear draft: $e');
    }
  }

  // Get classification options
  List<Map<String, String>> getClassificationOptions() {
    return AppConstants.classificationOptions;
  }

  // Get organization options
  List<Map<String, String>> getOrganizationOptions() {
    return AppConstants.organizationOptions;
  }

  // Get status options
  List<String> getStatusOptions() {
    return AppConstants.ticketStatusOptions;
  }

  // Filter tickets by status and search query
  List<Ticket> filterTickets(
      List<Ticket> tickets, String status, String searchQuery) {
    List<Ticket> filteredTickets = tickets;

    // Filter by status
    if (status != 'Semua') {
      filteredTickets =
          filteredTickets.where((ticket) => ticket.status == status).toList();
    }

    // Filter by search query (kode tiket only)
    if (searchQuery.isNotEmpty) {
      filteredTickets = filteredTickets
          .where((ticket) => ticket.kodeTiket
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredTickets;
  }

  // Get dummy tickets for demo
  List<Ticket> _getDummyTickets() {
    return [
      Ticket(
        id: '1',
        kodeTiket: 'TKT-2024-001',
        judul: 'Pengajuan Tiket - Laptop Dell Latitude 5520',
        deskripsi: 'Laptop tidak bisa menyala, layar hitam total',
        klasifikasi: 'CLS003',
        pusatKendali: 'ORG001',
        status: 'On Progress',
        tanggal: DateTime.now().subtract(const Duration(days: 2)),
        ekstensi: '123',
        nomorTelepon: '081234567890',
      ),
      Ticket(
        id: '2',
        kodeTiket: 'TKT-2024-002',
        judul: 'Pengajuan Tiket - Printer HP LaserJet',
        deskripsi: 'Printer sering macet saat print',
        klasifikasi: 'CLS001',
        pusatKendali: 'ORG002',
        status: 'Solved',
        tanggal: DateTime.now().subtract(const Duration(days: 5)),
        ekstensi: '456',
        nomorTelepon: '081234567891',
      ),
      Ticket(
        id: '3',
        kodeTiket: 'TKT-2024-003',
        judul: 'Pengajuan Tiket - Monitor LG 24"',
        deskripsi: 'Monitor bergaris-garis vertikal',
        klasifikasi: 'CLS004',
        pusatKendali: 'ORG001',
        status: 'Waiting List',
        tanggal: DateTime.now().subtract(const Duration(days: 1)),
        ekstensi: '789',
        nomorTelepon: '081234567892',
      ),
      Ticket(
        id: '4',
        kodeTiket: 'TKT-2024-004',
        judul: 'Pengajuan Tiket - AC Daikin',
        deskripsi: 'AC tidak dingin, perlu service',
        klasifikasi: 'CLS003',
        pusatKendali: 'ORG004',
        status: 'Closed',
        tanggal: DateTime.now().subtract(const Duration(days: 10)),
        ekstensi: '012',
        nomorTelepon: '081234567893',
      ),
      Ticket(
        id: '5',
        kodeTiket: 'TKT-2024-005',
        judul: 'Pengajuan Tiket - Scanner Canon',
        deskripsi: 'Scanner tidak terdeteksi di komputer',
        klasifikasi: 'CLS001',
        pusatKendali: 'ORG002',
        status: 'Request',
        tanggal: DateTime.now().subtract(const Duration(hours: 6)),
        ekstensi: '345',
        nomorTelepon: '081234567894',
      ),
    ];
  }
}
