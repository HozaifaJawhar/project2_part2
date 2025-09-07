import 'package:ammerha_management/core/helper/api.dart';
import 'package:ammerha_management/core/provider/%20events%20management/events_provider.dart';
import 'package:ammerha_management/core/services/events_service.dart';
import 'package:ammerha_management/screens/drawer_screens/events_screens/create_event.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/events/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _ensureFetch(BuildContext context) async {
    // CHANGE: We fetch the token and then launch the fetch from within the page after building
    final token = await _storage.read(key: 'auth_token');

    final p = context.read<EventsProvider>();
    if (!p.isLoading && p.events.isEmpty) {
      await p.fetchEvents(token: token, force: true);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    final token = await _storage.read(key: 'auth_token');
    await context.read<EventsProvider>().refresh(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventsProvider>(
      create: (_) => EventsProvider(EventsService(Api())),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _ensureFetch(context);
          });
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
                child: Consumer<EventsProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return RefreshIndicator(
                        onRefresh: () => _refresh(context), // NEW
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(), // NEW
                          children: [
                            const SizedBox(height: 120),
                            Center(child: Text('خطأ: ${provider.error}')),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => _refresh(context),
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
                                      border: Border.all(
                                        color: AppColors.grey2,
                                        width: 1,
                                      ),
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
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 8,
                                    ),
                                    child: SizedBox(
                                      height: 50,
                                      child: SearchTextfield(
                                        hintText: 'البحث عن فرصة',
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                              ),
                              child: ListView.builder(
                                itemCount: provider.events.length,
                                itemBuilder: (context, index) {
                                  final event = provider.events[index];
                                  return OpportunityCard(event: event);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final newEvent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateEventPage(),
                    ),
                  );
                  if (newEvent != null) {
                    setState(() {
                      //events.add(newEvent);
                    });
                  }
                },
                tooltip: 'Increment',
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ), // ←
            ),
          );
        },
      ),
    );
  }
}
