import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event_class.dart';
import 'package:ammerha_management/screens/edit_event_info.dart';
import 'package:ammerha_management/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpportunityCard extends StatelessWidget {
  final Event event;

  const OpportunityCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false, // ما بيسكر إلا بزر
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة تحذير
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 182, 31, 20),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // النص
                  Text(
                    'هل أنت متأكد أنك تريد حذف هذه الفعالية',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // أزرار (إلغاء + حذف)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // زر إلغاء
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // بسكر الحوار
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.almarai(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // زر حذف
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // هون بتحطي كود الحذف الفعلي
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 182, 31, 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'حذف',
                          style: GoogleFonts.almarai(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                          _showDeleteConfirmationDialog(context);
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
