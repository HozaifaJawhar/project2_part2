import 'dart:io';

import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event_class.dart';
import 'package:ammerha_management/widgets/events/dropdownField.dart';
import 'package:ammerha_management/widgets/events/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditEventInfo extends StatefulWidget {
  const EditEventInfo({super.key});

  @override
  State<EditEventInfo> createState() => _EditEventInfoState();
}

class _EditEventInfoState extends State<EditEventInfo> {
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }

      // Android 12 وتحت (لأن photos غير مدعومة قبل Android 13)
      if (status.isDenied && await Permission.storage.request().isGranted) {
        status = PermissionStatus.granted;
      }
    } else {
      // iOS
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080, // الحد الأقصى للعرض
        maxHeight: 1080, // الحد الأقصى للارتفاع
        imageQuality: 80, // ضغط الصورة لتقليل الحجم
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يجب منح إذن الوصول للصور")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // يفتح إعدادات التطبيق لتمكين الإذن يدوياً
    }
  }

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController volunteersController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController supervisorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedDepartment;
  final List<String> departments = [
    "حماية الطفل",
    "الطبي",
    "البيئي",
    "المرأة",
    "التقني",
    "دعم الشباب",
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.primary),
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'تعديل فعالية',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              fontSize: 25,
              color: AppColors.primary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // اختيار صورة
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'اختر صورة للفعالية',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // اسم الفعالية
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'اسم الفعالية',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 10),
                CustomdField(
                  controller: nameController,
                  hintText: 'أدخل اسم الفعالية',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                // تاريخ ووقت
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: Text(
                              'تاريخ الفعالية',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  dateController.text =
                                      "${picked.year}-${picked.month}-${picked.day}";
                                });
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_today),
                              hintText: 'أدخل تاريخ الفعالية',
                              fillColor: AppColors.white,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyText,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "يرجى اختيار التاريخ" : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: Text(
                              'وقت الفعالية',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: timeController,
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  timeController.text = picked.format(context);
                                });
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.access_time),
                              hintText: 'أدخل وقت الفعالية',
                              fillColor: AppColors.white,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyText,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.grey2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "يرجى اختيار الوقت" : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: Text(
                              'عدد ساعات الفعالية',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomdField(
                            controller: hoursController,
                            hintText: 'أدخل عدد الساعات',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: Text(
                              'عدد المتطوعين',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomdField(
                            controller: volunteersController,
                            hintText: 'أدخل عدد المتطوعين',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // عدد الساعات

                // مكان الفعالية
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'مكان الفعالية',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 10),
                CustomdField(
                  controller: locationController,
                  hintText: 'أدخل مكان الفعالية',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                // Dropdown القسم
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text('القسم', style: TextStyle(fontFamily: 'Cairo')),
                ),
                const SizedBox(height: 10),
                CustomDropdownField(
                  value: selectedDepartment,
                  items: departments,
                  hintText: "القسم",
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "يرجى اختيار القسم" : null,
                ),

                const SizedBox(height: 16),

                // المشرف
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text('المشرف', style: TextStyle(fontFamily: 'Cairo')),
                ),
                const SizedBox(height: 10),
                CustomdField(
                  controller: supervisorController,
                  hintText: 'أدخل اسم المشرف',
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 16),

                // وصف الفعالية
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'وصف الفعالية',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 10),
                CustomdField(
                  controller: descriptionController,
                  hintText: 'أدخل وصف الفعالية',
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 20),

                // زر إنشاء
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () async {
                        String imagePath = '';
                        final newEvent = Event(
                          imageUrl: imagePath,
                          date: dateController.text,
                          time: timeController.text,
                          category: selectedDepartment ?? "",
                          title: nameController.text,
                          description: descriptionController.text,
                          place: locationController.text,
                          totalVolunteers:
                              int.tryParse(volunteersController.text) ?? 0,
                          joinedVolunteers: 0,
                          hours: int.tryParse(hoursController.text) ?? 0,
                          leader: supervisorController.text,
                        );

                        Navigator.pop(context, newEvent);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // لون الزر
                        foregroundColor: Colors.white, // لون النص والأيقونات

                        textStyle: const TextStyle(
                          // شكل النص
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          // شكل الحواف
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // الظل
                      ),
                      child: Center(child: const Text("تعديل الفعالية")),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
