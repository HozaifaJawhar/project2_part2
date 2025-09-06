import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/filter_options.dart';
import 'package:ammerha_management/core/provider/honor_board_provider.dart';
import 'package:ammerha_management/widgets/basics/drawer.dart';
import 'package:ammerha_management/widgets/honorBaord/filter_bar.dart';
import 'package:ammerha_management/widgets/honorBaord/filter_screen.dart';
import 'package:ammerha_management/widgets/honorBaord/rest_volunteer.dart';
import 'package:ammerha_management/widgets/honorBaord/top_three.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HonorBoardScreen extends StatefulWidget {
  const HonorBoardScreen({super.key});

  @override
  State<HonorBoardScreen> createState() => _HonorBoardScreenState();
}

class _HonorBoardScreenState extends State<HonorBoardScreen> {
  FilterOptions _currentFilters = FilterOptions(
    department: 'كل الأقسام',
    timePeriod: TimePeriod.currentYear,
  );

  @override
  void initState() {
    super.initState();
    // تحميل أولي
    Future.microtask(() => context.read<HonorBoardProvider>().load());
  }

  void _openFilterScreen() async {
    final result = await Navigator.push<FilterOptions>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(initialFilters: _currentFilters),
      ),
    );
    if (result != null) {
      setState(() => _currentFilters = result);
      // إن رغبت بتطبيق الفلاتر على السيرفر لاحقاً، مرّرها في الخدمة ثم reload
      context.read<HonorBoardProvider>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HonorBoardProvider>();
    final topThree = provider.topThree();
    final others = provider.others();

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
        child: RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? ListView(
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.error, color: Colors.red.shade400, size: 48),
                    const SizedBox(height: 12),
                    Center(child: Text(provider.error!)),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => provider.load(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      RankListWidget(volunteers: others),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
