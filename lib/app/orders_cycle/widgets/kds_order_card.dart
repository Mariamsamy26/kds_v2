import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../models/kds_order_model.dart';
import '../providers/kds_provider.dart';

class KdsOrderCard extends StatelessWidget {
  final KdsOrder order;

  const KdsOrderCard({super.key, required this.order});

  Color _getBorderColor() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return KdsColors.statusNewBorder;
      case OrderStatus.lateOrder:
        return KdsColors.statusLateBorder;
      case OrderStatus.inPreparation:
        return KdsColors.statusPrepBorder;
      case OrderStatus.ready:
        return KdsColors.statusReadyBorder;
      case OrderStatus.completed:
        return KdsColors.textMuted;
    }
  }

  Color _getBadgeBg() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return KdsColors.statusNewBadge;
      case OrderStatus.lateOrder:
        return KdsColors.statusLateBadge;
      case OrderStatus.inPreparation:
        return KdsColors.statusPrepBadge;
      case OrderStatus.ready:
        return KdsColors.statusReadyBadge;
      case OrderStatus.completed:
        return KdsColors.textMuted;
    }
  }

  Color _getBadgeTextColor() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return KdsColors.statusNewText;
      case OrderStatus.lateOrder:
      case OrderStatus.inPreparation:
      case OrderStatus.ready:
      case OrderStatus.completed:
        return Colors.white;
    }
  }

  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return 'new_order'.tr();
      case OrderStatus.lateOrder:
        return 'late'.tr();
      case OrderStatus.inPreparation:
        return 'in_preparation'.tr();
      case OrderStatus.ready:
        return 'ready'.tr();
      case OrderStatus.completed:
        return 'completed'.tr();
    }
  }

  String _getTypeText() {
    switch (order.type) {
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

  IconData _getTypeIcon() {
    switch (order.type) {
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KdsProvider>();
    final isAr = context.locale.languageCode == 'ar';
    final borderColor = _getBorderColor();

    return Container(
      decoration: BoxDecoration(
        color: KdsColors.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              border: Border(
                bottom: BorderSide(
                  color: KdsColors.borderColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Row: Type info + Status badge + Order Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order Type (e.g. "سفري" with icon)
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(),
                          size: 14.r,
                          color: order.status == OrderStatus.lateOrder
                              ? Colors.red
                              : KdsColors.textDark,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _getTypeText(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: order.status == OrderStatus.lateOrder
                                ? Colors.red
                                : KdsColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getBadgeBg(),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: _getBadgeTextColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Order Number `#145`
                        Text(
                          '#${order.id}',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: KdsColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Sub header: Customer name, Table, Waiter, Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: order.status == OrderStatus.lateOrder
                                  ? Colors.red
                                  : KdsColors.textDark,
                            ),
                          ),
                          if (order.deliveryProvider != null)
                            Text(
                              order.deliveryProvider!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: KdsColors.textMuted,
                              ),
                            ),
                          if (order.tableInfoAr != null)
                            Text(
                              isAr
                                  ? order.tableInfoAr!
                                  : (order.tableInfoEn ?? order.tableInfoAr!),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: KdsColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (order.serverName != null)
                            Text(
                              order.serverName!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: KdsColors.textMuted,
                              ),
                            ),
                          if (order.subtitleAr != null)
                            Text(
                              isAr
                                  ? order.subtitleAr!
                                  : (order.subtitleEn ?? order.subtitleAr!),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: order.status == OrderStatus.lateOrder
                                    ? Colors.red
                                    : KdsColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Timer Display
                    Row(
                      children: [
                        Text(
                          _formatDuration(order.elapsedDuration),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.access_time_filled,
                          size: 16.r,
                          color: borderColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Body Content
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: order.status == OrderStatus.ready
                  ? _buildReadyContent()
                  : _buildItemsList(provider, isAr),
            ),
          ),

          // Card Footer Action Button
          _buildActionButton(provider),
        ],
      ),
    );
  }

  // Visual layout for Ready Order State
  Widget _buildReadyContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54.r,
          height: 54.r,
          decoration: const BoxDecoration(
            color: KdsColors.statusReadyCircle,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: KdsColors.statusReadyBorder,
            size: 36.r,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'all_items_ready_title'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: KdsColors.textDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'all_items_ready_subtitle'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, color: KdsColors.textMuted),
        ),
      ],
    );
  }

  // Items breakdown with checkboxes
  Widget _buildItemsList(KdsProvider provider, bool isAr) {
    // Checkboxes are only visible once the kitchen has started processing the
    // order (inPreparation). New/late orders that haven't been accepted yet
    // don't show them. Note: ready orders never reach this method.
    final isStarted = order.status == OrderStatus.inPreparation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isStarted && order.totalItemsCount > 1)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '${order.completedItemsCount}/${order.totalItemsCount} ${'items_completed'.tr()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: KdsColors.statusPrepText,
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            itemCount: order.items.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return InkWell(
                onTap: isStarted
                    ? () => provider.toggleItemCompletion(order.id, item.id)
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Item Checkbox (only visible after starting preparation)
                    if (isStarted) ...[
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: Checkbox(
                          value: item.isCompleted,
                          activeColor: KdsColors.statusReadyBorder,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          onChanged: (_) =>
                              provider.toggleItemCompletion(order.id, item.id),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],

                    // Item Name & Modifiers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? item.nameAr : item.nameEn,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              decoration: (isStarted && item.isCompleted)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: (isStarted && item.isCompleted)
                                  ? KdsColors.textLight
                                  : KdsColors.textDark,
                            ),
                          ),
                          if (item.modifierAr != null)
                            Text(
                              isAr
                                  ? item.modifierAr!
                                  : (item.modifierEn ?? item.modifierAr!),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Quantity Pill e.g. 1x
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: KdsColors.borderColor),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: KdsColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Footer Action Button
  Widget _buildActionButton(KdsProvider provider) {
    String label = '';
    Color btnColor = KdsColors.primaryBlue;
    VoidCallback? onPressed;

    switch (order.status) {
      case OrderStatus.newOrder:
      case OrderStatus.lateOrder:
        // Both new and late orders need to be accepted first — show "Start Prep"
        label = 'start_prep'.tr();
        btnColor = order.status == OrderStatus.lateOrder
            ? KdsColors.statusLateBorder  // red-tinted for urgency
            : KdsColors.statusNewBtn;
        onPressed = () => provider.startPreparation(order.id);
        break;
      case OrderStatus.inPreparation:
        label = 'mark_ready'.tr();
        if (order.areAllItemsCompleted) {
          btnColor = KdsColors.primaryBlue;
          onPressed = () => provider.markAsReady(order.id);
        } else {
          btnColor = const Color(0xFF94A3B8); // Gray color
          onPressed = null; // Disabled when not all checks completed
        }
        break;
      case OrderStatus.ready:
        label = 'complete_order'.tr();
        btnColor = KdsColors.statusReadyBtn;
        onPressed = () => provider.completeOrder(order.id);
        break;
      case OrderStatus.completed:
        label = 'completed'.tr();
        btnColor = KdsColors.textMuted;
        onPressed = null;
        break;
    }

    return Padding(
      padding: EdgeInsets.all(10.r),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          disabledBackgroundColor: const Color(0xFF94A3B8),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
