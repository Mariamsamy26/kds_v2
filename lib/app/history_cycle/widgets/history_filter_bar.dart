import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../styles/kds_colors.dart';
import '../../orders_cycle/models/kds_order_model.dart';
import '../providers/history_provider.dart';
import '../services/pdf_export_service.dart';

class HistoryFilterBar extends StatelessWidget {
  const HistoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: KdsColors.borderColor),
      ),
      child: Row(
        children: [
          // Export Button
          IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              size: 20.r,
              color: KdsColors.textDark,
            ),
            tooltip: 'export'.tr(),
            onPressed: () async {
              final path = await PdfExportService.exportHistoryPdf(
                orders: provider.filteredHistoryOrders,
                metrics: provider.metrics,
              );
              if (context.mounted && path != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PDF downloaded: $path'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
          ),

          // SizedBox(width: 8.w),

          // // Staff Filter Pill
          // _FilterPill(
          //   label: 'staff_all'.tr(),
          //   icon: Icons.person_outline,
          //   onTap: () {},
          // ),
          SizedBox(width: 8.w),

          // Date Filter Pill (Day or Range selection)
          _FilterPill(
            label: _getDateRangeLabel(provider.selectedDateRange),
            icon: Icons.calendar_today_outlined,
            onTap: () => _showDateFilterDialog(context, provider),
          ),

          SizedBox(width: 8.w),

          // Type Filter Dropdown Pill
          PopupMenuButton<OrderType>(
            initialValue: provider.selectedTypeFilter,
            onSelected: (type) => provider.setTypeFilter(type),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: OrderType.all,
                child: Text('all_orders'.tr()),
              ),
              PopupMenuItem(
                value: OrderType.dineIn,
                child: Text('dine_in'.tr()),
              ),
              PopupMenuItem(
                value: OrderType.takeaway,
                child: Text('takeaway'.tr()),
              ),
              PopupMenuItem(
                value: OrderType.delivery,
                child: Text('delivery'.tr()),
              ),
            ],
            child: _FilterPill(
              label: provider.selectedTypeFilter == OrderType.all
                  ? 'type_all'.tr()
                  : '${'type'.tr()}: ${_getTypeName(provider.selectedTypeFilter)}',
              icon: Icons.filter_list,
            ),
          ),

          const Spacer(),

          // Search Input Box
          SizedBox(
            width: 260.w,
            height: 36.h,
            child: TextField(
              onChanged: (val) => provider.setSearchQuery(val),
              style: TextStyle(fontSize: 13.sp, color: KdsColors.textDark),
              decoration: InputDecoration(
                hintText: 'search_placeholder'.tr(),
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: KdsColors.textLight,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18.r,
                  color: KdsColors.textMuted,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: KdsColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: KdsColors.primaryBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateFilterDialog(
    BuildContext context,
    HistoryProvider provider,
  ) async {
    DateTime? fromDate = provider.selectedDateRange.start;
    DateTime? toDate = provider.selectedDateRange.end;

    final DateTime now = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> selectFromDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: fromDate ?? now,
                firstDate: DateTime(2020),
                lastDate: DateTime(now.year + 2),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: KdsColors.primaryBlue,
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setState(() {
                  fromDate = picked;

                  if (toDate != null && toDate!.isBefore(picked)) {
                    toDate = picked;
                  }
                });
              }
            }

            Future<void> selectToDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: toDate ?? fromDate ?? now,
                firstDate: fromDate ?? DateTime(2020),
                lastDate: DateTime(now.year + 2),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: KdsColors.primaryBlue,
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setState(() {
                  toDate = picked;
                });
              }
            }

            String formatDate(DateTime? date) {
              if (date == null) return 'Select date';

              return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }

            return AlertDialog(
              title: const Text('Filter by Date'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: selectFromDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      child: Text(formatDate(fromDate)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: selectToDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      child: Text(formatDate(toDate)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: fromDate == null || toDate == null
                      ? null
                      : () {
                          provider.setDateRange(
                            DateTimeRange(start: fromDate!, end: toDate!),
                          );

                          Navigator.pop(context);
                        },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getDateRangeLabel(DateTimeRange? range) {
    if (range == null) {
      return 'today'.tr();
    }
    final isSameDay =
        range.start.year == range.end.year &&
        range.start.month == range.end.month &&
        range.start.day == range.end.day;

    if (isSameDay) {
      return DateFormat('yyyy/MM/dd').format(range.start);
    } else {
      final startStr = DateFormat('MM/dd').format(range.start);
      final endStr = DateFormat('MM/dd').format(range.end);
      return '$startStr - $endStr';
    }
  }

  String _getTypeName(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'dine_in'.tr();
      case OrderType.takeaway:
        return 'takeaway'.tr();
      case OrderType.delivery:
        return 'delivery'.tr();
      case OrderType.all:
        return 'all_orders'.tr();
    }
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _FilterPill({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: KdsColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14.r, color: KdsColors.textMuted),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: KdsColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
