import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/helper/build_image_url.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class EndedEventCard extends StatelessWidget {
  final Event event;

  final VoidCallback? onTap; // باراميتر جديد
  const EndedEventCard({super.key, required this.event, this.onTap});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('yyyy/MM/dd - HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final outerCtx = context;

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
                child: _EventCoverImage(url: event.coverImage?.file),
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
                  child: RotatedBox(
                    quarterTurns: -1, // -1 = 90 درجة لليسار
                    child: Text(
                      "تقييم",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCoverImage extends StatelessWidget {
  final String? url;
  const _EventCoverImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final normalized = BuildImageUrl.normalize(url, AppString.baseUrl);

    if (normalized.isEmpty) {
      return const Image(
        image: AssetImage('assets/images/event_image.jpg'),
        width: 75,
        height: 75,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      normalized,
      width: 75,
      height: 75,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Image(
        image: AssetImage('assets/images/event_image.jpg'),
        width: 75,
        height: 75,
        fit: BoxFit.cover,
      ),
    );
  }
}
