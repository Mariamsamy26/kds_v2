import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../styles/kds_colors.dart';
import '../../orders_cycle/models/kds_order_model.dart';
import '../models/history_order_model.dart';

class OrderDetailsDialog extends StatelessWidget {
  final HistoryOrder order;

  const OrderDetailsDialog({
    super.key,
    required this.order,
  });

  static Future<void> show(BuildContext context, HistoryOrder order) {
    return showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520.w,
          maxHeight: 650.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: KdsColors.borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: KdsColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: KdsColors.primaryBlue,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${'order_number'.tr()} #${order.orderNumber}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: KdsColors.textDark,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Status pill badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: order.isCancelled
                                    ? KdsColors.statusLateBg
                                    : KdsColors.statusReadyBg,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: order.isCancelled
                                      ? KdsColors.statusLateBorder
                                      : KdsColors.statusReadyBorder,
                                ),
                              ),
                              child: Text(
                                order.isCancelled
                                    ? 'cancelled'.tr()
                                    : 'completed'.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: order.isCancelled
                                      ? KdsColors.statusLateText
                                      : KdsColors.statusReadyText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              _getTypeIcon(order.type),
                              size: 14.r,
                              color: KdsColors.textMuted,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _getTypeText(order.type),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: KdsColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (order.tableInfoAr != null ||
                                order.tableInfoEn != null) ...[
                              Text(
                                '  •  ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: KdsColors.textLight,
                                ),
                              ),
                              Text(
                                isAr
                                    ? (order.tableInfoAr ?? '')
                                    : (order.tableInfoEn ??
                                        order.tableInfoAr ??
                                        ''),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: KdsColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: KdsColors.textMuted,
                      size: 20.r,
                    ),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20.r,
                    style: IconButton.styleFrom(
                      backgroundColor: KdsColors.bgLight,
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info Cards Grid
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: KdsColors.borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'date'.tr(),
                                  value: DateFormat('yyyy/MM/dd')
                                      .format(order.createdAt),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 36.h,
                                color: KdsColors.borderColor,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.access_time_rounded,
                                  label: 'pickup_time'.tr(),
                                  value: order.pickupTime,
                                ),
                              ),
                            ],
                          ),
                          if (order.customerName.isNotEmpty &&
                              !order.customerName.startsWith('Customer #')) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: const Divider(
                                color: KdsColors.borderColor,
                                height: 1,
                              ),
                            ),
                            _buildInfoItem(
                              icon: Icons.person_outline_rounded,
                              label: isAr ? 'العميل' : 'Customer',
                              value: order.customerName,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // Items Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'الأصناف' : 'Items',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: KdsColors.textDark,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: KdsColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${order.items.length} ${isAr ? 'صنف' : 'items'}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: KdsColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Items List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        final itemName = isAr
                            ? item.nameAr
                            : (item.nameEn.isNotEmpty
                                ? item.nameEn
                                : item.nameAr);
                        final modifier = isAr
                            ? item.modifierAr
                            : (item.modifierEn ?? item.modifierAr);

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: KdsColors.borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: KdsColors.primaryBlue
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '${item.quantity}x',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: KdsColors.primaryBlue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemName,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: KdsColors.textDark,
                                      ),
                                    ),
                                    if (modifier != null &&
                                        modifier.isNotEmpty) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        modifier,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: KdsColors.textMuted,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Actions Footer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: KdsColors.borderColor, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KdsColors.primaryBlue,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    isAr ? 'إغلاق' : 'Close',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: KdsColors.textMuted),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: KdsColors.textMuted,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: KdsColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTypeText(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'dine_in'.tr();
      case OrderType.takeaway:
        return 'takeaway'.tr();
      case OrderType.delivery:
        return 'delivery'.tr();
      case OrderType.all:
        return '';
    }
  }

  IconData _getTypeIcon(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return Icons.restaurant;
      case OrderType.takeaway:
        return Icons.shopping_bag_outlined;
      case OrderType.delivery:
        return Icons.local_shipping_outlined;
      case OrderType.all:
        return Icons.inventory_2_outlined;
    }
  }
}
