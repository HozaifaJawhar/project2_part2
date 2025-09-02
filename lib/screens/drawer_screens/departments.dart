import 'package:ammerha_management/core/provider/Department_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_theme.dart';

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
    final List<String> departments = [
      "حماية الطفل",
      "الطبي",
      "البيئي",
      "المرأة",
      "التقني",
      "دعم الشباب",
    ];
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemBuilder: (context, index) {}),
        ),
      ),
    );
  }
}
