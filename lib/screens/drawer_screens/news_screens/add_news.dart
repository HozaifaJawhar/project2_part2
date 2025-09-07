import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/news_provider.dart';
import 'package:ammerha_management/widgets/events/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
            'إنشاء خبر جديد',
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.bold,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'اختر صورة للمنشور',
                    style: TextStyle(fontFamily: 'Cairo'),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 10),
                FormField<XFile?>(
                  validator: (_) {
                    if (_selectedImage == null) {
                      return 'يرجى اختيار صورة للمنشور';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'عنوان المنشور',
                    style: TextStyle(fontFamily: 'Cairo'),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 10),
                CustomdField(
                  controller: nameController,
                  hintText: 'أدخل عنوان المنشور',
                  keyboardType: TextInputType.text,
                  validator: (v) => _required(v, 'عنوان المنشور'),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Text(
                    'وصف المنشور',
                    style: TextStyle(fontFamily: 'Cairo'),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6, // أو null
                  decoration: InputDecoration(
                    fillColor: AppColors.white,
                    hintText: 'أدخل تفاصيل المنشور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grey2,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.grey2,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),

                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'يرجى إدخال تفاصيل المنشور';
                    return null;
                  },
                ),
                const SizedBox(height: 45),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState!.validate()) return;

                        final provider = context.read<NewsProvider>();
                        final res = await provider.add(
                          title: nameController.text.trim(),
                          body: descriptionController.text.trim(),
                          imageFile: _selectedImage != null
                              ? File(_selectedImage!.path)
                              : null,
                        );

                        if (provider.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('فشل الإنشاء: ${provider.error}'),
                            ),
                          );
                          return;
                        }

                        // when success
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // الظل
                      ),
                      child: Center(
                        child: Text(
                          "إنشاء المنشور",
                          style: GoogleFonts.almarai(fontSize: 15),
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
  }
}
