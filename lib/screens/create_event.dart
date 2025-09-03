import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/theme/app_theme.dart';
import '../core/models/event_class.dart';
import '../widgets/events/dropdownField.dart';
import '../widgets/events/text_field.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  //اعطاء الاذون
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

  final _formKey = GlobalKey<FormState>();

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
  //validation fun
  String? _required(String? v, String name) {
    if (v == null || v.trim().isEmpty) return 'يرجى إدخال $name';
    return null;
  }

  String? _positiveInt(String? v, String name, {int min = 1}) {
    if (v == null || v.trim().isEmpty) return 'يرجى إدخال $name';
    final n = int.tryParse(v);
    if (n == null) return 'يرجى إدخال رقم صحيح لـ $name';
    if (n < min) return '$name يجب أن يكون ${min} فما فوق';
    return null;
  }

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
            'إنشاء فعالية جديدة',
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                FormField<XFile?>(
                  validator: (_) {
                    if (_selectedImage == null) {
                      return 'يرجى اختيار صورة للفعالية';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: field.hasError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_selectedImage!.path),
                                      ),
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
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, right: 4),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

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
                  validator: (v) => _required(v, 'اسم الفعالية'),
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
                            validator: (v) =>
                                _positiveInt(v, 'عدد الساعات', min: 1),
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
                            validator: (v) =>
                                _positiveInt(v, 'عدد المتطوعين', min: 1),
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
                  validator: (v) => _required(v, 'مكان الفعالية'),
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
                  validator: (v) => _required(v, 'اسم المشرف'),
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
                  validator: (v) => _required(v, 'وصف الفعالية'),
                ),

                const SizedBox(height: 20),

                // زر إنشاء
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus(); // إغلاق الكيبورد
                        if (!_formKey.currentState!.validate()) {
                          // لو في أخطاء، ما بنكمل
                          return;
                        }

                        final imagePath = _selectedImage?.path ?? '';

                        final newEvent = Event(
                          imageUrl: imagePath,
                          date: dateController.text,
                          time: timeController.text,
                          category: selectedDepartment ?? "",
                          title: nameController.text,
                          description: descriptionController.text,
                          place: locationController.text,
                          totalVolunteers: int.parse(volunteersController.text),
                          joinedVolunteers: 0,
                          hours: int.parse(hoursController.text),
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
                      child: Center(child: const Text("إنشاء الفعالية")),
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
