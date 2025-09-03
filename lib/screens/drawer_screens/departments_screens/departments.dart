import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/Department_Provider.dart';
import 'package:ammerha_management/widgets/basics/dialog.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    final _storage = const FlutterSecureStorage();

    if (departmentProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (departmentProvider.error != null) {
      return Center(child: Text("خطأ: ${departmentProvider.error}"));
    }

    final departments = departmentProvider.departments;

    //استخدام الكوستم ديلالوغ
    void _showDeleteDialog(
      BuildContext parentContext,
      int id,
      DepartmentProvider provider,
    ) {
      showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          return CustomConfirmationDialog(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.red,
            message: 'هل أنت متأكد أنك تريد حذف هذا القسم؟',
            cancelText: 'إلغاء',
            confirmText: 'حذف',
            confirmButtonColor: AppColors.primary,
            onConfirm: () async {
              final token = await _storage.read(key: 'auth_token');
              bool success = await provider.deleteSection(id: id, token: token);

              // أول شي سكري الديالوج
              // بعدين اعرضي SnackBar باستخدام parentContext مثل ما عملتي بكود الإضافة
              if (parentContext.mounted) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    backgroundColor: success ? AppColors.primary : Colors.red,
                    content: Text(success ? " تم الحذف بنجاح" : "❌ فشل الحذف"),
                  ),
                );
              }
            },
          );
        },
      );
    }

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
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              String sectionName = sectionController.text
                                  .trim();
                              if (sectionName.isNotEmpty) {
                                try {
                                  await departmentProvider.addDepartment(
                                    sectionName,
                                    'any',
                                  );

                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // تسكير الديالوج

                                  // استخدم الـ parentContext بدل context
                                  ScaffoldMessenger.of(
                                    parentContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.primary,
                                      content: Text("تم إنشاء القسم بنجاح"),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // ضروري نسكر الديالوج حتى بالخطأ

                                  ScaffoldMessenger.of(
                                    parentContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("فشل إنشاء القسم: $e"),
                                    ),
                                  );
                                }
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

    void _showAddEditSectionDialog(
      BuildContext context,
      int deptId,
      String currentName,
      String token,
    ) {
      TextEditingController nameController = TextEditingController(
        text: currentName,
      );

      showDialog(
        context: context,
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
                        "تعديل قسم",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'اسم القسم',
                        style: TextStyle(color: AppColors.secondaryBlack),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
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
                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              String updatedName = nameController.text.trim();
                              if (updatedName.isNotEmpty) {
                                Navigator.of(dialogContext).pop();
                                bool success =
                                    await Provider.of<DepartmentProvider>(
                                      context,
                                      listen: false,
                                    ).updateDepartment(
                                      id: deptId,
                                      name: updatedName,
                                      description: null, // ثابت دايمًا
                                      token: token,
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.red,
                                    content: Text(
                                      success
                                          ? "✅ تم تعديل القسم بنجاح"
                                          : "❌ فشل تعديل القسم",
                                    ),
                                  ),
                                );
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
                          onPressed: () async {
                            final token = await _storage.read(
                              key: 'auth_token',
                            );
                            if (token != null) {
                              _showAddEditSectionDialog(
                                context,
                                dept.id,
                                dept.name,
                                token,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("❌لا يمكنك التعديل ")),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _showDeleteDialog(
                              context,
                              dept.id,
                              departmentProvider,
                            );
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
