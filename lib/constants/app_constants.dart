class AppConstants {
  // Colors
  static const int primaryColorValue = 0xFF093951;
  static const int successColorValue = 0xFF105B10;
  static const int errorColorValue = 0xFFD32F2F;
  static const int warningColorValue = 0xFFFFA000;

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String ticketsEndpoint = '/tickets';
  static const String qrScanEndpoint = '/qr/scan';

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String ticketDraftKey = 'ticket_draft';
  static const String rememberMeKey = 'remember_me';

  // Validation Rules
  static const int minUsernameLength = 5;
  static const int minPasswordLength = 12;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 13;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Auto-save Delay
  static const Duration autoSaveDelay = Duration(seconds: 2);

  // Demo Data
  static const List<String> demoUsernames = ['admin', 'user', 'test'];
  static const String demoAssetName = 'Laptop Dell Latitude 5520';
  static const String demoAssetCategory = 'Elektronik';

  // Status Options
  static const List<String> ticketStatusOptions = [
    'Semua',
    'Reject',
    'Request',
    'Waiting List',
    'On Progress',
    'Solved',
    'Closed'
  ];

  // Classification Options
  static const List<Map<String, String>> classificationOptions = [
    {'code': 'CLS001', 'name': 'Perbaikan Alat Medis'},
    {'code': 'CLS002', 'name': 'Kalibrasi Alat'},
    {'code': 'CLS003', 'name': 'Maintenance Rutin'},
    {'code': 'CLS004', 'name': 'Penggantian Spare Part'},
    {'code': 'CLS005', 'name': 'Instalasi Baru'},
  ];

  // Organization Options
  static const List<Map<String, String>> organizationOptions = [
    {'code': 'ORG001', 'name': 'IT Support'},
    {'code': 'ORG002', 'name': 'Logistik'},
    {'code': 'ORG003', 'name': 'Keuangan'},
    {'code': 'ORG004', 'name': 'Umum'},
    {'code': 'ORG005', 'name': 'Manajemen'},
  ];

  // Error Messages
  static const String networkErrorMessage = 'Tidak ada koneksi internet';
  static const String genericErrorMessage = 'Terjadi kesalahan';
  static const String validationErrorMessage = 'Data tidak valid';

  // Success Messages
  static const String loginSuccessMessage = 'Login berhasil';
  static const String ticketSubmittedMessage = 'Tiket berhasil diajukan';
  static const String passwordChangedMessage = 'Password berhasil diubah';

  // Loading Messages
  static const String processingLoginMessage = 'Memproses login...';
  static const String processingQRMessage = 'Memproses QR...';
  static const String submittingTicketMessage = 'Mengirim tiket...';
}
