import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  String? dept;
  String? domain;

  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  String? gender;

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    dobCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const vGap = SizedBox(height: 14);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
        ),
        title: const Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const ProfileAvatarPicker(),
              const SizedBox(height: 18),

              label(text: 'الاسم الثلاثي'),

              AppTextField(
                controller: nameCtrl,
                hint: 'أدخل الاسم الثلاثي',
                textInputAction: TextInputAction.next,
              ),
              vGap,
              label(text: 'العنوان'),

              // العنوان
              AppTextField(
                controller: addressCtrl,
                hint: 'أدخل العنوان',
                textInputAction: TextInputAction.next,
              ),
              vGap,

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(text: 'الجنس'),

                        AppDropdown<String>(
                          hint: 'الجنس',
                          value: gender,
                          items: const ['ذكر', 'أنثى'],
                          itemBuilder: (s) =>
                              DropdownMenuItem(value: s, child: Text(s)),
                          onChanged: (v) => setState(() => gender = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        label(text: 'تاريخ الميلاد'),

                        AppDateField(
                          controller: dobCtrl,
                          hint: 'أدخل تاريخ ميلادك',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              vGap,
              label(text: 'القسم'),

              AppDropdown<String>(
                hint: 'أدخل القسم الذي تنتمي إليه',
                value: dept,
                items: const [
                  'قسم الموارد البشرية',
                  'قسم التطوع',
                  'قسم المحاسبة',
                ],
                itemBuilder: (s) => DropdownMenuItem(value: s, child: Text(s)),
                onChanged: (v) => setState(() => dept = v),
              ),
              vGap,
              label(text: 'المجال الاداري'),

              AppDropdown<String>(
                hint: 'أدخل المجال الإداري',
                value: domain,
                items: const [
                  'hr',
                  'منسق',
                ],
                itemBuilder: (s) => DropdownMenuItem(value: s, child: Text(s)),
                onChanged: (v) => setState(() => domain = v),
              ),
              vGap,

              label(text: 'رقم الهاتف'),

              AppPhoneInput(
                codeText: '+963',
                phoneController: phoneCtrl,
                hint: 'Phone No.',
              ),
              vGap,
              label(text: 'البريد الاكتروني'),

              AppTextField(
                controller: emailCtrl,
                hint: 'أدخل بريدك الإلكتروني',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 75),
                child: CustomElevatedButton(
                  formKey: _formKey,
                  text: 'إنشاء الحساب',
                  background: AppColors.primary,
                  foreground: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;
  final String text;
  final Color background;
  final Color foreground;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // if (!_formKey.currentState!.validate()) return;
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class label extends StatelessWidget {
  const label({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 8),
      child: Text(text),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: hint,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 10,
        ),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
  });

  final String hint;
  final T? value;
  final List<T> items;
  final DropdownMenuItem<T> Function(T item) itemBuilder;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hint: Text(hint, style: TextStyle(color: Colors.grey)),
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 10,
        ),
      ),
      items: items.map(itemBuilder).toList(),
      onChanged: onChanged,
    );
  }
}

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.controller,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  final TextEditingController controller;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = widget.firstDate ?? DateTime(1900);
    final last = widget.lastDate ?? DateTime(now.year, now.month, now.day);
    final init = widget.initialDate ?? DateTime(now.year - 20, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: first,
      lastDate: last,
      helpText: 'اختر تاريخ الميلاد',
      cancelText: 'إلغاء',
      confirmText: 'تم',
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    );
    if (picked != null) {
      widget.controller.text = "${picked.year}/${picked.month}/${picked.day}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hint: widget.hint,
      readOnly: true,
      onTap: _pickDate,
      suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
    );
  }
}

class AppPhoneInput extends StatelessWidget {
  const AppPhoneInput({
    super.key,
    required this.codeText,
    required this.phoneController,
    required this.hint,
  });

  final String codeText;
  final TextEditingController phoneController;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,

            child: AppTextField(
              controller: phoneController,
              hint: hint,
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
        const SizedBox(width: 12),

        SizedBox(
          width: 92,
          child: Directionality(
            textDirection: TextDirection.ltr,

            child: TextFormField(
              initialValue: codeText,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileImage(),

              Positioned(
                bottom: -1,
                right: -2,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      //لاضافة صورة
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.add_a_photo_outlined, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'اختر صورة شخصية (اختياري)',
            style: TextStyle(color: Colors.grey.shade900, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 8)),
        ],
      ),
      child: const CircleAvatar(
        radius: 50,
        backgroundColor: Color(0xFFE9EDF5),
        child: Icon(Icons.person, size: 80, color: Colors.white),
      ),
    );
  }
}
