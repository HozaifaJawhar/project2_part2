import 'dart:io';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/create_event_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:ammerha_management/core/provider/Department_Provider.dart';
import 'package:ammerha_management/core/models/departmentClass.dart';
import 'package:ammerha_management/core/provider/%20events%20management/events_provider.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(); // yyyy-MM-dd
  final TextEditingController timeController = TextEditingController(); // HH:mm
  final TextEditingController hoursMinController =
      TextEditingController(); // CHANGE: أدنى ساعات
  final TextEditingController hoursMaxController =
      TextEditingController(); // CHANGE: أقصى ساعات
  final TextEditingController volunteersController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController supervisorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? _pickedDate; // NEW
  TimeOfDay? _pickedTime; // NEW

  // ===== الأقسام من المزود =====
  final _secure = const FlutterSecureStorage();
  int? selectedDepartmentId; // NEW: نخزن id المختار
  String? selectedDepartmentName; // NEW: اختياري لعرض الاسم

  @override
  void initState() {
    super.initState();
    // NEW: اجلب الأقسام بعد بناء الشجرة
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await _secure.read(key: 'auth_token'); // المفتاح الصحيح
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        await context
            .read<DepartmentProvider>()
            .getDepartments(); // يستخدم خدمتك الحالية
      }
    });
  }

  // ===== Image Picker Permissions =====
  Future<void> _pickImage() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }
      if (status.isDenied && await Permission.storage.request().isGranted) {
        status = PermissionStatus.granted;
      }
    } else {
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );
      if (pickedFile != null) setState(() => _selectedImage = pickedFile);
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يجب منح إذن الوصول للصور")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // ===== Validators =====
  String? _required(String? v, String name) {
    if (v == null || v.trim().isEmpty) return 'يرجى إدخال $name';
    return null;
  }

  String? _positiveInt(String? v, String name, {int min = 1}) {
    if (v == null || v.trim().isEmpty) return 'يرجى إدخال $name';
    final n = int.tryParse(v);
    if (n == null) return 'يرجى إدخال رقم صحيح لـ $name';
    if (n < min) return '$name يجب أن يكون $min فما فوق';
    return null;
  }

  // ===== Compose DateTime =====
  DateTime? _composeDateTime() {
    if (_pickedDate == null || _pickedTime == null) return null;
    return DateTime(
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour,
      _pickedTime!.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = context.watch<EventsProvider>().isCreating;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.primary),
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: const Text(
            'إنشاء فعالية جديدة',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              fontSize: 25,
              color: AppColors.primary,
            ),
          ),
        ),
        body: AbsorbPointer(
          absorbing: isCreating,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // صورة
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: Text(
                      'اختر صورة للفعالية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormField<XFile?>(
                    validator: (_) => _selectedImage == null
                        ? 'يرجى اختيار صورة للفعالية'
                        : null,
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
                            const Padding(
                              padding: EdgeInsets.only(top: 6, right: 4),
                              child: Text(
                                'يرجى اختيار صورة للفعالية',
                                style: TextStyle(
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
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: Text(
                      'اسم الفعالية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: _decoration(
                      context,
                      'أدخل اسم الفعالية',
                      Icons.title,
                    ),
                    validator: (v) => _required(v, 'اسم الفعالية'),
                  ),

                  // التاريخ والوقت
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Text(
                                'تاريخ الفعالية',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  _pickedDate = picked;
                                  setState(() {
                                    dateController.text =
                                        "${picked.year}-${picked.month}-${picked.day}";
                                  });
                                }
                              },
                              decoration: _decoration(
                                context,
                                'أدخل تاريخ الفعالية',
                                Icons.calendar_today,
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "يرجى اختيار التاريخ"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Text(
                                'وقت الفعالية',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: timeController,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  _pickedTime = picked;
                                  setState(() {
                                    timeController.text = picked.format(
                                      context,
                                    );
                                  });
                                }
                              },
                              decoration: _decoration(
                                context,
                                'أدخل وقت الفعالية',
                                Icons.access_time,
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? "يرجى اختيار الوقت"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // أدنى/أقصى ساعات + عدد المتطوعين
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Text(
                                'أدنى ساعات',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: hoursMinController,
                              keyboardType: TextInputType.number,
                              decoration: _decoration(
                                context,
                                'أدخل أدنى الساعات',
                                Icons.timelapse,
                              ),
                              validator: (v) =>
                                  _positiveInt(v, 'أدنى الساعات', min: 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Text(
                                'أقصى ساعات',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: hoursMaxController,
                              keyboardType: TextInputType.number,
                              decoration: _decoration(
                                context,
                                'أدخل أقصى الساعات',
                                Icons.timelapse_outlined,
                              ),
                              validator: (v) =>
                                  _positiveInt(v, 'أقصى الساعات', min: 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // مكان الفعالية
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: Text(
                      'مكان الفعالية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: locationController,
                    decoration: _decoration(
                      context,
                      'أدخل مكان الفعالية',
                      Icons.place,
                    ),
                    validator: (v) => _required(v, 'مكان الفعالية'),
                  ),
                  SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: Text(
                      'عدد المتطوعين',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: volunteersController,
                    keyboardType: TextInputType.number,
                    decoration: _decoration(
                      context,
                      'أدخل عدد المتطوعين المسموح به',
                      Icons.people_alt_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال عدد المتطوعين';
                      }
                      if (int.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صحيح';
                      }
                      return null;
                    },
                  ),
                  // ======== Dropdown from provider ========
                  const SizedBox(height: 16),
                  Consumer<DepartmentProvider>(
                    builder: (context, dpt, _) {
                      if (dpt.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (dpt.error != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: Text(
                                'القسم',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'خطأ في جلب الأقسام: ${dpt.error!}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final token = await _secure.read(
                                  key: 'auth_token',
                                );
                                if (token != null && token.isNotEmpty) {
                                  await dpt.getDepartments();
                                }
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة المحاولة'),
                            ),
                          ],
                        );
                      }

                      final List<Department> items = dpt.departments;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 9),
                            child: Text(
                              'القسم',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<int>(
                            value: selectedDepartmentId,
                            items: items
                                .map(
                                  (dep) => DropdownMenuItem<int>(
                                    value: dep.id,
                                    child: Text(dep.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedDepartmentId = val;
                                selectedDepartmentName = items
                                    .firstWhere((e) => e.id == val!)
                                    .name;
                              });
                            },
                            decoration: _decoration(
                              context,
                              'القسم',
                              Icons.category,
                            ),
                            validator: (v) =>
                                v == null ? 'يرجى اختيار القسم' : null,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: Text(
                      'وصف الفعالية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: _decoration(
                      context,
                      'أدخل وصف الفعالية',
                      Icons.description,
                    ),
                    validator: (v) => _required(v, 'وصف الفعالية'),
                  ),

                  const SizedBox(height: 20),
                  // زر إنشاء
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isCreating
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) return;

                                // تأليف التاريخ والوقت
                                final dt = _composeDateTime();
                                if (dt == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'يرجى اختيار التاريخ والوقت',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (_selectedImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'يرجى اختيار صورة للفعالية',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (selectedDepartmentId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('يرجى اختيار قسم'),
                                    ),
                                  );
                                  return;
                                }

                                final token = await _secure.read(
                                  key: 'auth_token',
                                );
                                if (token == null || token.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('فشل الحصول على التوكن'),
                                    ),
                                  );
                                  return;
                                }

                                // make input ready for the api using the model
                                final input = CreateEventInput(
                                  name: nameController.text.trim(),
                                  description: descriptionController.text
                                      .trim(),
                                  dateTime: dt,
                                  minHours: int.parse(
                                    hoursMinController.text.trim(),
                                  ),
                                  maxHours: int.parse(
                                    hoursMaxController.text.trim(),
                                  ),
                                  location: locationController.text.trim(),
                                  volunteersCount: int.parse(
                                    volunteersController.text.trim(),
                                  ),
                                  departmentId:
                                      selectedDepartmentId!, // CHANGE: هنا الـ id من المزود
                                  coverImagePath: _selectedImage!.path,
                                );

                                final ok = await context
                                    .read<EventsProvider>()
                                    .createEvent(token: token, input: input);

                                if (ok) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم إنشاء الفعالية بنجاح',
                                        ),
                                      ),
                                    );
                                  }
                                  if (mounted) Navigator.pop(context, true);
                                } else {
                                  final err =
                                      context
                                          .read<EventsProvider>()
                                          .createError ??
                                      'فشل إنشاء الفعالية';
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err)),
                                    );
                                  }
                                }
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
                          elevation: 5,
                        ),
                        child: isCreating
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("إنشاء الفعالية"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(
    BuildContext context,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      suffixIcon: Icon(icon, color: AppColors.primary),
      hintText: hint,
      fillColor: AppColors.white,
      hintStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.greyText,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey2, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
