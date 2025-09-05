import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/provider/volunteer_requests_provider.dart';
import 'package:ammerha_management/screens/request_profile.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VolunteerRequests extends StatefulWidget {
  const VolunteerRequests({super.key});

  @override
  State<VolunteerRequests> createState() => _VolunteerRequestsState();
}

class _VolunteerRequestsState extends State<VolunteerRequests> {
  @override
  void initState() {
    super.initState();
    // تحميل أولي
    Future.microtask(() => context.read<VolunteerRequestsProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VolunteerRequestsProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            'طلبات التطوع',
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: CustomDrawer(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SearchTextfield(
                  hintText: 'البحث عن متطوع',
                  onChanged: prov.setSearch,
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (prov.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (prov.error != null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'حدث خطأ أثناء الجلب:\n${prov.error}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.almarai(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: prov.load,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        );
                      }

                      final items = prov.items;
                      if (items.isEmpty) {
                        return const Center(
                          child: Text('لا توجد طلبات حالياً'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: prov.refresh,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final req = items[index];
                            return _RequestTile(req: req);
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
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  final NewVolunteer req;
  const _RequestTile({required this.req});

  @override
  Widget build(BuildContext context) {
    final dept = (req.departmentName ?? '').isEmpty ? null : req.departmentName;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VolunteerProfileScreen(req: req),
          ),
        );
      },
      child: Container(
        height: 77,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              height: double.maxFinite,
              width: 56,
              clipBehavior: Clip.hardEdge,
              child: _avatar(req.imageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                req.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (dept != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dept,
                  style: GoogleFonts.almarai(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String? imageUrl) {
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl.startsWith('assets/')) {
      return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset('assets/images/profile.png', fit: BoxFit.cover);
      },
    );
  }
}
