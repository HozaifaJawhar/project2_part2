import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/Department_Provider.dart';

import 'package:ammerha_management/widgets/basics/dialog.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Departments extends StatefulWidget {
  const Departments({super.key});

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  @override
  void initState() {
    super.initState();
    // استدعاء البيانات أول ما تفتح الصفحة
    Future.microtask(
      () => Provider.of<DepartmentProvider>(
        context,
        listen: false,
      ).getDepartments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    if (departmentProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (departmentProvider.error != null) {
      return Center(child: Text("خطأ: ${departmentProvider.error}"));
    }
    final departments = departmentProvider.departments;

    //استخدام الكوستم ديلالوغ
    void _showDeleteDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomConfirmationDialog(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.red,
            message: 'هل أنت متأكد أنك تريد حذف هذا القسم؟',
            cancelText: 'إلغاء',
            confirmText: 'حذف',
            confirmButtonColor: AppColors.primary,
            onConfirm: () {
              // كود الحذف الفعلي
              print("تم الحذف ✅");
            },
          );
        },
      );
    }

    void _showAddSectionDialog(BuildContext context) {
      TextEditingController sectionController = TextEditingController();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 350, // أقل عرض
                  maxWidth: 500, // أكبر عرض
                  minHeight: 200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // العنوان بالأعلى
                      Text(
                        "إضافة قسم",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 12),
                        child: Text(
                          'اسم القسم',
                          style: TextStyle(color: AppColors.secondaryBlack),
                        ),
                      ),

                      // TextField لإضافة قسم
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: sectionController,
                          decoration: InputDecoration(
                            hintText: "أدخل اسم القسم",
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

                      // زر إضافة
                      Center(
                        child: SizedBox(
                          width: 160, // وسعي عرض الزر
                          height: 50, // زيدي ارتفاعه
                          child: ElevatedButton(
                            onPressed: () {
                              String sectionName = sectionController.text
                                  .trim();
                              if (sectionName.isNotEmpty) {
                                Navigator.of(context).pop();
                                // كود الإضافة الفعلي
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'إضافة',
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

    void _showAddEditSectionDialog(BuildContext context) {
      TextEditingController sectionController = TextEditingController();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 350, // أقل عرض
                  maxWidth: 500, // أكبر عرض
                  minHeight: 200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // العنوان بالأعلى
                      Text(
                        "تعديل قسم",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 12),
                        child: Text(
                          'اسم القسم',
                          style: TextStyle(color: AppColors.secondaryBlack),
                        ),
                      ),

                      // TextField لإضافة قسم
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: sectionController,
                          decoration: InputDecoration(
                            hintText: "أدخل اسم القسم",
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

                      // زر إضافة
                      Center(
                        child: SizedBox(
                          width: 160, // وسعي عرض الزر
                          height: 50, // زيدي ارتفاعه
                          child: ElevatedButton(
                            onPressed: () {
                              String sectionName = sectionController.text
                                  .trim();
                              if (sectionName.isNotEmpty) {
                                Navigator.of(context).pop();
                                // كود الإضافة الفعلي
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'تعديل',
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'إدارة الأقسام التطوعية ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Cairo',
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                size: 30,
                Icons.notifications_none_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];
              return Container(
                height: 50,
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                ), // مسافة بين العناصر
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  textDirection: TextDirection.rtl, // لضبط المحاذاة من اليمين
                  children: [
                    /// اسم القسم
                    Expanded(
                      child: Text(
                        dept.name,
                        style: const TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    /// أيقونات (تعديل + حذف)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_calendar_outlined,
                            color: Colors.amberAccent,
                          ),
                          onPressed: () {
                            _showAddEditSectionDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSectionDialog(context);
        },
        tooltip: 'Increment',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
