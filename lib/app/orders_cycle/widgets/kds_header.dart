import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../providers/kds_provider.dart';

class KdsHeader extends StatelessWidget implements PreferredSizeWidget {
  final String activeTab; // 'live' or 'history'
  final ValueChanged<String>? onTabChanged;

  const KdsHeader({
    super.key,
    this.activeTab = 'live',
    this.onTabChanged,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KdsProvider>();
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      height: 60.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: KdsColors.borderColor, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // User Avatar & Admin Info
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: KdsColors.primaryBlue,
                child: Icon(Icons.person, color: Colors.white, size: 20.r),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'kitchen_admin'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textDark,
                    ),
                  ),
                  Text(
                    'admin'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(width: 16.w),
          Icon(Icons.wifi, size: 20.r, color: KdsColors.textMuted),
          SizedBox(width: 12.w),
          Icon(Icons.notifications_none, size: 22.r, color: KdsColors.textMuted),
          SizedBox(width: 12.w),

          // Language Switcher Toggle Icon
          IconButton(
            icon: Icon(Icons.language, size: 22.r, color: KdsColors.textMuted),
            tooltip: isAr ? 'Switch to English' : 'التغيير للغة العربية',
            onPressed: () {
              if (isAr) {
                context.setLocale(const Locale('en'));
              } else {
                context.setLocale(const Locale('ar'));
              }
            },
          ),

          SizedBox(width: 12.w),

          // Station Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: KdsColors.borderColor),
            ),
            child: Row(
              children: [
                Text(
                  '${'station'.tr()} ${provider.selectedStation}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: KdsColors.textDark,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_drop_down, size: 20.r, color: KdsColors.textDark),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Live Pill Indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: KdsColors.statusReadyBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: KdsColors.statusReadyBorder.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: KdsColors.liveGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'live'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: KdsColors.statusReadyText,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Navigation Links ("الطلبات المباشرة", "السجل")
          Row(
            children: [
              // History Tab Link
              InkWell(
                onTap: () => onTabChanged?.call('history'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'history'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: activeTab == 'history'
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: activeTab == 'history'
                            ? KdsColors.primaryBlue
                            : KdsColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 2.h,
                      width: 50.w,
                      color: activeTab == 'history'
                          ? KdsColors.primaryBlue
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20.w),

              // Live Orders Tab Link
              InkWell(
                onTap: () => onTabChanged?.call('live'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'live_orders'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: activeTab == 'live'
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: activeTab == 'live'
                            ? KdsColors.primaryBlue
                            : KdsColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 2.h,
                      width: 70.w,
                      color: activeTab == 'live'
                          ? KdsColors.primaryBlue
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(width: 24.w),

          // BluBite Logo Branding
          Row(
            children: [
              Text(
                'Blu',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: KdsColors.primaryBlue,
                ),
              ),
              Text(
                'Bite',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: KdsColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
