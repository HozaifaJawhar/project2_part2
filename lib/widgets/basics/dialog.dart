import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmButtonColor;
  final VoidCallback onConfirm;

  const CustomConfirmationDialog({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.message,
    this.cancelText = 'إلغاء',
    this.confirmText = 'تأكيد',
    this.confirmButtonColor = AppColors.primary,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 20),

            // النص
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

            // الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر إلغاء
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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

                // زر تأكيد
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmButtonColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
