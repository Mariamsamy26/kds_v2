// To parse this JSON data, do
//
//     final historyKdsOrders = historyKdsOrdersFromJson(jsonString);

import 'dart:convert';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';
import 'package:kds/app/history_cycle/models/history_order_model.dart';

double? _toDouble(dynamic val) {
  if (val == null) return null;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString());
}

int? _toInt(dynamic val) {
  if (val == null) return null;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString());
}

HistoryKdsOrders historyKdsOrdersFromJson(String str) =>
    HistoryKdsOrders.fromJson(json.decode(str));

String historyKdsOrdersToJson(HistoryKdsOrders data) =>
    json.encode(data.toJson());

class HistoryKdsOrders {
  int? status;
  List<Datum>? data;

  HistoryKdsOrders({
    this.status,
    this.data,
  });

  HistoryKdsOrders copyWith({
    int? status,
    List<Datum>? data,
  }) =>
      HistoryKdsOrders(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory HistoryKdsOrders.fromJson(Map<String, dynamic> json) =>
      HistoryKdsOrders(
        status: _toInt(json["status"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? state;
  String? kdsStatus;
  int? cashierId;
  String? cashier;
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? waiterName;
  bool? deliveryOrder;
  String? posReference;
  String? ticketCode;
  int? sessionId;
  String? sessionName;
  String? sessionState;
  int? posId;
  String? posName;
  int? branchId;
  bool? isTipped;
  double? tipAmount;
  String? dateOrder;
  double? amountTax;
  double? amountTotal;
  double? amountPaid;
  double? amountReturn;
  bool? refundOrder;
  bool? isRefunded;
  bool? toInvoice;
  bool? isKioskOrder;
  bool? isArchived;
  String? orderNumber;
  bool? retailOrder;
  bool? restaurantOrder;
  int? tableId;
  int? tableNumber;
  int? customerCount;
  int? floorId;
  bool? isMergedOrder;
  int? mergedWithTableId;
  int? mergedWithTableNumber;
  bool? isSplitOrder;
  int? splitParentOrderId;
  String? splitParentOrderName;
  List<OrderLine>? orderLines;
  List<PaymentDatum>? paymentData;
  List<InvoiceDetail>? invoiceDetails;

  Datum({
    this.id,
    this.name,
    this.state,
    this.kdsStatus,
    this.cashierId,
    this.cashier,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.waiterName,
    this.deliveryOrder,
    this.posReference,
    this.ticketCode,
    this.sessionId,
    this.sessionName,
    this.sessionState,
    this.posId,
    this.posName,
    this.branchId,
    this.isTipped,
    this.tipAmount,
    this.dateOrder,
    this.amountTax,
    this.amountTotal,
    this.amountPaid,
    this.amountReturn,
    this.refundOrder,
    this.isRefunded,
    this.toInvoice,
    this.isKioskOrder,
    this.isArchived,
    this.orderNumber,
    this.retailOrder,
    this.restaurantOrder,
    this.tableId,
    this.tableNumber,
    this.customerCount,
    this.floorId,
    this.isMergedOrder,
    this.mergedWithTableId,
    this.mergedWithTableNumber,
    this.isSplitOrder,
    this.splitParentOrderId,
    this.splitParentOrderName,
    this.orderLines,
    this.paymentData,
    this.invoiceDetails,
  });

  Datum copyWith({
    int? id,
    String? name,
    String? state,
    String? kdsStatus,
    int? cashierId,
    String? cashier,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? waiterName,
    bool? deliveryOrder,
    String? posReference,
    String? ticketCode,
    int? sessionId,
    String? sessionName,
    String? sessionState,
    int? posId,
    String? posName,
    int? branchId,
    bool? isTipped,
    double? tipAmount,
    String? dateOrder,
    double? amountTax,
    double? amountTotal,
    double? amountPaid,
    double? amountReturn,
    bool? refundOrder,
    bool? isRefunded,
    bool? toInvoice,
    bool? isKioskOrder,
    bool? isArchived,
    String? orderNumber,
    bool? retailOrder,
    bool? restaurantOrder,
    int? tableId,
    int? tableNumber,
    int? customerCount,
    int? floorId,
    bool? isMergedOrder,
    int? mergedWithTableId,
    int? mergedWithTableNumber,
    bool? isSplitOrder,
    int? splitParentOrderId,
    String? splitParentOrderName,
    List<OrderLine>? orderLines,
    List<PaymentDatum>? paymentData,
    List<InvoiceDetail>? invoiceDetails,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        state: state ?? this.state,
        kdsStatus: kdsStatus ?? this.kdsStatus,
        cashierId: cashierId ?? this.cashierId,
        cashier: cashier ?? this.cashier,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerAddress: customerAddress ?? this.customerAddress,
        waiterName: waiterName ?? this.waiterName,
        deliveryOrder: deliveryOrder ?? this.deliveryOrder,
        posReference: posReference ?? this.posReference,
        ticketCode: ticketCode ?? this.ticketCode,
        sessionId: sessionId ?? this.sessionId,
        sessionName: sessionName ?? this.sessionName,
        sessionState: sessionState ?? this.sessionState,
        posId: posId ?? this.posId,
        posName: posName ?? this.posName,
        branchId: branchId ?? this.branchId,
        isTipped: isTipped ?? this.isTipped,
        tipAmount: tipAmount ?? this.tipAmount,
        dateOrder: dateOrder ?? this.dateOrder,
        amountTax: amountTax ?? this.amountTax,
        amountTotal: amountTotal ?? this.amountTotal,
        amountPaid: amountPaid ?? this.amountPaid,
        amountReturn: amountReturn ?? this.amountReturn,
        refundOrder: refundOrder ?? this.refundOrder,
        isRefunded: isRefunded ?? this.isRefunded,
        toInvoice: toInvoice ?? this.toInvoice,
        isKioskOrder: isKioskOrder ?? this.isKioskOrder,
        isArchived: isArchived ?? this.isArchived,
        orderNumber: orderNumber ?? this.orderNumber,
        retailOrder: retailOrder ?? this.retailOrder,
        restaurantOrder: restaurantOrder ?? this.restaurantOrder,
        tableId: tableId ?? this.tableId,
        tableNumber: tableNumber ?? this.tableNumber,
        customerCount: customerCount ?? this.customerCount,
        floorId: floorId ?? this.floorId,
        isMergedOrder: isMergedOrder ?? this.isMergedOrder,
        mergedWithTableId: mergedWithTableId ?? this.mergedWithTableId,
        mergedWithTableNumber:
            mergedWithTableNumber ?? this.mergedWithTableNumber,
        isSplitOrder: isSplitOrder ?? this.isSplitOrder,
        splitParentOrderId: splitParentOrderId ?? this.splitParentOrderId,
        splitParentOrderName: splitParentOrderName ?? this.splitParentOrderName,
        orderLines: orderLines ?? this.orderLines,
        paymentData: paymentData ?? this.paymentData,
        invoiceDetails: invoiceDetails ?? this.invoiceDetails,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: _toInt(json["id"]),
    name: json["name"],
    state: json["state"],
    kdsStatus: json["kds_status"],
    cashierId: _toInt(json["cashier_id"]),
    cashier: json["cashier"],
    customerId: _toInt(json["customer_id"]),
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    customerAddress: json["customer_address"],
    waiterName: json["waiter_name"],
    deliveryOrder: json["delivery_order"],
    posReference: json["pos_reference"],
    ticketCode: json["ticket_code"],
    sessionId: _toInt(json["session_id"]),
    sessionName: json["session_name"],
    sessionState: json["session_state"],
    posId: _toInt(json["pos_id"]),
    posName: json["pos_name"],
    branchId: _toInt(json["branch_id"]),
    isTipped: json["is_tipped"],
    tipAmount: _toDouble(json["tip_amount"]),
    dateOrder: json["date_order"]?.toString(),
    amountTax: _toDouble(json["amount_tax"]),
    amountTotal: _toDouble(json["amount_total"]),
    amountPaid: _toDouble(json["amount_paid"]),
    amountReturn: _toDouble(json["amount_return"]),
    refundOrder: json["refund_order"],
    isRefunded: json["is_refunded"],
    toInvoice: json["to_invoice"],
    isKioskOrder: json["is_kiosk_order"],
    isArchived: json["is_archived"],
    orderNumber: json["order_number"]?.toString(),
    retailOrder: json["retail_order"],
    restaurantOrder: json["restaurant_order"],
    tableId: _toInt(json["table_id"]),
    tableNumber: _toInt(json["table_number"]),
    customerCount: _toInt(json["customer_count"]),
    floorId: _toInt(json["floor_id"]),
    isMergedOrder: json["is_merged_order"],
    mergedWithTableId: _toInt(json["merged_with_table_id"]),
    mergedWithTableNumber: _toInt(json["merged_with_table_number"]),
    isSplitOrder: json["is_split_order"],
    splitParentOrderId: _toInt(json["split_parent_order_id"]),
    splitParentOrderName: json["split_parent_order_name"],
    orderLines: json["order_lines"] == null
        ? []
        : List<OrderLine>.from(
            json["order_lines"]!.map((x) => OrderLine.fromJson(x)),
          ),
    paymentData: json["payment_data"] == null
        ? []
        : List<PaymentDatum>.from(
            json["payment_data"]!.map((x) => PaymentDatum.fromJson(x)),
          ),
    invoiceDetails: json["invoice_details"] == null
        ? []
        : List<InvoiceDetail>.from(
            json["invoice_details"]!.map((x) => InvoiceDetail.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "kds_status": kdsStatus,
    "cashier_id": cashierId,
    "cashier": cashier,
    "customer_id": customerId,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "customer_address": customerAddress,
    "waiter_name": waiterName,
    "delivery_order": deliveryOrder,
    "pos_reference": posReference,
    "ticket_code": ticketCode,
    "session_id": sessionId,
    "session_name": sessionName,
    "session_state": sessionState,
    "pos_id": posId,
    "pos_name": posName,
    "branch_id": branchId,
    "is_tipped": isTipped,
    "tip_amount": tipAmount,
    "date_order": dateOrder,
    "amount_tax": amountTax,
    "amount_total": amountTotal,
    "amount_paid": amountPaid,
    "amount_return": amountReturn,
    "refund_order": refundOrder,
    "is_refunded": isRefunded,
    "to_invoice": toInvoice,
    "is_kiosk_order": isKioskOrder,
    "is_archived": isArchived,
    "order_number": orderNumber,
    "retail_order": retailOrder,
    "restaurant_order": restaurantOrder,
    "table_id": tableId,
    "table_number": tableNumber,
    "customer_count": customerCount,
    "floor_id": floorId,
    "is_merged_order": isMergedOrder,
    "merged_with_table_id": mergedWithTableId,
    "merged_with_table_number": mergedWithTableNumber,
    "is_split_order": isSplitOrder,
    "split_parent_order_id": splitParentOrderId,
    "split_parent_order_name": splitParentOrderName,
    "order_lines": orderLines == null
        ? []
        : List<dynamic>.from(orderLines!.map((x) => x.toJson())),
    "payment_data": paymentData == null
        ? []
        : List<dynamic>.from(paymentData!.map((x) => x.toJson())),
    "invoice_details": invoiceDetails == null
        ? []
        : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
  };

  HistoryOrder toHistoryOrder() {
    DateTime created = DateTime.now();
    if (dateOrder != null && dateOrder!.trim().isNotEmpty) {
      created = DateTime.tryParse(dateOrder!) ?? DateTime.now();
    }

    final pickupTimeStr =
        "${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}";

    OrderStatus statusEnum;
    final statusStr = (kdsStatus ?? state ?? '').toLowerCase();
    if (statusStr == 'in_preparation' || statusStr == 'preparing') {
      statusEnum = OrderStatus.inPreparation;
    } else if (statusStr == 'ready') {
      statusEnum = OrderStatus.ready;
    } else if (statusStr == 'late') {
      statusEnum = OrderStatus.lateOrder;
    } else if (statusStr == 'completed' ||
        statusStr == 'finished' ||
        statusStr == 'done' ||
        statusStr == 'invoiced' ||
        statusStr == 'paid') {
      statusEnum = OrderStatus.completed;
    } else {
      statusEnum = OrderStatus.newOrder;
    }

    OrderType typeEnum = (deliveryOrder == true)
        ? OrderType.delivery
        : ((retailOrder == true) ? OrderType.takeaway : OrderType.dineIn);

    final bool isCancelledOrder =
        (refundOrder == true) ||
        (isRefunded == true) ||
        (statusStr == 'cancel' || statusStr == 'cancelled');

    final tableInfo = (tableNumber != null && tableNumber != 0)
        ? 'Table $tableNumber'
        : ((tableId != null && tableId != 0) ? 'Table $tableId' : null);

    final displayName =
        (customerName != null && customerName!.trim().isNotEmpty)
            ? customerName!.trim()
            : ((customerPhone != null && customerPhone!.trim().isNotEmpty)
                ? customerPhone!.trim()
                : ((cashier != null && cashier!.trim().isNotEmpty)
                    ? cashier!.trim()
                    : ((waiterName != null && waiterName!.trim().isNotEmpty)
                        ? waiterName!.trim()
                        : 'Customer #${orderNumber ?? id}')));

    final String finalOrderNum =
        (orderNumber != null && orderNumber!.trim().isNotEmpty)
            ? orderNumber!.trim()
            : ((name != null && name!.trim().isNotEmpty)
                ? name!.trim()
                : ((posReference != null && posReference!.trim().isNotEmpty)
                    ? posReference!.trim()
                    : ((ticketCode != null && ticketCode!.trim().isNotEmpty)
                        ? ticketCode!.trim()
                        : (id?.toString() ?? ''))));

    return HistoryOrder(
      id: id?.toString() ?? '',
      orderNumber: finalOrderNum,
      type: typeEnum,
      status: statusEnum,
      tableInfoAr: tableInfo,
      tableInfoEn: tableInfo,
      pickupTime: pickupTimeStr,
      durationMinutes: '15m',
      customerName: displayName,
      createdAt: created,
      isCancelled: isCancelledOrder,
      items: (orderLines ?? []).map((line) {
        final note = (line.kitchenNote != null && line.kitchenNote!.isNotEmpty)
            ? line.kitchenNote
            : line.customerNote;
        final nameAr = (line.productNameAr != null && line.productNameAr!.isNotEmpty)
            ? line.productNameAr!
            : ((line.fullProductName != null && line.fullProductName!.isNotEmpty)
                ? line.fullProductName!
                : (line.productName ?? ''));
        final nameEn = (line.productName != null && line.productName!.isNotEmpty)
            ? line.productName!
            : ((line.fullProductName != null && line.fullProductName!.isNotEmpty)
                ? line.fullProductName!
                : (line.productNameAr ?? ''));
        return KdsOrderItem(
          id: line.id?.toString() ?? '',
          nameAr: nameAr,
          nameEn: nameEn,
          quantity: (line.qty != null) ? line.qty!.toInt() : 1,
          modifierAr: note,
          modifierEn: note,
          isCompleted: true,
        );
      }).toList(),
    );
  }
}

class InvoiceDetail {
  int? id;
  String? reference;
  String? orderRef;
  String? state;
  DateTime? date;
  double? untaxedAmount;
  double? taxes;
  double? total;
  double? amountDue;
  List<dynamic>? paymentJournals;

  InvoiceDetail({
    this.id,
    this.reference,
    this.orderRef,
    this.state,
    this.date,
    this.untaxedAmount,
    this.taxes,
    this.total,
    this.amountDue,
    this.paymentJournals,
  });

  InvoiceDetail copyWith({
    int? id,
    String? reference,
    String? orderRef,
    String? state,
    DateTime? date,
    double? untaxedAmount,
    double? taxes,
    double? total,
    double? amountDue,
    List<dynamic>? paymentJournals,
  }) =>
      InvoiceDetail(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        orderRef: orderRef ?? this.orderRef,
        state: state ?? this.state,
        date: date ?? this.date,
        untaxedAmount: untaxedAmount ?? this.untaxedAmount,
        taxes: taxes ?? this.taxes,
        total: total ?? this.total,
        amountDue: amountDue ?? this.amountDue,
        paymentJournals: paymentJournals ?? this.paymentJournals,
      );

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
    id: _toInt(json["id"]),
    reference: json["reference"],
    orderRef: json["order_ref"],
    state: json["state"],
    date: json["date"] == null ? null : DateTime.tryParse(json["date"].toString()),
    untaxedAmount: _toDouble(json["untaxed_amount"]),
    taxes: _toDouble(json["taxes"]),
    total: _toDouble(json["total"]),
    amountDue: _toDouble(json["amount_due"]),
    paymentJournals: json["payment_journals"] == null
        ? []
        : List<dynamic>.from(json["payment_journals"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference,
    "order_ref": orderRef,
    "state": state,
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "untaxed_amount": untaxedAmount,
    "taxes": taxes,
    "total": total,
    "amount_due": amountDue,
    "payment_journals": paymentJournals == null
        ? []
        : List<dynamic>.from(paymentJournals!.map((x) => x)),
  };
}

class OrderLine {
  int? id;
  int? orderId;
  int? productId;
  String? fullProductName;
  String? productName;
  String? productNameAr;
  double? priceUnit;
  double? qty;
  double? priceSubtotal;
  double? priceSubtotalIncl;
  double? discount;
  List<dynamic>? taxIds;
  String? taxes;
  double? taxPercent;
  String? productSellingType;
  String? priceType;
  String? uuid;
  String? lineTimestamp;
  int? attachedProductId;
  String? uomName;
  String? customerNote;
  String? kitchenNote;
  bool? isVariant;

  OrderLine({
    this.id,
    this.orderId,
    this.productId,
    this.fullProductName,
    this.productName,
    this.productNameAr,
    this.priceUnit,
    this.qty,
    this.priceSubtotal,
    this.priceSubtotalIncl,
    this.discount,
    this.taxIds,
    this.taxes,
    this.taxPercent,
    this.productSellingType,
    this.priceType,
    this.uuid,
    this.lineTimestamp,
    this.attachedProductId,
    this.uomName,
    this.customerNote,
    this.kitchenNote,
    this.isVariant,
  });

  OrderLine copyWith({
    int? id,
    int? orderId,
    int? productId,
    String? fullProductName,
    String? productName,
    String? productNameAr,
    double? priceUnit,
    double? qty,
    double? priceSubtotal,
    double? priceSubtotalIncl,
    double? discount,
    List<dynamic>? taxIds,
    String? taxes,
    double? taxPercent,
    String? productSellingType,
    String? priceType,
    String? uuid,
    String? lineTimestamp,
    int? attachedProductId,
    String? uomName,
    String? customerNote,
    String? kitchenNote,
    bool? isVariant,
  }) =>
      OrderLine(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        fullProductName: fullProductName ?? this.fullProductName,
        productName: productName ?? this.productName,
        productNameAr: productNameAr ?? this.productNameAr,
        priceUnit: priceUnit ?? this.priceUnit,
        qty: qty ?? this.qty,
        priceSubtotal: priceSubtotal ?? this.priceSubtotal,
        priceSubtotalIncl: priceSubtotalIncl ?? this.priceSubtotalIncl,
        discount: discount ?? this.discount,
        taxIds: taxIds ?? this.taxIds,
        taxes: taxes ?? this.taxes,
        taxPercent: taxPercent ?? this.taxPercent,
        productSellingType: productSellingType ?? this.productSellingType,
        priceType: priceType ?? this.priceType,
        uuid: uuid ?? this.uuid,
        lineTimestamp: lineTimestamp ?? this.lineTimestamp,
        attachedProductId: attachedProductId ?? this.attachedProductId,
        uomName: uomName ?? this.uomName,
        customerNote: customerNote ?? this.customerNote,
        kitchenNote: kitchenNote ?? this.kitchenNote,
        isVariant: isVariant ?? this.isVariant,
      );

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
    id: _toInt(json["id"]),
    orderId: _toInt(json["order_id"]),
    productId: _toInt(json["product_id"]),
    fullProductName: json["full_product_name"],
    productName: json["product_name"],
    productNameAr: json["product_name_ar"],
    priceUnit: _toDouble(json["price_unit"]),
    qty: _toDouble(json["qty"]),
    priceSubtotal: _toDouble(json["price_subtotal"]),
    priceSubtotalIncl: _toDouble(json["price_subtotal_incl"]),
    discount: _toDouble(json["discount"]),
    taxIds: json["tax_ids"] == null
        ? []
        : List<dynamic>.from(json["tax_ids"]!.map((x) => x)),
    taxes: json["taxes"]?.toString(),
    taxPercent: _toDouble(json["tax_percent"]),
    productSellingType: json["product_selling_type"],
    priceType: json["price_type"],
    uuid: json["uuid"],
    lineTimestamp: json["line_timestamp"],
    attachedProductId: _toInt(json["attached_product_id"]),
    uomName: json["uom_name"],
    customerNote: json["customer_note"],
    kitchenNote: json["kitchen_note"],
    isVariant: json["is_variant"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "full_product_name": fullProductName,
    "product_name": productName,
    "product_name_ar": productNameAr,
    "price_unit": priceUnit,
    "qty": qty,
    "price_subtotal": priceSubtotal,
    "price_subtotal_incl": priceSubtotalIncl,
    "discount": discount,
    "tax_ids": taxIds == null ? [] : List<dynamic>.from(taxIds!.map((x) => x)),
    "taxes": taxes,
    "tax_percent": taxPercent,
    "product_selling_type": productSellingType,
    "price_type": priceType,
    "uuid": uuid,
    "line_timestamp": lineTimestamp,
    "attached_product_id": attachedProductId,
    "uom_name": uomName,
    "customer_note": customerNote,
    "kitchen_note": kitchenNote,
    "is_variant": isVariant,
  };
}

class PaymentDatum {
  int? id;
  double? amount;
  String? type;
  int? cashJournalId;

  PaymentDatum({
    this.id,
    this.amount,
    this.type,
    this.cashJournalId,
  });

  PaymentDatum copyWith({
    int? id,
    double? amount,
    String? type,
    int? cashJournalId,
  }) =>
      PaymentDatum(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        cashJournalId: cashJournalId ?? this.cashJournalId,
      );

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
    id: _toInt(json["id"]),
    amount: _toDouble(json["amount"]),
    type: json["type"],
    cashJournalId: _toInt(json["cash_journal_id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "type": type,
    "cash_journal_id": cashJournalId,
  };
}
