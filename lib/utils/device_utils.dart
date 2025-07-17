import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtils {
  // Deteksi apakah device adalah tablet berdasarkan screen width
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Gunakan shortest side untuk deteksi yang lebih akurat
    final shortestSide =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    // Tablet jika shortest side >= 600dp
    return shortestSide >= 600;
  }

  // Deteksi apakah device adalah HP (mobile)
  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }

  // Dapatkan orientasi yang diizinkan berdasarkan device type
  static List<DeviceOrientation> getAllowedOrientations(BuildContext context) {
    if (isTablet(context)) {
      // Tablet: bisa portrait dan landscape
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
    } else {
      // HP: hanya portrait
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
    }
  }

  // Set orientasi berdasarkan device type
  static void setOrientation(BuildContext context) {
    final orientations = getAllowedOrientations(context);
    SystemChrome.setPreferredOrientations(orientations);
  }

  // Lock orientasi ke portrait untuk HP
  static void lockToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Unlock orientasi untuk tablet
  static void unlockOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Get responsive padding berdasarkan device type
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  // Get responsive font size berdasarkan device type
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobileSize,
    required double tabletSize,
  }) {
    return isTablet(context) ? tabletSize : mobileSize;
  }

  // Get responsive icon size berdasarkan device type
  static double getResponsiveIconSize(
    BuildContext context, {
    required double mobileSize,
    required double tabletSize,
  }) {
    return isTablet(context) ? tabletSize : mobileSize;
  }

  // Get responsive spacing berdasarkan device type
  static double getResponsiveSpacing(
    BuildContext context, {
    required double mobileSpacing,
    required double tabletSpacing,
  }) {
    return isTablet(context) ? tabletSpacing : mobileSpacing;
  }

  // Check apakah dalam mode landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Check apakah dalam mode portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Get device info untuk debugging
  static String getDeviceInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final deviceType = isTablet(context) ? 'Tablet' : 'Mobile';

    return 'Device: $deviceType | Size: ${screenWidth.toInt()}x${screenHeight.toInt()} | Orientation: $orientation';
  }
}
