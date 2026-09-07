import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../styles/kds_colors.dart';
import '../../orders_cycle/views/kds_dashboard_screen.dart';
import '../../orders_cycle/widgets/kds_header.dart';
import '../widgets/history_filter_bar.dart';
import '../widgets/history_kpi_cards.dart';
import '../widgets/history_orders_table.dart';

class HistoryDashboardScreen extends StatelessWidget {
  const HistoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KdsColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header with activeTab 'history'
            KdsHeader(
              activeTab: 'history',
              onTabChanged: (tab) {
                if (tab == 'live') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const KdsDashboardScreen(),
                    ),
                  );
                }
              },
            ),

            // Main Body Area
            Expanded(
              child: Row(
                children: [
                  // Side Navigation Menu
                  // const KdsSidebar(),

                  // History Main Display Container
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top 4 KPI Summary Cards
                          const HistoryKpiCards(),

                          SizedBox(height: 14.h),

                          // Search & Filters Bar
                          const HistoryFilterBar(),

                          SizedBox(height: 14.h),

                          // History Orders Data Table
                          const Expanded(child: HistoryOrdersTable()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
