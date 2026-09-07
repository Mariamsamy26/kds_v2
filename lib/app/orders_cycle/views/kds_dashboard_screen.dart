import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../../history_cycle/views/history_dashboard_screen.dart';
import '../providers/kds_provider.dart';
import '../widgets/kds_filter_tabs.dart';
import '../widgets/kds_header.dart';
import '../widgets/kds_order_card.dart';
import '../widgets/kds_sidebar.dart';

class KdsDashboardScreen extends StatelessWidget {
  const KdsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KdsProvider>();
    final orders = provider.filteredOrders;

    return Scaffold(
      backgroundColor: KdsColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header with activeTab 'live'
            KdsHeader(
              activeTab: 'live',
              onTabChanged: (tab) {
                if (tab == 'history') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HistoryDashboardScreen(),
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
                  const KdsSidebar(),

                  // Orders Dashboard Display Grid
                  Expanded(
                    child: Column(
                      children: [
                        // Category Filter Tabs
                        const KdsFilterTabs(),

                        // Grid View of Orders Cards
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: provider.isLoading
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40.r,
                                          height: 40.r,
                                          child: const CircularProgressIndicator(
                                            color: KdsColors.primaryBlue,
                                            strokeWidth: 3.5,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'loading'.tr(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: KdsColors.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : orders.isEmpty
                                    ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 48.r,
                                          color: KdsColors.textMuted,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'no_orders'.tr(gender: 'none'),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: KdsColors.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : LayoutBuilder(
                                    builder: (context, constraints) {
                                      int crossAxisCount = 3;
                                      if (constraints.maxWidth < 900) {
                                        crossAxisCount = 2;
                                      }
                                      if (constraints.maxWidth < 600) {
                                        crossAxisCount = 1;
                                      }

                                      return GridView.builder(
                                        itemCount: orders.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 16.w,
                                              mainAxisSpacing: 16.h,
                                              childAspectRatio: 0.85,
                                            ),
                                        itemBuilder: (context, index) {
                                          return KdsOrderCard(
                                            order: orders[index],
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
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
