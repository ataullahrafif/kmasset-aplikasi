// lib/qr_scan_page.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sensors_plus/sensors_plus.dart';
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

  // Gyroscope
  StreamSubscription? _gyroscopeSubscription;
  double _gyroY = 0.0;
  double _gyroX = 0.0;

  // Animation for scan line
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroY = event.y;
        _gyroX = event.x;
      });
    });
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
          // Indikator gyroscope
          Positioned(
            top: 60,
            right: 24,
            child: _buildGyroIndicator(),
          ),
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
        final double frameSize = width * 0.85;
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
            // Tips scanning di bawah layar
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildGyroIndicator() {
    // Jika device terlalu miring, tampilkan warning
    bool isStable = _gyroY.abs() < 0.3 && _gyroX.abs() < 0.3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isStable
            ? Colors.green.withOpacity(0.85)
            : Colors.red.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isStable
                ? Colors.green.withOpacity(0.18)
                : Colors.red.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isStable ? Icons.check_circle : Icons.warning,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            isStable ? 'Stabil' : 'Kamera goyang',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showScanResult(String result) {
    // Langsung navigasi ke form pengajuan tiket tanpa popup
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormPengajuanTiketPage(),
      ),
    );
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
    _gyroscopeSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
