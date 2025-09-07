import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/news_item.dart';
import 'package:ammerha_management/shared/dialogs/confirm_dialog.dart';
import 'package:ammerha_management/widgets/basics/safe_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ammerha_management/core/provider/news_provider.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;
  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    SafeImage(
                      urlOrAsset: newsItem.imageUrl,
                      fallbackAsset: 'assets/images/event_image.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: GoogleFonts.almarai(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'تاريخ النشر ${newsItem.date}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      newsItem.body,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('حذف الخبر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'حذف الخبر',
                  message: 'هل أنت متأكد من حذف هذا الخبر؟',
                  confirmText: 'حذف',
                  confirmColor: AppColors.primary,
                );
                if (confirmed != true) return;

                final ok = await context.read<NewsProvider>().removeById(
                  newsItem.id,
                );
                if (!ok) {
                  final err = context.read<NewsProvider>().error ?? 'فشل الحذف';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(err)));
                  return;
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
