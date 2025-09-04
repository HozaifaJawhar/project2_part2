import 'package:ammerha_management/core/models/news_item.dart';
import 'package:flutter/material.dart';

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
            // App Bar with image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      newsItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 64,
                          ),
                        );
                      },
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
            // Content
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      newsItem.id == '4'
                          ? 'Robredo: Elections just start of bigger battle'
                          : newsItem.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Author and date
                    Text(
                      newsItem.date,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    // Content
                    Text(
                      newsItem.id == '4'
                          ? '''MANILA, Philippines — For Vice President Leni Robredo, the outcome of the May 9 elections is just the beginning of the bigger battle.
      
      Without directly acknowledging defeat, Robredo reiterated her call to supporters on Tuesday night to accept the final results, whatever those may be.
      
      "Maybe we have not won this election – or we will not win this election – but I do not consider it a loss," she said in Bikolano after the thanksgiving mass at the Naga Metropolitan Cathedral.
      
      The Vice President emphasized that their campaign was about more than just winning an election. "This is not just about the elections. This is about the future of our democracy and the kind of country we want to leave for our children."
      
      Robredo's statement came as unofficial results showed her trailing significantly behind her closest rival. Despite the challenging results, she maintained her composure and grace throughout her address.
      
      "We fought a good fight. We ran a clean campaign based on truth, transparency, and genuine service to the Filipino people," she continued.
      
      The Vice President thanked her supporters, volunteers, and everyone who believed in their vision for the Philippines. She acknowledged their efforts and sacrifices throughout the campaign period.
      
      "Your dedication and passion have inspired millions of Filipinos. That alone is a victory worth celebrating," Robredo said.
      
      She also called for unity among Filipinos, regardless of political affiliations. "Now more than ever, we need to come together as one nation. Our differences should not divide us but make us stronger."
      
      The Vice President concluded her statement by reaffirming her commitment to continue serving the Filipino people, whether in government or in the private sector.'''
                          : '''نظّمت مؤسسة عمرها رحلة تطوعية ترفيهية إلى مصيف بلودان في ريف دمشق، وذلك يوم الجمعة الواقع في 26/9/2025 تأتي هذه المبادرة في إطار سعي المؤسسة لخلق فرص تواصل بين المتطوعين وإعادة حيوية النشاط الجماعي نعيد شحن طاقتكم، نبني صداقات جديدة، ونحتفل بما حققته فرقنا ، حيث يصبح  التطوع تجربة مميزة في احضان الطبيعة .''',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
