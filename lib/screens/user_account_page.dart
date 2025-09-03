import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import 'create_account_page.dart';

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({
    super.key,
    this.name = 'حذيفة جوهر',
    this.address = 'دمشق - برامكة',
    this.dob = '1900/11/1',
    this.gender = 'ذكر',
    this.email = 'hozaifajawhar@gmail.com',
    this.phone = '0962262641',
    this.domain = 'HR',
    this.department = 'الصحة والتغذية الصحي',
  });

  final String name;
  final String address;
  final String dob;
  final String gender;
  final String email;
  final String phone;
  final String domain;
  final String department;

  @override
  Widget build(BuildContext context) {
    const vGap = SizedBox(height: 18);

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
          'حساب المستخدم',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Column(
            children: [
              ProfileImage(),

              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          vGap,
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                children: [
                  _infoRow('العنوان', address),
                  _infoRow('تاريخ الميلاد', dob),
                  _infoRow('الجنس', gender),
                  _infoRow('البريد الإلكتروني', email),
                  _infoRow('رقم الهاتف', phone),
                  _infoRow('المجال الإداري', domain),
                  _infoRow('القسم', department),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    formKey: GlobalKey(),
                    text: 'حذف الحساب',
                    background: AppColors.primary,
                    foreground: Colors.white,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: CustomElevatedButton(
                    formKey: GlobalKey(),
                    text: 'تعديل',
                    background: Colors.white,
                    foreground: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE9EDF4))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 15.5),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
