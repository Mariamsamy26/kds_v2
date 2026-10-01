import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../helpers/api_helper.dart';
import '../../../styles/kds_colors.dart';
import '../../../widget/error_dialog_api.dart';
import '../../orders_cycle/models/kds_order_model.dart';
import '../../orders_cycle/models/status_msg_model.dart';
import '../../orders_cycle/providers/kds_provider.dart';
import '../models/history_order_model.dart';
import '../providers/history_provider.dart';
import 'order_details.dart';

class HistoryOrdersTable extends StatelessWidget {
  const HistoryOrdersTable({super.key});

  static void _showApiError(BuildContext context, StatusMsgModel result) {
    final details =
        'Status: ${result.status}\nMessage: ${result.message ?? ''}${result.messageAr != null ? '\nMessageAr: ${result.messageAr}' : ''}';
    debugPrint('API Error: $details');
    showDialog(
      context: context,
      builder: (dialogContext) => ApiErrorDialog(
        message: result.message?.isNotEmpty == true
            ? result.message!
            : 'error'.tr(),
        errorDetails: details,
        onPressed: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

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
                // final isRestoring =
                //     historyProvider.restoringOrderId == order.id;

                // if (isRestoring) {
                //   return _RestoreConfirmationCard(
                //     order: order,
                //     onConfirm: () async {
                //       await ApiHelper.runApiWithLoading<StatusMsgModel>(
                //         context: context,
                //         request: () => historyProvider.restoreOrder(
                //           order.id,
                //           kdsProvider,
                //         ),
                //         onSuccess: (result) {
                //           if (result.status == 1) {
                //             // Success - restored to active KDS orders
                //           } else {
                //             _showApiError(context, result);
                //           }
                //         },
                //       );
                //     },
                //     onCancel: () => historyProvider.cancelRestore(),
                //   );
                // }

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
                          order
                              .pickupTime, //TODO till now we use time from date_order
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: KdsColors.textDark,
                          ),
                        ),
                      ),

                      // Actions: Details & Restore
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            // Details Button
                            OutlinedButton(
                              onPressed: () =>
                                  OrderDetailsDialog.show(context, order),
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
}
