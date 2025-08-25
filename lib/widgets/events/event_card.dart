import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event_class.dart';
import 'package:ammerha_management/screens/edit_event_info.dart';
import 'package:ammerha_management/screens/event_details_screen.dart';
import 'package:ammerha_management/widgets/basics/dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpportunityCard extends StatelessWidget {
  final Event event;

  const OpportunityCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    void _showDeleteDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomConfirmationDialog(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.red,
            message: 'هل أنت متأكد أنك تريد حذف هذه الفعالية؟',
            cancelText: 'إلغاء',
            confirmText: 'حذف',
            confirmButtonColor: AppColors.primary,
            onConfirm: () {
              // كود الحذف الفعلي
              print("تم الحذف ✅");
            },
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => EventDetailsScreen(event: event),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // لون الظل
              blurRadius: 1, // نعومة الظل
              offset: const Offset(1, 1), // اتجاهه (0,0) = كل الجهات
            ),
          ],
        ),

        child: Row(
          children: [
            // صورة الفعالية
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image(
                  image: AssetImage(event.imageUrl),
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // معلومات الفعالية
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        size: 17,
                        Icons.date_range_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 3),
                      Text(
                        event.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEventInfo(),
                            ),
                          );
                        },
                        child: const Icon(
                          size: 22,
                          Icons.edit_calendar_outlined,
                          color: Colors.amberAccent,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _showDeleteDialog(context);
                        },
                        child: const Icon(
                          size: 22,
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(event: event),
                  ),
                );
              },
              child: Container(
                width: 37,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.arrow_forward, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
