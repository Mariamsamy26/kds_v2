import '../../orders_cycle/models/kds_order_model.dart';

class HistoryOrder {
  final String id;
  final String orderNumber;
  final OrderType type;
  final OrderStatus status;
  final String? tableInfoAr;
  final String? tableInfoEn;
  final String pickupTime;
  final String durationMinutes;
  final String customerName;
  final List<KdsOrderItem> items;
  final DateTime createdAt;
  final bool isCancelled;

  HistoryOrder({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.status,
    this.tableInfoAr,
    this.tableInfoEn,
    required this.pickupTime,
    required this.durationMinutes,
    required this.customerName,
    required this.items,
    required this.createdAt,
    this.isCancelled = false,
  });
}

class HistoryMetrics {
  final int totalCompleted;
  final int cancelledCount;
  final int avgPrepTimeMinutes;
  final int prepDiffFromAvgMinutes;
  final double lateRatePercentage;

  HistoryMetrics({
    required this.totalCompleted,
    required this.cancelledCount,
    required this.avgPrepTimeMinutes,
    required this.prepDiffFromAvgMinutes,
    required this.lateRatePercentage,
  });
}
