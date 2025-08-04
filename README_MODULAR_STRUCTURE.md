# Struktur Modular Aplikasi KMAsset

## Overview
Aplikasi ini telah direstrukturisasi dengan pendekatan modular untuk memudahkan maintenance, testing, dan pengembangan yang berkelanjutan.

## Struktur Folder

```
lib/
├── models/                 # Data Models
│   ├── ticket_model.dart
│   └── qr_data_model.dart
├── services/              # Business Logic & API Calls
│   ├── ticket_service.dart
│   └── auth_service.dart
├── constants/             # App Constants
│   └── app_constants.dart
├── widgets/               # Reusable UI Components
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── custom_dialog.dart
│   └── modern_appbar.dart
├── utils/                 # Helper Functions
│   ├── network_utils.dart
│   ├── device_utils.dart
│   ├── dialog_utils.dart
│   ├── logo_utils.dart
│   ├── priority_utils.dart
│   └── error_utils.dart
├── screens/               # UI Pages (akan dipindahkan)
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── qr_scan_page.dart
│   ├── form_pengajuan_tiket.dart
│   ├── history_ticket_page.dart
│   ├── settings_page.dart
│   ├── faq_page.dart
│   ├── force_change_password_page.dart
│   └── splash_screen.dart
└── main.dart
```

## Komponen Modular

### 1. **Models** (`lib/models/`)
Berisi data models yang merepresentasikan struktur data aplikasi.

#### `ticket_model.dart`
- Model untuk data tiket
- Method `fromJson()` dan `toJson()` untuk serialisasi
- Method `copyWith()` untuk immutable updates

#### `qr_data_model.dart`
- Model untuk data QR code
- Struktur data yang konsisten untuk QR scanning

### 2. **Services** (`lib/services/`)
Berisi business logic dan API calls yang terpisah dari UI.

#### `ticket_service.dart`
- Singleton pattern untuk konsistensi data
- Method untuk CRUD operations tiket
- QR data parsing
- Draft management
- Filtering dan searching

#### `auth_service.dart`
- Login/logout logic
- Password validation
- Session management
- Force change password logic

### 3. **Constants** (`lib/constants/`)
Berisi semua konstanta aplikasi yang terpusat.

#### `app_constants.dart`
- Colors
- API endpoints
- Validation rules
- Animation durations
- Error/success messages
- Demo data
- Status options

### 4. **Widgets** (`lib/widgets/`)
Berisi reusable UI components.

#### `custom_button.dart`
- `CustomButton`: Elevated button dengan loading state
- `CustomOutlinedButton`: Outlined button dengan loading state
- Konsisten styling dan behavior

#### `custom_text_field.dart`
- `CustomTextField`: Text field dengan validasi
- `CustomDropdownField`: Dropdown field yang reusable
- Konsisten styling dan validation

#### `custom_dialog.dart`
- `CustomDialog.showSuccessDialog()`
- `CustomDialog.showErrorDialog()`
- `CustomDialog.showConfirmationDialog()`
- Konsisten UI untuk semua dialog

### 5. **Utils** (`lib/utils/`)
Berisi helper functions yang dapat digunakan di seluruh aplikasi.

## Keuntungan Struktur Modular

### 1. **Separation of Concerns**
- UI terpisah dari business logic
- Data models terpisah dari UI
- Constants terpusat dan mudah diubah

### 2. **Reusability**
- Widget dapat digunakan di multiple screens
- Services dapat digunakan di berbagai tempat
- Utils dapat digunakan di seluruh aplikasi

### 3. **Maintainability**
- Mudah menemukan dan mengubah kode
- Perubahan di satu tempat tidak mempengaruhi yang lain
- Testing lebih mudah

### 4. **Scalability**
- Mudah menambah fitur baru
- Mudah mengubah struktur tanpa merusak yang lain
- Mudah melakukan refactoring

### 5. **Testing**
- Unit testing untuk services
- Widget testing untuk components
- Integration testing lebih mudah

## Best Practices yang Diterapkan

### 1. **Singleton Pattern**
```dart
class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();
}
```

### 2. **Factory Constructor**
```dart
factory Ticket.fromJson(Map<String, dynamic> json) {
  return Ticket(
    id: json['id'] ?? '',
    // ... other fields
  );
}
```

### 3. **Immutable Models**
```dart
class Ticket {
  final String id;
  final String kodeTiket;
  // ... other final fields
  
  Ticket copyWith({...}) {
    return Ticket(...);
  }
}
```

### 4. **Centralized Constants**
```dart
class AppConstants {
  static const int primaryColorValue = 0xFF093951;
  static const int minPasswordLength = 12;
  // ... other constants
}
```

### 5. **Reusable Widgets**
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  // ... other parameters
}
```

## Cara Menggunakan Struktur Modular

### 1. **Menggunakan Services**
```dart
final ticketService = TicketService();
final tickets = await ticketService.getTickets();
```

### 2. **Menggunakan Models**
```dart
final ticket = Ticket.fromJson(jsonData);
final updatedTicket = ticket.copyWith(status: 'Solved');
```

### 3. **Menggunakan Constants**
```dart
if (password.length < AppConstants.minPasswordLength) {
  // Show error
}
```

### 4. **Menggunakan Custom Widgets**
```dart
CustomButton(
  text: 'Submit',
  onPressed: _submitForm,
  isLoading: _isLoading,
  icon: Icons.send,
)
```

### 5. **Menggunakan Custom Dialogs**
```dart
CustomDialog.showSuccessDialog(
  context: context,
  title: 'Berhasil',
  message: 'Data telah disimpan',
);
```

## Langkah Selanjutnya

### 1. **Refactoring Screens**
- Pindahkan screens ke folder `lib/screens/`
- Gunakan services untuk business logic
- Gunakan custom widgets untuk UI

### 2. **State Management**
- Implementasi Provider atau Riverpod
- Pisahkan state management dari UI

### 3. **API Integration**
- Implementasi real API calls di services
- Error handling yang konsisten
- Loading states yang proper

### 4. **Testing**
- Unit tests untuk services
- Widget tests untuk custom widgets
- Integration tests untuk screens

### 5. **Documentation**
- API documentation
- Code documentation
- User documentation

## Kesimpulan

Struktur modular ini membuat aplikasi lebih:
- **Maintainable**: Mudah diubah dan diperbaiki
- **Scalable**: Mudah dikembangkan
- **Testable**: Mudah di-test
- **Reusable**: Komponen dapat digunakan ulang
- **Consistent**: Konsisten di seluruh aplikasi

Dengan struktur ini, tim development dapat bekerja lebih efisien dan aplikasi dapat dikembangkan dengan lebih baik di masa depan. 