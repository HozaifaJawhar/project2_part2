import '../../config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // <<< هي اللي بتخلي القائمة RTL كاملة
      textDirection: TextDirection.rtl,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(15),

          style: GoogleFonts.poppins(
            fontSize: 14, // النص المختار داخل الحقل
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: AppColors.white,
            filled: true,
            hintStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.greyText,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey2, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: items.map((dep) {
            return DropdownMenuItem(
              value: dep,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // المحاذاة لليمين
                children: [
                  Expanded(
                    child: Text(
                      dep,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.circle, color: AppColors.primary, size: 20),
                ],
              ),
            );
          }).toList(),

          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
