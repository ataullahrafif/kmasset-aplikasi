class QRData {
  final String kodeAsset;
  final String namaAsset;
  final String kategori;
  final String rawData;

  QRData({
    required this.kodeAsset,
    required this.namaAsset,
    required this.kategori,
    required this.rawData,
  });

  factory QRData.fromJson(Map<String, dynamic> json) {
    return QRData(
      kodeAsset: json['kode_asset'] ?? 'N/A',
      namaAsset: json['nama_asset'] ?? 'N/A',
      kategori: json['kategori'] ?? 'N/A',
      rawData: json['raw_data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_asset': kodeAsset,
      'nama_asset': namaAsset,
      'kategori': kategori,
      'raw_data': rawData,
    };
  }

  QRData copyWith({
    String? kodeAsset,
    String? namaAsset,
    String? kategori,
    String? rawData,
  }) {
    return QRData(
      kodeAsset: kodeAsset ?? this.kodeAsset,
      namaAsset: namaAsset ?? this.namaAsset,
      kategori: kategori ?? this.kategori,
      rawData: rawData ?? this.rawData,
    );
  }
}
