// lib/faq_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'widgets/modern_appbar.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> faqList = const [
    {
      'question': 'Apa itu aplikasi KMAsset?',
      'answer':
          'Aplikasi KMAsset adalah sistem manajemen aset yang dirancang untuk membantu staf Rumah Sakit Krakatau Medika dalam mengelola, memantau, dan melaporkan kondisi aset-aset rumah sakit, serta mengajukan dan melacak tiket perbaikan/pemeliharaan.',
    },
    {
      'question': 'Bagaimana cara login ke aplikasi KMAsset?',
      'answer':
          'Gunakan username dan password yang telah diberikan oleh administrator SI Rumah Sakit Krakatau Medika. Jika Anda mengalami kesulitan login, silakan hubungi tim SI.',
    },
    {
      'question':
          'Saya lupa password saya / ingin mengubah password saya, apa yang harus saya lakukan?',
      'answer':
          'Jika Anda tidak bisa login karena lupa password, silakan hubungi administrator SI Rumah Sakit Krakatau Medika untuk bantuan reset password. Jika Anda sudah berhasil login dan ingin mengubah password Anda, Anda dapat melakukannya melalui menu "Pengaturan Akun" yang ada di halaman profil Anda.',
    },
    {
      'question': 'Bagaimana cara mengajukan tiket perbaikan aset?',
      'answer':
          'Anda dapat mengajukan tiket perbaikan melalui fitur "Scan Barcode Aset" di halaman beranda. Setelah memindai barcode, Anda akan diarahkan ke formulir pengajuan tiket untuk mengisi detail masalah.',
    },
    {
      'question':
          'Di mana saya bisa melihat riwayat tiket yang sudah saya ajukan?',
      'answer':
          'Anda bisa melihat semua riwayat tiket yang pernah Anda ajukan atau yang terkait dengan unit Anda di tab "Riwayat Tiket" pada bottom navigation bar.',
    },
    {
      'question': 'Bagaimana cara melacak status tiket yang sudah diajukan?',
      'answer':
          'Saat ini, status tiket dapat dilihat di halaman "Riwayat Tiket". Di masa mendatang, akan ada detail status yang lebih rinci untuk setiap tiket.',
    },
    {
      'question': 'Apakah saya bisa mengedit tiket yang sudah diajukan?',
      'answer':
          'Setelah diajukan, tiket tidak dapat diedit secara langsung oleh pengguna. Jika ada perubahan informasi penting, silakan hubungi tim pemeliharaan aset atau administrator terkait dengan menyebutkan Nomor Tiket.',
    },
    {
      'question': 'Apa yang harus saya lakukan jika menemukan aset yang rusak?',
      'answer':
          'Segera gunakan fitur "Scan Barcode Aset" pada aplikasi untuk memindai aset yang rusak dan mengajukan tiket perbaikan dengan deskripsi masalah yang jelas.',
    },
    {
      'question': 'Apakah semua aset rumah sakit terdaftar di aplikasi ini?',
      'answer':
          'Aplikasi ini dirancang untuk mengelola aset-aset utama dan penting rumah sakit. Jika Anda menemukan aset yang belum terdaftar atau tidak memiliki barcode, harap laporkan kepada tim manajemen aset.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.05),
      appBar: const ModernAppBar(
        title: 'FAQ',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 9, 57, 81),
                  const Color.fromARGB(255, 16, 91, 16).withOpacity(0.85),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 9, 57, 81).withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.10),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pertanyaan Umum',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temukan jawaban untuk pertanyaan yang sering diajukan',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 16, 91, 16),
                        Color.fromARGB(255, 9, 57, 81),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: faqList.length,
              itemBuilder: (context, index) {
                final faq = faqList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 9, 57, 81)
                          .withOpacity(0.13),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 9, 57, 81)
                            .withOpacity(0.07),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color.fromARGB(255, 9, 57, 81)
                                  .withOpacity(0.13),
                              const Color.fromARGB(255, 16, 91, 16)
                                  .withOpacity(0.13),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Color.fromARGB(255, 9, 57, 81),
                          size: 24,
                        ),
                      ),
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color.fromARGB(255, 9, 57, 81),
                        ),
                      ),
                      iconColor: const Color.fromARGB(255, 16, 91, 16),
                      collapsedIconColor: Colors.grey,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 16, 91, 16)
                                      .withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 9, 57, 81)
                                        .withOpacity(0.09),
                                  ),
                                ),
                                child: Text(
                                  faq['answer']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
