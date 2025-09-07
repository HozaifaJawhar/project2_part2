import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/helper/build_image_url.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/screens/drawer_screens/events_screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:ammerha_management/core/provider/%20events%20management/events_provider.dart';

class OpportunityCard extends StatelessWidget {
  final Event event;

  final VoidCallback? onTap; // باراميتر جديد
  const OpportunityCard({super.key, required this.event, this.onTap});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('yyyy/MM/dd - HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final outerCtx = context;

    Future<void> _handleDelete() async {
      const secure = FlutterSecureStorage();
      final token = await secure.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        final preMessenger = ScaffoldMessenger.maybeOf(outerCtx);
        preMessenger?.showSnackBar(
          const SnackBar(content: Text('فشل الحصول على التوكن')),
        );
        return;
      }

      final preMessenger = ScaffoldMessenger.maybeOf(outerCtx);
      final provider = Provider.of<EventsProvider>(outerCtx, listen: false);
      final ok = await provider.deleteEvent(token: token, eventId: event.id);
      if (ok) {
        ScaffoldMessenger.of(
          outerCtx,
        ).showSnackBar(const SnackBar(content: Text('تم حذف الفعالية')));
      } else {
        final err = provider.deleteError ?? 'فشل حذف الفعالية';
        ScaffoldMessenger.of(
          outerCtx,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }

    void _showDeleteConfirmationDialog(BuildContext ctx) {
      showDialog(
        context: ctx,
        barrierDismissible: false, // ما بيسكر إلا بزر
        builder: (BuildContext dialogCtx) {
          return Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'هل أنت متأكد أنك تريد حذف هذه الفعالية',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // زر إلغاء
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogCtx).pop(); // بسكر الحوار
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryWhite,
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
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // زر حذف
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogCtx).pop();
                          await _handleDelete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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

    final String dateText = _formatDate(event.date);

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => EventDetailsScreen(eventId: event.id),
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(1, 1)),
          ],
        ),
        child: Row(
          children: [
            // صورة الفعالية
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: event.coverImage != null
                    ? Image.network(
                        event.coverImage!,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/event_image.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/event_image.jpg',
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
                    event.name,
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
                      const SizedBox(width: 3),
                      Text(
                        dateText,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => EditEventInfo(eventId: event.id),
                          //   ),
                          // );
                        },
                        child: const Icon(
                          size: 22,
                          Icons.edit_calendar_outlined,
                          color: Colors.amberAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showDeleteConfirmationDialog(context),
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
            // سهم التفاصيل
            GestureDetector(
              onTap: onTap,
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
                child: const Center(
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
