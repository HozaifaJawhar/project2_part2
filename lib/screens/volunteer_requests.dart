import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/models/volunteer.dart';
import 'package:ammerha_management/core/models/volunteer_profil_class.dart';
import 'package:ammerha_management/screens/request_profile.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';

import 'package:flutter/material.dart';

class VolunteerRequests extends StatefulWidget {
  const VolunteerRequests({super.key});

  @override
  State<VolunteerRequests> createState() => _VolunteerRequestsState();
}

class _VolunteerRequestsState extends State<VolunteerRequests> {
  List<NewVolunteer> requests = [
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
    NewVolunteer(
      name: 'ميسان',
      imageUrl: 'assets/images/profile.png',
      address: 'صالحية',
      date: '12/10',
      gender: 'انثى',
      email: 'missan@gmail.com',
      phone: '1234567890',
      department: 'حماية الطفل',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // إلغاء الفوكس عند الضغط برّا
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            'طلبات التطوع ',
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
            child: Column(
              children: [
                SearchTextfield(hintText: 'البحث عن متطوع'),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VolunteerProfileScreen(req: req),
                            ),
                          );
                        },
                        child: Container(
                          height: 77,
                          margin: const EdgeInsets.symmetric(vertical: 4),
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
                            textDirection:
                                TextDirection.rtl, // لضبط المحاذاة من اليمين
                            children: [
                              Container(
                                width: 60,
                                height: 50,
                                child: Image.asset(req.imageUrl),
                              ),
                              SizedBox(width: 5),

                              /// اسم القسم
                              Expanded(
                                child: Text(
                                  req.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 56, 51, 51),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
