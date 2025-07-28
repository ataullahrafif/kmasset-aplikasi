// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LogoUtils {
  // Path untuk logo
  static const String logoPath = 'assets/images/logo_pnj.png';
  static const String launcherLogoPath = 'assets/images/logo baru.png';

  // Ukuran logo berdasarkan screen width
  static double getLogoSize(BuildContext context, {double multiplier = 0.18}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * multiplier;
  }

  // Logo untuk home page
  static Widget buildHomePageLogo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        logoPath,
        width: getLogoSize(context, multiplier: 0.25), // diperbesar dari 0.22
        height: getLogoSize(context, multiplier: 0.25), // diperbesar dari 0.22
        fit: BoxFit.contain,
      ),
    );
  }

  // Logo untuk tablet (ukuran lebih besar)
  static Widget buildTabletLogo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        logoPath,
        width: getLogoSize(context, multiplier: 0.26), // dari 0.32
        height: getLogoSize(context, multiplier: 0.26), // dari 0.32
        color: Colors.white,
        fit: BoxFit.contain,
      ),
    );
  }

  // Logo untuk splash screen
  static Widget buildSplashLogo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * (screenWidth > 600 ? 0.25 : 0.35);

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        logoPath,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
      ),
    );
  }

  // Logo untuk login page
  static Widget buildLoginLogo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * (screenWidth > 600 ? 0.20 : 0.30);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        logoPath,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
      ),
    );
  }

  // Logo untuk app bar atau header kecil
  static Widget buildSmallLogo(BuildContext context) {
    return Image.asset(
      logoPath,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
    );
  }

  // Logo dengan custom size
  static Widget buildCustomLogo(
    BuildContext context, {
    required double size,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      logoPath,
      width: size,
      height: size,
      color: color,
      fit: fit,
    );
  }

  // Logo untuk launcher icon
  static Widget buildLauncherLogo(BuildContext context) {
    return Image.asset(
      launcherLogoPath,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
    );
  }

  // Helper untuk mendapatkan ukuran logo berdasarkan device type
  static double getResponsiveLogoSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 0.24; // Desktop - diperbesar dari 0.20
    } else if (screenWidth > 600) {
      return 0.30; // Tablet - diperbesar dari 0.26
    } else {
      return 0.28; // Mobile - diperbesar dari .22
    }
  }

  // Logo dengan responsive size
  static Widget buildResponsiveLogo(
    BuildContext context, {
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final multiplier = getResponsiveLogoSize(context);
    final size = getLogoSize(context, multiplier: multiplier);

    return Image.asset(
      logoPath,
      width: size,
      height: size,
      color: color,
      fit: fit,
    );
  }

  // Method untuk home page
  static Widget getHomeLogo(BuildContext context) {
    return buildHomePageLogo(context);
  }

  // Method untuk login page
  static Widget getLoginLogo(BuildContext context) {
    return buildLoginLogo(context);
  }

  // Method untuk splash screen
  static Widget getSplashLogo(BuildContext context) {
    return buildSplashLogo(context);
  }
}
