enum OrderStatus { newOrder, inPreparation, lateOrder, ready, completed }

enum OrderType { all, dineIn, takeaway, delivery }

class KdsOrderItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final int quantity;
  final String? modifierAr;
  final String? modifierEn;
  bool isCompleted;

  KdsOrderItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.quantity = 1,
    this.modifierAr,
    this.modifierEn,
    this.isCompleted = false,
  });

  KdsOrderItem copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    int? quantity,
    String? modifierAr,
    String? modifierEn,
    bool? isCompleted,
  }) {
    return KdsOrderItem(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      quantity: quantity ?? this.quantity,
      modifierAr: modifierAr ?? this.modifierAr,
      modifierEn: modifierEn ?? this.modifierEn,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class KdsOrder {
  final String id;
  final String orderNumber;
  final OrderType type;
  OrderStatus status;
  final String customerName;
  final String? serverName;
  final String? tableInfoAr;
  final String? tableInfoEn;
  final String? deliveryProvider;
  final String? subtitleAr;
  final String? subtitleEn;
  final DateTime createdAt;
  Duration elapsedDuration;
  final List<KdsOrderItem> items;
  final int? branchId;

  KdsOrder({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.customerName,
    this.serverName,
    this.tableInfoAr,
    this.tableInfoEn,
    this.deliveryProvider,
    this.subtitleAr,
    this.subtitleEn,
    required this.createdAt,
    required this.elapsedDuration,
    required this.items,
    this.branchId,
  });

  int get completedItemsCount => items.where((item) => item.isCompleted).length;

  int get totalItemsCount => items.length;

  // Empty items list is treated as "all done" so the button stays enabled.
  bool get areAllItemsCompleted =>
      items.isEmpty || items.every((item) => item.isCompleted);
}
