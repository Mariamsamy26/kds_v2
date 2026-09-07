import 'package:flutter/material.dart';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';
import 'package:kds/app/orders_cycle/providers/kds_provider.dart';
import 'package:kds/app/orders_cycle/services/orders_apis.dart';
import '../models/history_order_model.dart';

class HistoryProvider extends ChangeNotifier {
  String _searchQuery = '';
  OrderType _selectedTypeFilter = OrderType.all;

  final DateTime _today = DateTime.now();

  late DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(_today.year, _today.month, _today.day),
    end: DateTime(_today.year, _today.month, _today.day),
  );

  String? _restoringOrderId;
  bool _isLoading = false;
  String? _errorMessage;

  List<HistoryOrder> _historyOrders = [];
  final OrdersApis _ordersApis = OrdersApis();

  String get searchQuery => _searchQuery;
  OrderType get selectedTypeFilter => _selectedTypeFilter;
  DateTimeRange get selectedDateRange => _selectedDateRange;
  String? get restoringOrderId => _restoringOrderId;

  HistoryMetrics get metrics {
    final list = filteredHistoryOrders;
    final total = list.length;
    final completed =
        list.where((o) => o.status == OrderStatus.completed).length;
    final cancelled = list.where((o) => o.isCancelled).length;
    final lateCount =
        list.where((o) => o.status == OrderStatus.lateOrder).length;

    int totalMinutes = 0;
    int countWithDuration = 0;
    for (var o in list) {
      final match = RegExp(r'(\d+)').firstMatch(o.durationMinutes);
      if (match != null) {
        final val = int.tryParse(match.group(1)!);
        if (val != null && val > 0) {
          totalMinutes += val;
          countWithDuration++;
        }
      }
    }

    final avgMinutes =
        countWithDuration > 0 ? (totalMinutes / countWithDuration).round() : 0;
    const targetAvg = 15;
    final prepDiff = avgMinutes > 0 ? (avgMinutes - targetAvg) : 0;
    final lateRate = total > 0 ? (lateCount / total) * 100.0 : 0.0;

    return HistoryMetrics(
      totalCompleted: completed > 0 ? completed : (total - cancelled),
      cancelledCount: cancelled,
      avgPrepTimeMinutes: avgMinutes,
      prepDiffFromAvgMinutes: prepDiff,
      lateRatePercentage: lateRate,
    );
  }
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HistoryProvider() {
    fetchHistoryOrders();
  }

  Future<void> fetchHistoryOrders({int posId = 0}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final historyKdsOrders = await _ordersApis.getHistoryKDSOrders(posId);

      if (historyKdsOrders != null && historyKdsOrders.data != null) {
        _historyOrders = historyKdsOrders.data!
            .map((datum) => datum.toHistoryOrder())
            .toList();
      } else {
        _historyOrders = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(OrderType type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  void setDateRange(DateTimeRange range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void setRestoringOrderId(String? id) {
    _restoringOrderId = id;
    notifyListeners();
  }

  List<HistoryOrder> get filteredHistoryOrders {
    return _historyOrders.where((order) {
      final matchesSearch =
          order.orderNumber.contains(_searchQuery) ||
          order.customerName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType =
          _selectedTypeFilter == OrderType.all ||
          order.type == _selectedTypeFilter;

      final orderDate = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
      );

      final startDate = DateTime(
        _selectedDateRange.start.year,
        _selectedDateRange.start.month,
        _selectedDateRange.start.day,
      );

      final endDate = DateTime(
        _selectedDateRange.end.year,
        _selectedDateRange.end.month,
        _selectedDateRange.end.day,
      );

      final matchesDate =
          !orderDate.isBefore(startDate) && !orderDate.isAfter(endDate);

      return matchesSearch && matchesType && matchesDate;
    }).toList();
  }

  void confirmRestore(String orderId, KdsProvider kdsProvider) {
    final orderIndex = _historyOrders.indexWhere((o) => o.id == orderId);

    if (orderIndex != -1) {
      final historyOrder = _historyOrders.removeAt(orderIndex);

      _restoringOrderId = null;
      notifyListeners();

      final restoredKdsOrder = KdsOrder(
        id: 'restored_${historyOrder.id}_${DateTime.now().millisecondsSinceEpoch}',
        orderNumber: historyOrder.orderNumber,
        type: historyOrder.type,
        status: OrderStatus.inPreparation,
        customerName: historyOrder.customerName,
        tableInfoAr: historyOrder.tableInfoAr,
        tableInfoEn: historyOrder.tableInfoEn,
        createdAt: DateTime.now(),
        elapsedDuration: Duration.zero,
        items: historyOrder.items,
      );

      kdsProvider.filteredOrders.add(restoredKdsOrder);
      kdsProvider.notifyListeners();
    }
  }

  void cancelRestore() {
    _restoringOrderId = null;
    notifyListeners();
  }
}
