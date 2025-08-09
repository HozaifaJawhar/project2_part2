import 'package:flutter/material.dart';

class UIHelpers {
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseSize,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 400;
    double responsiveSize = (baseSize * scaleFactor).clamp(
      baseSize * 0.8,
      baseSize * 1.5,
    );
    return responsiveSize;
  }
}
