import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  String? title,
  required String message,
  String confirmText = 'تأكيد',
  String cancelText = 'إلغاء',
  IconData icon = Icons.warning_amber_rounded,
  Color confirmColor = AppColors.primary,
  bool barrierDismissible = false,
  TextDirection textDirection = TextDirection.rtl,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogCtx) {
      return Directionality(
        textDirection: textDirection,
        child: Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.red, size: 40),
                const SizedBox(height: 20),
                if (title != null && title.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.almarai(
                        fontSize: 18,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    color: AppColors.secondaryBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // cancel
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: GoogleFonts.almarai(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // confirm
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: GoogleFonts.almarai(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
