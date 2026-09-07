import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../../orders_cycle/models/kds_order_model.dart';
import '../../orders_cycle/providers/kds_provider.dart';
import '../models/history_order_model.dart';
import '../providers/history_provider.dart';

class HistoryOrdersTable extends StatelessWidget {
  const HistoryOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final kdsProvider = context.watch<KdsProvider>();
    final orders = historyProvider.filteredHistoryOrders;
    final isAr = context.locale.languageCode == 'ar';

    if (historyProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      );
    }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 48.r,
              color: KdsColors.textMuted,
            ),
            SizedBox(height: 12.h),
            Text(
              'no_history_orders'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                color: KdsColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: KdsColors.borderColor),
      ),
      child: Column(
        children: [
          // Table Column Headers
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: KdsColors.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'order_number'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'date'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'type_table'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'pickup_time'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Text(
                //     'price'.tr(),
                //     style: TextStyle(
                //       fontSize: 12.sp,
                //       fontWeight: FontWeight.bold,
                //       color: KdsColors.textMuted,
                //     ),
                //   ),
                // ),

                // Expanded(
                //   flex: 2,
                //   child: Text(
                //     'status'.tr(),
                //     style: TextStyle(
                //       fontSize: 12.sp,
                //       fontWeight: FontWeight.bold,
                //       color: KdsColors.textMuted,
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'actions'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: KdsColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows List
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: KdsColors.borderColor),
              itemBuilder: (context, index) {
                final order = orders[index];
                final isRestoring =
                    historyProvider.restoringOrderId == order.id;

                if (isRestoring) {
                  return _RestoreConfirmationCard(
                    order: order,
                    onConfirm: () =>
                        historyProvider.confirmRestore(order.id, kdsProvider),
                    onCancel: () => historyProvider.cancelRestore(),
                  );
                }

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      // Order Number e.g. 124
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.id,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: KdsColors.textDark,
                          ),
                        ),
                      ),

                      // Order Date e.g. 2026/09/07
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat('yyyy/MM/dd').format(order.createdAt),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: KdsColors.textDark,
                          ),
                        ),
                      ),

                      // Type & Table
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _getTypeText(order.type),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: KdsColors.textDark,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  _getTypeIcon(order.type),
                                  size: 14.r,
                                  color: KdsColors.textMuted,
                                ),
                              ],
                            ),
                            if (order.tableInfoAr != null)
                              Text(
                                isAr
                                    ? order.tableInfoAr!
                                    : (order.tableInfoEn ?? order.tableInfoAr!),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: KdsColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Pickup Time e.g. 14:30
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.pickupTime,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: KdsColors.textDark,
                          ),
                        ),
                      ),

                      // Duration e.g. 15m
                      // Expanded(
                      //   flex: 2,
                      //   child: Text(
                      //     order.durationMinutes,
                      //     style: TextStyle(
                      //       fontSize: 13.sp,
                      //       fontWeight: FontWeight.w600,
                      //       color: KdsColors.textDark,
                      //     ),
                      //   ),
                      // ),

                      // Status Badge e.g. "مكتمل"
                      // Expanded(
                      //   flex: 2,
                      //   child: Align(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 10.w,
                      //         vertical: 4.h,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: KdsColors.statusReadyBg,
                      //         borderRadius: BorderRadius.circular(12.r),
                      //       ),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(
                      //             Icons.check,
                      //             size: 12.r,
                      //             color: KdsColors.statusReadyBorder,
                      //           ),
                      //           SizedBox(width: 4.w),
                      //           Text(
                      //             'completed'.tr(),
                      //             style: TextStyle(
                      //               fontSize: 11.sp,
                      //               fontWeight: FontWeight.bold,
                      //               color: KdsColors.statusReadyText,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Actions: Details & Restore
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            // Details Button
                            OutlinedButton(
                              onPressed: () =>
                                  _showDetailsModal(context, order),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                side: const BorderSide(
                                  color: KdsColors.borderColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'details'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: KdsColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            // Restore Button
                            IconButton(
                              icon: Icon(
                                Icons.restore,
                                size: 20.r,
                                color: KdsColors.primaryBlue,
                              ),
                              tooltip: 'restore'.tr(),
                              onPressed: () =>
                                  historyProvider.setRestoringOrderId(order.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
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

  void _showDetailsModal(BuildContext context, HistoryOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text('${'order_number'.tr()} ${order.orderNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'status'.tr()}: ${'completed'.tr()}'),
            Text(
              '${'date'.tr()}: ${DateFormat('yyyy/MM/dd').format(order.createdAt)}',
            ),
            Text('${'duration'.tr()}: ${order.durationMinutes}'),
            Text('${'pickup_time'.tr()}: ${order.pickupTime}'),
            const Divider(),
            ...order.items.map(
              (item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text('${item.quantity}x ${item.nameAr}'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
        ],
      ),
    );
  }
}

class _RestoreConfirmationCard extends StatelessWidget {
  final HistoryOrder order;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _RestoreConfirmationCard({
    required this.order,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: KdsColors.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Action Buttons: Confirm & Cancel
          Row(
            children: [
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: KdsColors.primaryBlue,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'confirm_restore'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  side: const BorderSide(color: KdsColors.borderColor),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'cancel'.tr(),
                  style: TextStyle(fontSize: 12.sp, color: KdsColors.textDark),
                ),
              ),
            ],
          ),

          // Restore Prompt Title & Subtitle
          Column(
            crossAxisAlignment: isAr
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                '${'restore_order_prompt'.tr()} #${order.orderNumber}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: KdsColors.primaryBlue,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'restore_order_subtitle'.tr(),
                style: TextStyle(fontSize: 11.sp, color: KdsColors.textMuted),
              ),
            ],
          ),

          // Restore Icon Circle
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: KdsColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.restore, color: Colors.white, size: 20.r),
          ),
        ],
      ),
    );
  }
}
