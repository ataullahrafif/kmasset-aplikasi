// lib/qr_scan_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';
import 'form_pengajuan_tiket.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/modern_appbar.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isFlashOn = false;
  bool _isScanning = true;
  bool _isLoading = false;

  // Animation for scan line
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: 'Scan QR Code',
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, size: 28),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                cameraController.toggleTorch();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.image, size: 28),
            onPressed: _pickImageAndScan,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 28),
            onPressed: _showDemoQR,
            tooltip: 'Demo QR Code',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (_isScanning) {
                  _isScanning = false;
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(const Duration(milliseconds: 800), () {
                    setState(() {
                      _isLoading = false;
                    });
                    _showScanResult(barcode.rawValue ?? 'No data');
                  });
                }
              }
            },
          ),
          // Custom overlay
          _buildOverlay(context),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.10),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 9, 57, 81)),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 18),
                      Text(
                        'Memproses QR...',
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
            ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final bool isTablet = width > 600;
        final bool isLandscape = width > height;
        double frameSize;
        if (isTablet && isLandscape) {
          frameSize = width * 0.5; // landscape tablet
        } else {
          frameSize = width * 0.85; // default (portrait & HP)
        }
        final double top = (height - frameSize) / 2 + 48;
        final double left = (width - frameSize) / 2;

        return Stack(
          children: [
            // Area gelap di luar frame
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.18),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.10),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: top,
                    left: left,
                    child: Container(
                      width: frameSize,
                      height: frameSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Frame glowing
            Positioned(
              top: top,
              left: left,
              child: Container(
                width: frameSize,
                height: frameSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 9, 57, 81),
                    width: 6,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.25),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Scan line
                        Positioned(
                          top: _scanLineAnimation.value * (frameSize - 8),
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.cyanAccent.withOpacity(0.8),
                                  Colors.cyan,
                                  Colors.cyanAccent.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Instruksi di atas frame
            Positioned(
              top: top - 80,
              left: left,
              width: frameSize,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Arahkan kamera ke QR code',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Demo button dan tips scanning di bawah layar
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Column(
                children: [
                  // Demo Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showDemoQR,
                        icon: const Icon(Icons.play_arrow, size: 20),
                        label: const Text(
                          'Demo QR Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tips scanning
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tips Scanning',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '- Pastikan QR code berada dalam kotak\n- Jaga kamera tetap stabil\n- Pastikan pencahayaan cukup',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showScanResult(String result) {
    // Show preview popup with QR code data
    _showQRPreviewDialog(result);
  }

  void _showDemoQR() {
    // Simulate QR scan for demo purposes
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
      _showScanResult('DEMO_QR_CODE_${DateTime.now().millisecondsSinceEpoch}');
    });
  }

  void _showQRPreviewDialog(String qrData) {
    // Simulate API call to get QR code details
    // In real implementation, this would be an API call to backend
    Map<String, dynamic> qrDetails = _parseQRData(qrData);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 9, 57, 81)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Color.fromARGB(255, 9, 57, 81),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview QR Code',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 57, 81),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Detail data yang ditemukan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // QR Data Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data QR Code:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 9, 57, 81),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Detail rows
                      _buildDetailRow(
                          'Kode Asset', qrDetails['kode_asset'] ?? 'N/A'),
                      _buildDetailRow(
                          'Nama Asset', qrDetails['nama_asset'] ?? 'N/A'),
                      _buildDetailRow(
                          'Kategori', qrDetails['kategori'] ?? 'N/A'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          setState(() {
                            _isScanning = true; // Re-enable scanning
                          });
                        },
                        icon: const Icon(Icons.close, size: 20),
                        label: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          // Navigate to form with QR data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPengajuanTiketPage(
                                qrData: qrDetails,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, size: 20),
                        label: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 57, 81),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _parseQRData(String qrData) {
    // Simulate parsing QR data
    // In real implementation, this would parse actual QR data format
    try {
      // For demo purposes, create sample data
      return {
        'kode_asset':
            'AST-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        'nama_asset': 'Laptop Dell Latitude 5520',
        'kategori': 'Elektronik',
        'raw_data': qrData,
      };
    } catch (e) {
      // If parsing fails, return basic data
      return {
        'kode_asset': 'N/A',
        'nama_asset': 'N/A',
        'kategori': 'N/A',
        'raw_data': qrData,
      };
    }
  }

  Future<void> _pickImageAndScan() async {
    final ImagePicker picker = ImagePicker();
    setState(() {
      _isLoading = true;
    });
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await cameraController.analyzeImage(image.path);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
