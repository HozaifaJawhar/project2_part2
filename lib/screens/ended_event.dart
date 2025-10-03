import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/%20events%20management/ended_events_provider.dart';
import 'package:ammerha_management/shared/components/rate_event_sheet.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/events/ended_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EndedEvent extends StatefulWidget {
  const EndedEvent({super.key});

  @override
  State<EndedEvent> createState() => _EndedEventState();
}

class _EndedEventState extends State<EndedEvent> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _load() async {
    final token = await _storage.read(key: 'auth_token');
    final p = context.read<EndedEventsProvider>();
    await p.fetchEvents(token: token, force: true);
  }

  Future<void> _refresh() async {
    final token = await _storage.read(key: 'auth_token');
    await context.read<EndedEventsProvider>().refresh(token: token);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EndedEventsProvider>();
    final providerReader = context.read<EndedEventsProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'تقييم الفعاليات ',
          style: GoogleFonts.almarai(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
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
                              onPressed: _load,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (provider.events.isEmpty) {
                      return const Center(child: Text('لا توجد بيانات حالياً'));
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 6,
                          left: 16,
                          right: 16,
                        ),
                        itemCount: provider.events.length,
                        itemBuilder: (context, index) {
                          final event = provider.events[index];
                          return EndedEventCard(
                            event: event,
                            onTap: () => showRateEventSheet(
                              context: context,
                              eventId: event.id,
                              eventName: event.name,
                              // ⬇️ تنزيل يرجّع path لفتحه مباشرة
                              onDownloadTemplate: (id) async {
                                return providerReader.downloadTemplate(id);
                              },
                              onPickFile: () async {
                                // الاختيار يدار داخل الشيت نفسه
                                return null;
                              },
                              onUploadFile: (id, path) async {
                                await providerReader.uploadReport(id, path);
                                await _refresh();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
