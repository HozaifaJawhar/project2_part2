import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/news_provider.dart';
import 'package:ammerha_management/screens/drawer_screens/news_screens/add_news.dart';
import 'package:ammerha_management/screens/drawer_screens/news_screens/news_details.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/news/news_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    // Load news when the screen opens (we can remove it when we call load() in main via ..load()) but here we want to laod the news when we open this page, not when we start the app
    Future.microtask(() => context.read<NewsProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'الأخبار ',
          style: GoogleFonts.almarai(
            fontWeight: FontWeight.bold,
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(
          builder: (_) {
            // initial load status
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            // error status
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'حدث خطأ أثناء الجلب:\n${provider.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.almarai(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            // when there is no data..
            if (provider.items.isEmpty) {
              return const Center(child: Text('لا توجد أخبار'));
            }

            // Menu + Pull to refresh
            return RefreshIndicator(
              onRefresh: provider.load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NewsCard(
                      newsItem: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailScreen(newsItem: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNews()),
          );
          // After returning from the add-on, we update the list
          if (mounted) context.read<NewsProvider>().load();
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
