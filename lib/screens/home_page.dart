import 'package:ammerha_management/screens/drawer_screens/events_screens/create_event.dart';
import '../config/theme/app_theme.dart';
import '../core/models/event_class.dart';
import '../core/models/volunteer_profil_class.dart';
import '../widgets/basics/drawer.dart';
import '../widgets/events/event_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String image = "assets/images/level1(2).jpg";
  // List<Event> events = [];
  VolunteerProfilClass volunteerProfile = new VolunteerProfilClass(
    profileImageUrl: 'profileImageUrl',
    name: 'missan',
  );
  final List<Event> events = [
    Event(
      imageUrl: 'assets/images/event_image.jpg',
      date: '١ أغسطس ٢٠٢٥',
      time: '1:00',
      category: 'صحي',
      title: 'فعالية التبرع بالدم',
      description:
          'تهدف هذه الفعالية الى تقوية التكاتف الاجتماعي وروح المبادرة والتخفيف عن المرضى وذويهم متاعب البحث عن زمر الدم المطلوبة',
      place: 'مشفى المواساة',
      totalVolunteers: 50,
      joinedVolunteers: 20,
      hours: 2,
      leader: 'ali',
    ),
    Event(
      imageUrl: 'assets/images/event_image.jpg',
      date: '٥ أغسطس ٢٠٢٥',
      time: '1:00',
      category: 'ثقافي',
      title: 'مساعدة في معرض الكتاب',
      description:
          'تهدف هذه الفعالية الى تقوية التكاتف الاجتماعي وروح المبادرة والتخفيف عن المرضى وذويهم متاعب البحث عن زمر الدم المطلوبة',
      place: 'مشفى المواساة',
      totalVolunteers: 30,
      joinedVolunteers: 15,
      hours: 2,
      leader: 'ali',
    ),
    Event(
      imageUrl: 'assets/images/event_image.jpg',
      date: '٥ أغسطس ٢٠٢٥',
      time: '1:00',
      category: 'ثقافي',
      title: 'مساعدة في معرض الكتاب',
      description:
          'تهدف هذه الفعالية الى تقوية التكاتف الاجتماعي وروح المبادرة والتخفيف عن المرضى وذويهم متاعب البحث عن زمر الدم المطلوبة',
      place: 'مشفى المواساة',
      totalVolunteers: 30,
      joinedVolunteers: 15,
      hours: 2,
      leader: 'ali',
    ),
    Event(
      imageUrl: 'assets/images/event_image.jpg',
      date: '٥ أغسطس ٢٠٢٥',
      time: '1:00',
      category: 'ثقافي',
      title: 'مساعدة في معرض الكتاب',
      description:
          'تهدف هذه الفعالية الى تقوية التكاتف الاجتماعي وروح المبادرة والتخفيف عن المرضى وذويهم متاعب البحث عن زمر الدم المطلوبة',
      place: 'مشفى المواساة',
      totalVolunteers: 30,
      joinedVolunteers: 15,
      hours: 2,
      leader: 'ali',
    ),
    Event(
      imageUrl: 'assets/images/event_image.jpg',
      date: '٥ أغسطس ٢٠٢٥',
      time: '1:00',
      category: 'ثقافي',
      title: 'مساعدة في معرض الكتاب',
      description:
          'تهدف هذه الفعالية الى تقوية التكاتف الاجتماعي وروح المبادرة والتخفيف عن المرضى وذويهم متاعب البحث عن زمر الدم المطلوبة',
      place: 'مشفى المواساة',
      totalVolunteers: 30,
      joinedVolunteers: 15,
      hours: 2,
      leader: 'ali',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // إلغاء الفوكس عند الضغط برّا
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            'إدارة الفعاليات ',
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.grey2, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                224,
                                220,
                                220,
                              ), // لون الظل
                              blurRadius: 2, // نعومة الظل
                              offset: const Offset(
                                1,
                                1,
                              ), // اتجاهه (0,0) = كل الجهات
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          size: 30,
                          Icons.filter_alt,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    255,
                                    224,
                                    220,
                                    220,
                                  ), // لون الظل
                                  blurRadius: 1, // نعومة الظل
                                  offset: const Offset(
                                    1,
                                    1,
                                  ), // اتجاهه (0,0) = كل الجهات
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'البحث عن فرصة',

                                fillColor: AppColors.white,
                                suffixIcon: const Icon(Icons.search),
                                suffixIconColor: AppColors.grey2,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors
                                        .grey2, // لون البوردر قبل الضغط
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors
                                        .primary, // لون البوردر عند الضغط
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Text(
                  'الفرص القائمة',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: events.isEmpty
                    ? const Center(child: Text("لا توجد فعاليات بعد"))
                    : Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return OpportunityCard(event: events[index]);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newEvent = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEventPage()),
            );
            if (newEvent != null) {
              setState(() {
                events.add(newEvent);
              });
            }
          },
          tooltip: 'Increment',
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ), // ←
      ),
    );
  }
}
