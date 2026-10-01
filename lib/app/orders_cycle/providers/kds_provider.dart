import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';
import 'package:kds/app/orders_cycle/models/status_msg_model.dart';
import 'package:kds/app/orders_cycle/services/orders_apis.dart';

class KdsProvider extends ChangeNotifier {
  final int branchId = 1;

  OrderType _selectedFilter = OrderType.all;
  OrderStatus? _selectedStatusFilter; // null means All Orders
  String _selectedStation = '1';
  bool _isLive = true;
  Timer? _timer;
  Timer? _refreshTimer;
  bool _isLoading = false;
  String? _errorMessage;

  List<KdsOrder> _orders = [];
  final Map<String, Set<String>> _completedItemsByOrder = {};
  final OrdersApis _ordersApis = OrdersApis();

  OrderType get selectedFilter => _selectedFilter;
  OrderStatus? get selectedStatusFilter => _selectedStatusFilter;
  String get selectedStation => _selectedStation;
  bool get isLive => _isLive;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  KdsProvider() {
    fetchOrders();
    _startTimer();
    _startAutoRefreshTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// Orders become "late" after this threshold.
  static const Duration lateThreshold = Duration(minutes: 60);

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var order in _orders) {
        if (order.status == OrderStatus.completed) continue;

        order.elapsedDuration += const Duration(seconds: 1);

        // Auto-flip to lateOrder once the 60-minute threshold is crossed,
        // but ONLY for orders that have not yet been accepted (newOrder).
        // inPreparation orders that staff already accepted must NOT be reverted.
        if (order.elapsedDuration >= lateThreshold &&
            order.status == OrderStatus.newOrder) {
          order.status = OrderStatus.lateOrder;
        }
      }
      notifyListeners();
    });
  }

  void _startAutoRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isLive) {
        fetchOrders(isSilent: true);
      }
    });
  }

  Future<void> fetchOrders({
    int? branchId,
    int posId = 0,
    bool isSilent = false,
  }) async {
    final effectiveBranchId = (branchId != null && branchId != 0)
        ? branchId
        : (posId != 0 ? posId : this.branchId);
    if (!isSilent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final currentKdsOrders = await _ordersApis.getCurrentKDSOrders(
        effectiveBranchId,
      );
      if (currentKdsOrders != null && currentKdsOrders.data != null) {
        final newOrders = currentKdsOrders.data!
            .map((datum) => datum.toKdsOrder())
            .toList();

        // Preserve elapsed durations and item completion states for existing orders
        for (var newOrder in newOrders) {
          final existing = _orders.firstWhere(
            (o) => o.id == newOrder.id,
            orElse: () => newOrder,
          );
          if (existing != newOrder) {
            newOrder.elapsedDuration = existing.elapsedDuration;

            if (existing.status == OrderStatus.inPreparation &&
                newOrder.status == OrderStatus.newOrder) {
              newOrder.status = OrderStatus.inPreparation;
            }
          }

          // Apply and preserve finished (isCompleted) state for each item
          final savedCompleted = _completedItemsByOrder[newOrder.id];
          for (var item in newOrder.items) {
            if (savedCompleted != null && savedCompleted.contains(item.id)) {
              item.isCompleted = true;
            } else if (existing != newOrder) {
              final existingItem = existing.items.firstWhere(
                (e) =>
                    (e.id.isNotEmpty && e.id == item.id) ||
                    (e.nameEn == item.nameEn && e.nameAr == item.nameAr),
                orElse: () => item,
              );
              if (existingItem != item && existingItem.isCompleted) {
                item.isCompleted = true;
                _completedItemsByOrder
                    .putIfAbsent(newOrder.id, () => {})
                    .add(item.id);
              }
            }
          }
        }

        _orders = newOrders;
      } else {
        _orders = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (!isSilent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  void setFilter(OrderType filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setStatusFilter(OrderStatus? status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setStation(String station) {
    _selectedStation = station;
    notifyListeners();
  }

  void toggleLiveStatus() {
    _isLive = !_isLive;
    if (_isLive) {
      fetchOrders();
      _startAutoRefreshTimer();
    } else {
      _refreshTimer?.cancel();
    }
    notifyListeners();
  }

  List<KdsOrder> get filteredOrders {
    return _orders.where((o) {
      if (o.status == OrderStatus.completed) return false;
      if (_selectedFilter != OrderType.all && o.type != _selectedFilter) {
        return false;
      }
      if (_selectedStatusFilter != null && o.status != _selectedStatusFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  int get countAll =>
      _orders.where((o) => o.status != OrderStatus.completed).length;
  int get countDineIn => _orders
      .where(
        (o) => o.type == OrderType.dineIn && o.status != OrderStatus.completed,
      )
      .length;
  int get countTakeaway => _orders
      .where(
        (o) =>
            o.type == OrderType.takeaway && o.status != OrderStatus.completed,
      )
      .length;
  int get countDelivery => _orders
      .where(
        (o) =>
            o.type == OrderType.delivery && o.status != OrderStatus.completed,
      )
      .length;

  int get countNew =>
      _orders.where((o) => o.status == OrderStatus.newOrder).length;
  int get countInPrep =>
      _orders.where((o) => o.status == OrderStatus.inPreparation).length;
  int get countReady =>
      _orders.where((o) => o.status == OrderStatus.ready).length;
  int get countLate =>
      _orders.where((o) => o.status == OrderStatus.lateOrder).length;

  Future<StatusMsgModel?> startPreparation(String orderId) async {
    final intId = int.tryParse(orderId);
    if (intId != null) {
      final result = await _ordersApis.prepareAcceptedOrder(intId, branchId);
      if (result != null && result.status == 1) {
        final orderIndex = _orders.indexWhere((o) => o.id == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex].status = OrderStatus.inPreparation;
          notifyListeners();
        }
      }
      return result;
    }
    return null;
  }

  Future<StatusMsgModel?> completeOrder(String orderId) async {
    final intId = int.tryParse(orderId);
    if (intId != null) {
      final result = await _ordersApis.finishPreparedOrder(intId, branchId);
      if (result != null && result.status == 1) {
        final orderIndex = _orders.indexWhere((o) => o.id == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex].status = OrderStatus.completed;
          for (var item in _orders[orderIndex].items) {
            item.isCompleted = true;
          }
          _completedItemsByOrder
              .putIfAbsent(orderId, () => {})
              .addAll(_orders[orderIndex].items.map((i) => i.id));
          notifyListeners();
        }
      }
      return result;
    }
    return null;
  }

  void toggleItemCompletion(String orderId, String itemId) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      final itemIndex = order.items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        final newStatus = !order.items[itemIndex].isCompleted;
        order.items[itemIndex].isCompleted = newStatus;
        if (newStatus) {
          _completedItemsByOrder.putIfAbsent(orderId, () => {}).add(itemId);
        } else {
          _completedItemsByOrder[orderId]?.remove(itemId);
        }
        notifyListeners();
      }
    }
  }

  void refreshOrders() {
    _selectedStatusFilter = null;
    _selectedFilter = OrderType.all;
    fetchOrders();
  }

  void addOrder(KdsOrder order) {
    _orders.add(order);
    notifyListeners();
  }
}
