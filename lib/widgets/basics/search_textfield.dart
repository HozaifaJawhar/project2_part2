import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SearchTextfield extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const SearchTextfield({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 224, 220, 220), // لون الظل
            blurRadius: 1, // نعومة الظل
            offset: const Offset(1, 1), // اتجاهه (0,0) = كل الجهات
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: AppColors.white,
          suffixIcon: const Icon(Icons.search),
          suffixIconColor: AppColors.grey2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.grey2, // لون البوردر قبل الضغط
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary, // لون البوردر عند الضغط
              width: 2,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
