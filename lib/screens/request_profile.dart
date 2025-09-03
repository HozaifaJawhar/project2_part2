import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VolunteerProfileScreen extends StatelessWidget {
  NewVolunteer req;
  VolunteerProfileScreen({super.key, required this.req});
  void _showAddSectionDialog(BuildContext parentContext) {
    TextEditingController sectionController = TextEditingController();

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 350,
                maxWidth: 500,
                minHeight: 200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "إضافة نقاط",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.almarai(
                        fontSize: 18,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: sectionController,
                        decoration: InputDecoration(
                          hintText: "أدخل عدد النقاط",
                          hintStyle: GoogleFonts.almarai(
                            color: AppColors.secondaryBlack.withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.secondaryBlack,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryWhite,
                        ),
                        style: GoogleFonts.almarai(
                          color: AppColors.secondaryBlack,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // String sectionName = sectionController.text
                            //     .trim();
                            // if (sectionName.isNotEmpty) {
                            //   try {
                            //     await departmentProvider.addDepartment(
                            //       sectionName,
                            //       'any',
                            //     );

                            //     Navigator.of(dialogContext).pop();

                            //     ScaffoldMessenger.of(
                            //       parentContext,
                            //     ).showSnackBar(
                            //       SnackBar(
                            //         backgroundColor: AppColors.primary,
                            //         content: Text("تم إنشاء القسم بنجاح"),
                            //       ),
                            //     );
                            //   } catch (e) {
                            //     Navigator.of(dialogContext).pop();

                            //     ScaffoldMessenger.of(
                            //       parentContext,
                            //     ).showSnackBar(
                            //       SnackBar(
                            //         backgroundColor: Colors.red,
                            //         content: Text("فشل إنشاء القسم: $e"),
                            //       ),
                            //     );
                            //   }
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'تأكيد',
                            style: GoogleFonts.almarai(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'إدارة الفعاليات ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              fontSize: 25,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // صورة
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(req.imageUrl),
                ),
              ),
              const SizedBox(height: 20),

              // الاسم
              Center(
                child: Text(
                  req.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Cairo',
                    fontSize: 25,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // باقي المعلومات
              _buildInfoRow("العنوان", req.address),
              _buildInfoRow("تاريخ الميلاد", req.date),
              _buildInfoRow("الجنس", req.gender),
              _buildInfoRow("البريد", req.email),
              _buildInfoRow("رقم الهاتف", req.phone),
              _buildInfoRow("القسم", req.department),

              const SizedBox(height: 100),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "قبول",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "تجاهل",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  _showAddSectionDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "قبول كمتطوع قديم",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
