import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/filter_options.dart';
import 'package:ammerha_management/core/models/volunteer.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/honorBaord/filter_bar.dart';
import 'package:ammerha_management/widgets/honorBaord/filter_screen.dart';
import 'package:ammerha_management/widgets/honorBaord/rest_volunteer.dart';
import 'package:ammerha_management/widgets/honorBaord/top_three.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HonorBoardScreen extends StatefulWidget {
  const HonorBoardScreen({super.key});

  @override
  State<HonorBoardScreen> createState() => _HonorBoardScreenState();
}

class _HonorBoardScreenState extends State<HonorBoardScreen> {
  final List<Volunteer> volunteers = [
    Volunteer(
      name: 'صفيه الأنصاري',
      imageUrl: '',
      rank: 1,
      opportunities: 22,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'هدى الكافي',
      imageUrl: '',
      rank: 2,
      opportunities: 18,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'نور جنيد',
      imageUrl: '',
      rank: 3,
      opportunities: 17,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'سمير الجودر',
      imageUrl: '',
      rank: 4,
      opportunities: 17,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'زين الجودر',
      imageUrl: '',
      rank: 5,
      opportunities: 14,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'زينب الأنصاري',
      imageUrl: '',
      rank: 6,
      opportunities: 13,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'أحمد الصالح',
      imageUrl: '',
      rank: 7,
      opportunities: 12,
      tier: RankTier.gold,
    ),
    Volunteer(
      name: 'فاطمة العلي',
      imageUrl: '',
      rank: 8,
      opportunities: 11,
      tier: RankTier.gold,
    ),
  ];

  // Manages the currently applied filter options.
  FilterOptions _currentFilters = FilterOptions(
    department: 'كل الأقسام',
    timePeriod: TimePeriod.currentYear,
  );

  // Navigates to the filter screen and updates the state with the returned options.
  void _openFilterScreen() async {
    final result = await Navigator.push<FilterOptions>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(initialFilters: _currentFilters),
      ),
    );
    if (result != null) {
      setState(() {
        _currentFilters = result;
        print(
          'Filter applied: Department=${_currentFilters.department}, Time=${_currentFilters.timePeriod}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topThree = volunteers.where((v) => v.rank <= 3).toList();
    final otherVolunteers = volunteers.where((v) => v.rank > 3).toList();
    topThree.sort((a, b) => a.rank.compareTo(b.rank));
    otherVolunteers.sort((a, b) => a.rank.compareTo(b.rank));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'لوحة الشرف',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              FilterBarWidget(
                currentFilters: _currentFilters,
                onTap: _openFilterScreen,
              ),
              const SizedBox(height: 10),
              if (topThree.length == 3)
                TopThreePodiumWidget(topThree: topThree),
              const SizedBox(height: 20),
              RankListWidget(volunteers: otherVolunteers),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
