import 'package:flutter/material.dart';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';
import 'package:kds/app/orders_cycle/providers/kds_provider.dart';
import 'package:kds/app/orders_cycle/services/orders_apis.dart';
import '../models/history_order_model.dart';

class HistoryProvider extends ChangeNotifier {
  String _searchQuery = '';
  OrderType _selectedTypeFilter = OrderType.all;
  DateTimeRange? _selectedDateRange;
  String? _restoringOrderId;
  bool _isLoading = false;
  String? _errorMessage;

  final HistoryMetrics _metrics = HistoryMetrics(
    totalCompleted: 124,
    cancelledCount: 2,
    avgPrepTimeMinutes: 12,
    prepDiffFromAvgMinutes: -2,
    lateRatePercentage: 5.0,
  );

  List<HistoryOrder> _historyOrders = [];
  final OrdersApis _ordersApis = OrdersApis();

  String get searchQuery => _searchQuery;
  OrderType get selectedTypeFilter => _selectedTypeFilter;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get restoringOrderId => _restoringOrderId;
  HistoryMetrics get metrics => _metrics;
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
        _historyOrders = historyKdsOrders.data!.map((datum) => datum.toHistoryOrder()).toList();
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

  void setDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void setRestoringOrderId(String? id) {
    _restoringOrderId = id;
    notifyListeners();
  }

  List<HistoryOrder> get filteredHistoryOrders {
    return _historyOrders.where((order) {
      final matchesSearch = order.orderNumber.contains(_searchQuery) ||
          order.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType =
          _selectedTypeFilter == OrderType.all || order.type == _selectedTypeFilter;
      return matchesSearch && matchesType;
    }).toList();
  }

  void confirmRestore(String orderId, KdsProvider kdsProvider) {
    final orderIndex = _historyOrders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final historyOrder = _historyOrders.removeAt(orderIndex);
      _restoringOrderId = null;
      notifyListeners();

      // Add back to live orders in preparation state
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
