import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/news_item.dart';
import 'package:ammerha_management/screens/drawer_screens/news_screens/add_news.dart';
import 'package:ammerha_management/screens/drawer_screens/news_screens/news_details.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/news/news_card.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int currentIndex = 3;

  // Sample news data
  final List<NewsItem> newsItems = [
    NewsItem(
      id: '1',
      title:
          'انضموا إلينا في رحلة تطوعية إلى بلودان حيث الطبيعة تلتقي بالإلهام',
      imageUrl: 'assets/images/event_image.jpg',
      date: '22 حزيران 2023',
    ),
    NewsItem(
      id: '2',
      title:
          'انضموا إلينا في رحلة تطوعية إلى بلودان حيث الطبيعة تلتقي بالإلهام',
      imageUrl: 'assets/images/event_image.jpg',
      date: '22 حزيران 2023',
    ),
    NewsItem(
      id: '3',
      title:
          'انضموا إلينا في رحلة تطوعية إلى بلودان حيث الطبيعة تلتقي بالإلهام',
      imageUrl: 'assets/images/event_image.jpg',
      date: '22 حزيران 2023',
    ),
    NewsItem(
      id: '4',
      title:
          'انضموا إلينا في رحلة تطوعية إلى بلودان حيث الطبيعة تلتقي بالإلهام',
      imageUrl: 'assets/images/event_image.jpg',
      date: '22 حزيران 2023',
    ),
    NewsItem(
      id: '5',
      title:
          'انضموا إلينا في رحلة تطوعية إلى بلودان حيث الطبيعة تلتقي بالإلهام',
      imageUrl: 'assets/images/event_image.jpg',
      date: '22 حزيران 2023',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'الأخبار ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Cairo',
            fontSize: 25,
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
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: NewsCard(
                  newsItem: newsItems[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(newsItem: newsItems[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNews()),
          );
        },
        tooltip: 'Increment',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
