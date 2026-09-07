import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../models/kds_order_model.dart';
import '../providers/kds_provider.dart';

class KdsFilterTabs extends StatelessWidget {
  const KdsFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KdsProvider>();
    final selectedFilter = provider.selectedFilter;

    return Container(
      height: 50.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: KdsColors.borderColor, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _TabPill(
            title: 'delivery'.tr(),
            count: provider.countDelivery,
            isSelected: selectedFilter == OrderType.delivery,
            onTap: () => provider.setFilter(OrderType.delivery),
          ),
          SizedBox(width: 16.w),
          _TabPill(
            title: 'takeaway'.tr(),
            count: provider.countTakeaway,
            isSelected: selectedFilter == OrderType.takeaway,
            onTap: () => provider.setFilter(OrderType.takeaway),
          ),
          SizedBox(width: 16.w),
          _TabPill(
            title: 'dine_in'.tr(),
            count: provider.countDineIn,
            isSelected: selectedFilter == OrderType.dineIn,
            onTap: () => provider.setFilter(OrderType.dineIn),
          ),
          SizedBox(width: 16.w),
          _TabPill(
            title: 'all_orders'.tr(),
            count: provider.countAll,
            isSelected: selectedFilter == OrderType.all,
            onTap: () => provider.setFilter(OrderType.all),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPill({
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? KdsColors.primaryBlue
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : KdsColors.textDark,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? KdsColors.primaryBlue
                        : KdsColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 3.h,
            width: 90.w,
            color: isSelected ? KdsColors.primaryBlue : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
