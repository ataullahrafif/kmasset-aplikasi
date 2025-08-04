class Ticket {
  final String id;
  final String kodeTiket;
  final String judul;
  final String deskripsi;
  final String klasifikasi;
  final String pusatKendali;
  final String status;
  final DateTime tanggal;
  final String? ekstensi;
  final String? nomorTelepon;
  final Map<String, dynamic>? qrData;
  final List<String>? images;
  final List<String>? pdfFiles;

  Ticket({
    required this.id,
    required this.kodeTiket,
    required this.judul,
    required this.deskripsi,
    required this.klasifikasi,
    required this.pusatKendali,
    required this.status,
    required this.tanggal,
    this.ekstensi,
    this.nomorTelepon,
    this.qrData,
    this.images,
    this.pdfFiles,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      kodeTiket: json['kode_tiket'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      klasifikasi: json['klasifikasi'] ?? '',
      pusatKendali: json['pusat_kendali'] ?? '',
      status: json['status'] ?? '',
      tanggal: DateTime.tryParse(json['tanggal'] ?? '') ?? DateTime.now(),
      ekstensi: json['ekstensi'],
      nomorTelepon: json['nomor_telepon'],
      qrData: json['qr_data'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      pdfFiles: json['pdf_files'] != null
          ? List<String>.from(json['pdf_files'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_tiket': kodeTiket,
      'judul': judul,
      'deskripsi': deskripsi,
      'klasifikasi': klasifikasi,
      'pusat_kendali': pusatKendali,
      'status': status,
      'tanggal': tanggal.toIso8601String(),
      'ekstensi': ekstensi,
      'nomor_telepon': nomorTelepon,
      'qr_data': qrData,
      'images': images,
      'pdf_files': pdfFiles,
    };
  }

  Ticket copyWith({
    String? id,
    String? kodeTiket,
    String? judul,
    String? deskripsi,
    String? klasifikasi,
    String? pusatKendali,
    String? status,
    DateTime? tanggal,
    String? ekstensi,
    String? nomorTelepon,
    Map<String, dynamic>? qrData,
    List<String>? images,
    List<String>? pdfFiles,
  }) {
    return Ticket(
      id: id ?? this.id,
      kodeTiket: kodeTiket ?? this.kodeTiket,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      klasifikasi: klasifikasi ?? this.klasifikasi,
      pusatKendali: pusatKendali ?? this.pusatKendali,
      status: status ?? this.status,
      tanggal: tanggal ?? this.tanggal,
      ekstensi: ekstensi ?? this.ekstensi,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      qrData: qrData ?? this.qrData,
      images: images ?? this.images,
      pdfFiles: pdfFiles ?? this.pdfFiles,
    );
  }
}
