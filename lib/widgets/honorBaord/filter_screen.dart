import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterScreen extends StatefulWidget {
  final FilterOptions initialFilters;

  const FilterScreen({super.key, required this.initialFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // متغيرات لتخزين الاختيارات الحالية
  late String _selectedDepartment;
  late TimePeriod _selectedTimePeriod;

  // بيانات وهمية للأقسام
  final List<String> _departments = [
    'كل الأقسام',
    'القسم الصحي',
    'القسم التعليمي',
  ];

  @override
  void initState() {
    super.initState();
    // إعطاء المتغيرات القيم الأولية التي تم تمريرها من الشاشة الرئيسية
    _selectedDepartment = widget.initialFilters.department;
    _selectedTimePeriod = widget.initialFilters.timePeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            'اختر نوع لوحة الشرف',
            style: GoogleFonts.almarai(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterGroup(
                      title: 'القسم التطوعي',
                      options: _departments,
                      groupValue: _selectedDepartment,
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildFilterGroup(
                      title: 'الفترة الزمنية',
                      options: {
                        'العام الجاري': TimePeriod.currentYear,
                        'المجمل': TimePeriod.total,
                      },
                      groupValue: _selectedTimePeriod,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimePeriod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // زر التطبيق
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // إنشاء كائن بالخيارات الجديدة
                    final newFilters = FilterOptions(
                      department: _selectedDepartment,
                      timePeriod: _selectedTimePeriod,
                    );
                    // إغلاق الشاشة وإرجاع الخيارات الجديدة للشاشة الرئيسية
                    Navigator.pop(context, newFilters);
                  },
                  child: Text(
                    'تطبيق',
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعد لبناء كل مجموعة فلاتر
  Widget _buildFilterGroup({
    required String title,
    required dynamic options,
    required dynamic groupValue,
    required void Function(dynamic) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.almarai(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children:
              (options is List<String>
                      ? options
                      : (options as Map<String, dynamic>).keys.toList())
                  .map<Widget>((key) {
                    final value = options is List<String> ? key : options[key];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RadioListTile(
                        title: Text(
                          key,
                          style: GoogleFonts.almarai(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: value,
                        groupValue: groupValue,
                        onChanged: onChanged,
                        activeColor: AppColors.primary,
                      ),
                    );
                  })
                  .toList(),
        ),
      ],
    );
  }
}
