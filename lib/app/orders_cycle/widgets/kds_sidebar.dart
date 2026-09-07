import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../models/kds_order_model.dart';
import '../providers/kds_provider.dart';

class KdsSidebar extends StatelessWidget {
  const KdsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KdsProvider>();
    final selectedStatus = provider.selectedStatusFilter;

    return Container(
      width: 220.w,
      decoration: const BoxDecoration(
        color: KdsColors.sidebarBg,
        border: Border(
          left: BorderSide(color: KdsColors.borderColor, width: 1),
          right: BorderSide(color: KdsColors.borderColor, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar Top Logo Branding & Station Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: KdsColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront,
                  color: KdsColors.primaryBlue,
                  size: 20.r,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'app_name'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textDark,
                    ),
                  ),
                  Text(
                    '${'station'.tr()}: ${'main_kitchen'.tr()}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Sidebar Navigation Buttons - Filter by Order Status with Counter Badges
          _SidebarButton(
            title: 'all_orders'.tr(),
            icon: Icons.inventory_2_outlined,
            count: provider.countAll,
            isSelected: selectedStatus == null,
            onTap: () => provider.setStatusFilter(null),
          ),
          SizedBox(height: 8.h),
          _SidebarButton(
            title: 'late'.tr(),
            icon: Icons.warning_amber_rounded,
            count: provider.countLate,
            badgeColor: KdsColors.statusLateBorder,
            isSelected: selectedStatus == OrderStatus.lateOrder,
            onTap: () => provider.setStatusFilter(OrderStatus.lateOrder),
          ),
          SizedBox(height: 8.h),
          _SidebarButton(
            title: 'new_order'.tr(),
            icon: Icons.fiber_new_outlined,
            count: provider.countNew,
            badgeColor: KdsColors.statusNewBorder,
            isSelected: selectedStatus == OrderStatus.newOrder,
            onTap: () => provider.setStatusFilter(OrderStatus.newOrder),
          ),
          SizedBox(height: 8.h),

          _SidebarButton(
            title: 'in_preparation'.tr(),
            icon: Icons.soup_kitchen_outlined,
            count: provider.countInPrep,
            badgeColor: KdsColors.statusPrepBorder,
            isSelected: selectedStatus == OrderStatus.inPreparation,
            onTap: () => provider.setStatusFilter(OrderStatus.inPreparation),
          ),
          SizedBox(height: 8.h),

          _SidebarButton(
            title: 'ready'.tr(),
            icon: Icons.check_circle_outline,
            count: provider.countReady,
            badgeColor: KdsColors.statusReadyBorder,
            isSelected: selectedStatus == OrderStatus.ready,
            onTap: () => provider.setStatusFilter(OrderStatus.ready),
          ),

          const Spacer(),

          // Bottom Action: Refresh Network
          OutlinedButton(
            onPressed: () => provider.refreshOrders(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: const BorderSide(color: KdsColors.borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'refresh_network'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: KdsColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Settings Link
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'settings'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: KdsColors.textMuted,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.settings_outlined,
                    size: 16.r,
                    color: KdsColors.textMuted,
                  ),
                ],
              ),
            ),
          ),

          // Support Link
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'support'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: KdsColors.textMuted,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.help_outline,
                    size: 16.r,
                    color: KdsColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final int? count;
  final Color? badgeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarButton({
    required this.title,
    this.icon,
    this.count,
    this.badgeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBadgeColor = badgeColor ?? KdsColors.primaryBlue;

    return Material(
      color: isSelected ? KdsColors.primaryBlue : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 18.r,
                  color: isSelected ? Colors.white : KdsColors.textMuted,
                )
              else
                const SizedBox.shrink(),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : KdsColors.textDark,
                  ),
                ),
              ),
              if (count != null && count! > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : effectiveBadgeColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? KdsColors.primaryBlue : Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
