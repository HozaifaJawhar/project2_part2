import 'package:ammerha_management/core/models/news_item.dart';
import 'package:ammerha_management/widgets/basics/safe_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.newsItem, required this.onTap});

  static const String _fallbackAsset = 'assets/images/event_image.jpg';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 96,
                  color: Colors.grey[300],
                  // safe image to treate all cases of get image
                  child: SafeImage(
                    urlOrAsset: newsItem.imageUrl,
                    fallbackAsset: _fallbackAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        newsItem.title,
                        style: GoogleFonts.almarai(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,

                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          // In the model, we have prepared a getter named `date` that returns a formatted date (arDate)
                          newsItem.date,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
