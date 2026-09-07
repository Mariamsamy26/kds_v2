import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';
import 'package:kds/app/orders_cycle/services/orders_apis.dart';

class KdsProvider extends ChangeNotifier {
  OrderType _selectedFilter = OrderType.all;
  OrderStatus? _selectedStatusFilter; // null means All Orders
  String _selectedStation = '1';
  bool _isLive = true;
  Timer? _timer;
  bool _isLoading = false;
  String? _errorMessage;

  List<KdsOrder> _orders = [];
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var order in _orders) {
        if (order.status != OrderStatus.completed) {
          order.elapsedDuration += const Duration(seconds: 1);
        }
      }
      notifyListeners();
    });
  }

  Future<void> fetchOrders({int posId = 0}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final currentKdsOrders = await _ordersApis.getCurrentKDSOrders(posId);
      if (currentKdsOrders != null && currentKdsOrders.data != null) {
        _orders = currentKdsOrders.data!
            .map((datum) => datum.toKdsOrder())
            .toList();
      } else {
        _orders = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
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

  Future<void> startPreparation(String orderId) async {
    final intId = int.tryParse(orderId);
    if (intId != null) {
      try {
        await _ordersApis.prepareAcceptedOrder(intId);
      } catch (e) {
        debugPrint("Error preparing order $orderId: $e");
      }
    }
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex].status = OrderStatus.inPreparation;
      notifyListeners();
    }
  }

  Future<void> markAsReady(String orderId) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      if (!order.areAllItemsCompleted && order.items.isNotEmpty) {
        return;
      }
      final intId = int.tryParse(orderId);
      if (intId != null) {
        try {
          await _ordersApis.finishPreparedOrder(intId);
        } catch (e) {
          debugPrint("Error finishing order $orderId: $e");
        }
      }
      order.status = OrderStatus.ready;
      for (var item in order.items) {
        item.isCompleted = true;
      }
      notifyListeners();
    }
  }

  Future<void> completeOrder(String orderId) async {
    final intId = int.tryParse(orderId);
    if (intId != null) {
      try {
        await _ordersApis.finishPreparedOrder(intId);
      } catch (e) {
        debugPrint("Error completing order $orderId: $e");
      }
    }
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex].status = OrderStatus.completed;
      notifyListeners();
    }
  }

  void toggleItemCompletion(String orderId, String itemId) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      final itemIndex = order.items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        order.items[itemIndex].isCompleted =
            !order.items[itemIndex].isCompleted;
        notifyListeners();
      }
    }
  }

  void refreshOrders() {
    _selectedStatusFilter = null;
    _selectedFilter = OrderType.all;
    fetchOrders();
  }
}
