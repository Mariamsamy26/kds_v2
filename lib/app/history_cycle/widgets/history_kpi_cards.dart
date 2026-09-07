import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../providers/history_provider.dart';

class HistoryKpiCards extends StatelessWidget {
  const HistoryKpiCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final metrics = provider.metrics;
    final totalOrders = provider.filteredHistoryOrders.length;
    final isAr = context.locale.languageCode == 'ar';

    String prepSubtitle;
    Color prepSubtitleColor;
    if (metrics.avgPrepTimeMinutes == 0) {
      prepSubtitle = isAr ? 'لا توجد بيانات كافية' : 'No data yet';
      prepSubtitleColor = KdsColors.textMuted;
    } else if (metrics.prepDiffFromAvgMinutes < 0) {
      prepSubtitle = isAr
          ? '${metrics.prepDiffFromAvgMinutes.abs()} دقيقة أسرع من الهدف ↓'
          : '${metrics.prepDiffFromAvgMinutes.abs()}m faster than target ↓';
      prepSubtitleColor = KdsColors.statusReadyBorder;
    } else if (metrics.prepDiffFromAvgMinutes > 0) {
      prepSubtitle = isAr
          ? '+${metrics.prepDiffFromAvgMinutes} دقيقة فوق الهدف ↑'
          : '+${metrics.prepDiffFromAvgMinutes}m above target ↑';
      prepSubtitleColor = Colors.orange;
    } else {
      prepSubtitle = isAr ? 'مطابق للوقت القياسي' : 'On target time';
      prepSubtitleColor = KdsColors.statusReadyBorder;
    }

    return SizedBox(
      height: 110.h,
      child: Row(
        children: [
          // Card 1: Total Completed
          Expanded(
            child: _KpiCard(
              title: 'total_completed'.tr(),
              value: '${metrics.totalCompleted}',
              subtitle: totalOrders > 0
                  ? (isAr ? 'من إجمالي $totalOrders طلب' : 'of $totalOrders orders')
                  : 'today_shift'.tr(),
              subtitleColor: KdsColors.textMuted,
              valueColor: KdsColors.textDark,
              icon: Icons.check_circle,
              iconColor: KdsColors.primaryBlue,
            ),
          ),
          SizedBox(width: 12.w),

          // Card 2: Cancelled
          Expanded(
            child: _KpiCard(
              title: 'cancelled'.tr(),
              value: '${metrics.cancelledCount}',
              subtitle: metrics.cancelledCount > 0
                  ? 'requires_review'.tr()
                  : (isAr ? 'لا توجد طلبات ملغاة' : 'No cancellations'),
              subtitleColor: metrics.cancelledCount > 0 ? Colors.red : KdsColors.textMuted,
              valueColor: metrics.cancelledCount > 0 ? Colors.red : KdsColors.textDark,
              icon: Icons.cancel,
              iconColor: metrics.cancelledCount > 0 ? Colors.red : KdsColors.textMuted,
            ),
          ),
          SizedBox(width: 12.w),

          // Card 3: Avg Prep Time
          Expanded(
            child: _KpiCard(
              title: 'avg_prep_time'.tr(),
              value: metrics.avgPrepTimeMinutes > 0 ? '${metrics.avgPrepTimeMinutes}m' : '-',
              subtitle: prepSubtitle,
              subtitleColor: prepSubtitleColor,
              valueColor: KdsColors.statusReadyBorder,
              icon: Icons.timer_outlined,
              iconColor: KdsColors.statusReadyBorder,
            ),
          ),
          SizedBox(width: 12.w),

          // Card 4: Late Rate
          Expanded(
            child: _KpiCard(
              title: 'late_rate'.tr(),
              value: '${metrics.lateRatePercentage.toStringAsFixed(0)}%',
              subtitle: metrics.lateRatePercentage > 0
                  ? 'over_target_time'.tr()
                  : (isAr ? 'جميع الطلبات في الموعد' : 'All orders on time'),
              subtitleColor: metrics.lateRatePercentage > 0
                  ? KdsColors.statusNewBorder
                  : KdsColors.statusReadyBorder,
              valueColor: metrics.lateRatePercentage > 0
                  ? KdsColors.statusNewBorder
                  : KdsColors.textDark,
              icon: Icons.warning_amber_rounded,
              iconColor: metrics.lateRatePercentage > 0
                  ? KdsColors.statusNewBorder
                  : KdsColors.statusReadyBorder,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: KdsColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              Icon(icon, size: 18.r, color: iconColor),
            ],
          ),
          Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                color: valueColor,
              ),
            ),
          ),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
