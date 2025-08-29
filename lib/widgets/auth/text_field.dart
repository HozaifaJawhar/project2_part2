// import 'package:ammerha_management/config/theme/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomdField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;

//   const CustomdField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         fillColor: AppColors.white,
//         hintStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppColors.greyText,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColors.grey2, width: 1.0),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Theme.of(context).primaryColor,
//             width: 1.5,
//           ),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }
// }

import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: AppColors.white,
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
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
