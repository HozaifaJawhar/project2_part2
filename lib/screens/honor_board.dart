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
    // initial laod
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
      // If you want to apply the filters to the server later, pass them through the service and then reload.
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Same filter bar above the content
              FilterBarWidget(
                currentFilters: _currentFilters,
                onTap: _openFilterScreen,
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Builder(
                  builder: (_) {
                    // initial loading
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // error
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
                              onPressed: provider.load,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    // when there is no data
                    final hasTop3 = topThree.length == 3;
                    final hasOthers = others.isNotEmpty;
                    if (!hasTop3 && !hasOthers) {
                      return const Center(child: Text('لا توجد بيانات حالياً'));
                    }

                    // Existing data: We display it inside a RefreshIndicator that wraps the ListView.
                    return RefreshIndicator(
                      onRefresh: provider.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 6),
                          if (hasTop3) TopThreePodiumWidget(topThree: topThree),
                          if (hasTop3) const SizedBox(height: 20),
                          if (hasOthers) RankListWidget(volunteers: others),
                          const SizedBox(height: 20),
                        ],
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
