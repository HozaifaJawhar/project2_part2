import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/helper/utils.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/provider/volunteers_provider.dart';
import 'package:ammerha_management/screens/volunteer_profile.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/basics/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPage();
}

class _VolunteersPage extends State<VolunteersPage> {
  @override
  void initState() {
    super.initState();
    // Initial load
    Future.microtask(() => context.read<VolunteersProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VolunteersProvider>();

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
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // More circular border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_alt_sharp,
                          color: AppColors.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SearchTextfield(
                        hintText: 'البحث عن متطوع',
                        onChanged: prov.setSearch,
                      ),
                    ),
                  ],
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
                            final vol = items[index];
                            return _volunteerTile(volunteer: vol);
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

class _volunteerTile extends StatelessWidget {
  final NewVolunteer volunteer;
  const _volunteerTile({required this.volunteer});

  Widget _pointsPill(BuildContext context) {
    final points = volunteer.points ?? 0;
    final rank = volunteer.rank;

    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 10,
        end: 12,
        top: 6,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.navyBlueWithOpacity10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image of the medal
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              RankUtils.medalAsset(rank),
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),

          // number of points + the word "point"
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$points ',
                  style: GoogleFonts.almarai(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'نقطة',
                  style: GoogleFonts.almarai(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String? imageUrl) {
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl.startsWith('assets/')) {
      return const CircleAvatar(
        radius: 35,
        backgroundImage: AssetImage('assets/images/profile.png'),
      );
    }
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VolunteerProfileScreen2(vol: volunteer),
          ),
        );
      },
      child: Container(
        height: 86,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            // Selfie
            _avatar(volunteer.imageUrl),
            const SizedBox(width: 12),

            //Name in the middle
            Expanded(
              child: Text(
                volunteer.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.almarai(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            //Points + Badge
            _pointsPill(context),
          ],
        ),
      ),
    );
  }
}
