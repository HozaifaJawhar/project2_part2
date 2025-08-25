import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isRegistered = false;
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // اختيار النص حسب الحالة
        String dialogText = isRegistered
            ? 'هل أنت متأكد أنك تريد إلغاء المشاركة؟'
            : 'هل أنت متأكد أنك تريد المشاركة؟';

        return AlertDialog(
          title: const Text('تأكيد'),
          content: Text(dialogText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isRegistered = !isRegistered;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      isRegistered ? 'تم التسجيل بنجاح!' : 'تم إلغاء التسجيل!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );

                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: const Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ],
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            widget.event.title,
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        body: ListView(
          children: [
            Image(
              image: AssetImage(widget.event.imageUrl),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.event.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.event.description,
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'زمان الفعالية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                '${widget.event.date}          الساعة:${widget.event.time}',
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                'عدد المتطوعين',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              child: Row(
                children: [
                  Text(
                    'المطلوب:  ',
                    style: GoogleFonts.almarai(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${widget.event.totalVolunteers}',
                    style: GoogleFonts.almarai(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'المتبقي:  ',
                    style: GoogleFonts.almarai(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${widget.event.joinedVolunteers}',
                    style: GoogleFonts.almarai(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'مكان الفعالية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                widget.event.place,
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'عدد الساعات التطوعية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                '${widget.event.hours}',
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'المشرف على الفعالية:${widget.event.leader}',
                  style: GoogleFonts.almarai(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       _showConfirmationDialog(context);
            //     },
            //     child: Container(
            //       height: 35,
            //       decoration: BoxDecoration(
            //         color: AppColors.primary,
            //         borderRadius: BorderRadius.circular(9),
            //       ),
            //       child: Center(
            //         child: Text(
            //           isRegistered ? 'إلغاء التسجيل' : 'تسجيل',
            //           style: const TextStyle(color: AppColors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
