// To parse this JSON data, do
//
//     final currentKdsOrders = currentKdsOrdersFromJson(jsonString);

import 'dart:convert';
import 'package:kds/app/orders_cycle/models/kds_order_model.dart';

CurrentKdsOrders currentKdsOrdersFromJson(String str) =>
    CurrentKdsOrders.fromJson(json.decode(str));

String currentKdsOrdersToJson(CurrentKdsOrders data) =>
    json.encode(data.toJson());

class CurrentKdsOrders {
  int? status;
  List<Datum>? data;

  CurrentKdsOrders({this.status, this.data});

  CurrentKdsOrders copyWith({int? status, List<Datum>? data}) =>
      CurrentKdsOrders(status: status ?? this.status, data: data ?? this.data);

  factory CurrentKdsOrders.fromJson(Map<String, dynamic> json) =>
      CurrentKdsOrders(
        status: json["status"],
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
  bool? deliveryOrder;
  String? posReference;
  String? ticketCode;
  int? sessionId;
  String? sessionName;
  int? posId;
  String? posName;
  bool? isTipped;
  num? tipAmount;
  DateTime? dateOrder;
  double? amountTax;
  double? amountTotal;
  double? amountPaid;
  num? amountReturn;
  bool? refundOrder;
  bool? isKioskOrder;
  bool? isArchived;
  List<OrderLine>? orderLines;
  List<PaymentDatum>? paymentData;
  List<InvoiceDetail>? invoiceDetails;
  String? orderNumber;
  bool? isRefunded;

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
    this.deliveryOrder,
    this.posReference,
    this.ticketCode,
    this.sessionId,
    this.sessionName,
    this.posId,
    this.posName,
    this.isTipped,
    this.tipAmount,
    this.dateOrder,
    this.amountTax,
    this.amountTotal,
    this.amountPaid,
    this.amountReturn,
    this.refundOrder,
    this.isKioskOrder,
    this.isArchived,
    this.orderLines,
    this.paymentData,
    this.invoiceDetails,
    this.orderNumber,
    this.isRefunded,
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
    bool? deliveryOrder,
    String? posReference,
    String? ticketCode,
    int? sessionId,
    String? sessionName,
    int? posId,
    String? posName,
    bool? isTipped,
    num? tipAmount,
    DateTime? dateOrder,
    double? amountTax,
    double? amountTotal,
    double? amountPaid,
    num? amountReturn,
    bool? refundOrder,
    bool? isKioskOrder,
    bool? isArchived,
    List<OrderLine>? orderLines,
    List<PaymentDatum>? paymentData,
    List<InvoiceDetail>? invoiceDetails,
    String? orderNumber,
    bool? isRefunded,
  }) => Datum(
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
    deliveryOrder: deliveryOrder ?? this.deliveryOrder,
    posReference: posReference ?? this.posReference,
    ticketCode: ticketCode ?? this.ticketCode,
    sessionId: sessionId ?? this.sessionId,
    sessionName: sessionName ?? this.sessionName,
    posId: posId ?? this.posId,
    posName: posName ?? this.posName,
    isTipped: isTipped ?? this.isTipped,
    tipAmount: tipAmount ?? this.tipAmount,
    dateOrder: dateOrder ?? this.dateOrder,
    amountTax: amountTax ?? this.amountTax,
    amountTotal: amountTotal ?? this.amountTotal,
    amountPaid: amountPaid ?? this.amountPaid,
    amountReturn: amountReturn ?? this.amountReturn,
    refundOrder: refundOrder ?? this.refundOrder,
    isKioskOrder: isKioskOrder ?? this.isKioskOrder,
    isArchived: isArchived ?? this.isArchived,
    orderLines: orderLines ?? this.orderLines,
    paymentData: paymentData ?? this.paymentData,
    invoiceDetails: invoiceDetails ?? this.invoiceDetails,
    orderNumber: orderNumber ?? this.orderNumber,
    isRefunded: isRefunded ?? this.isRefunded,
  );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"]?.toString(),
    state: json["state"]?.toString(),
    kdsStatus: json["kds_status"]?.toString(),
    cashierId: json["cashier_id"],
    cashier: json["cashier"]?.toString(),
    customerId: json["customer_id"],
    customerName: json["customer_name"]?.toString(),
    customerPhone: json["customer_phone"]?.toString(),
    customerAddress: json["customer_address"]?.toString(),
    deliveryOrder: json["delivery_order"],
    posReference: json["pos_reference"]?.toString(),
    ticketCode: json["ticket_code"]?.toString(),
    sessionId: json["session_id"],
    sessionName: json["session_name"]?.toString(),
    posId: json["pos_id"],
    posName: json["pos_name"]?.toString(),
    isTipped: json["is_tipped"],
    tipAmount: json["tip_amount"],
    dateOrder: json["date_order"] == null
        ? null
        : (json["date_order"] is String
              ? DateTime.tryParse(json["date_order"])
              : null),
    amountTax: json["amount_tax"]?.toDouble(),
    amountTotal: json["amount_total"]?.toDouble(),
    amountPaid: json["amount_paid"]?.toDouble(),
    amountReturn: json["amount_return"],
    refundOrder: json["refund_order"],
    isKioskOrder: json["is_kiosk_order"],
    isArchived: json["is_archived"],
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
    orderNumber: json["order_number"]?.toString(),
    isRefunded: json["is_refunded"],
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
    "delivery_order": deliveryOrder,
    "pos_reference": posReference,
    "ticket_code": ticketCode,
    "session_id": sessionId,
    "session_name": sessionName,
    "pos_id": posId,
    "pos_name": posName,
    "is_tipped": isTipped,
    "tip_amount": tipAmount,
    "date_order": dateOrder?.toIso8601String(),
    "amount_tax": amountTax,
    "amount_total": amountTotal,
    "amount_paid": amountPaid,
    "amount_return": amountReturn,
    "refund_order": refundOrder,
    "is_kiosk_order": isKioskOrder,
    "is_archived": isArchived,
    "order_lines": orderLines == null
        ? []
        : List<dynamic>.from(orderLines!.map((x) => x.toJson())),
    "payment_data": paymentData == null
        ? []
        : List<dynamic>.from(paymentData!.map((x) => x.toJson())),
    "invoice_details": invoiceDetails == null
        ? []
        : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
    "order_number": orderNumber,
    "is_refunded": isRefunded,
  };

  KdsOrder toKdsOrder() {
    final now = DateTime.now();
    final created = dateOrder ?? now;
    final elapsed = now.difference(created);

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
        statusStr == 'done') {
      statusEnum = OrderStatus.completed;
    } else {
      statusEnum = OrderStatus.newOrder;
    }

    OrderType typeEnum = (deliveryOrder == true)
        ? OrderType.delivery
        : OrderType.dineIn;

    final displayName =
        (customerName != null && customerName!.trim().isNotEmpty)
        ? customerName!.trim()
        : ((customerPhone != null && customerPhone!.trim().isNotEmpty)
              ? customerPhone!.trim()
              : ((cashier != null && cashier!.trim().isNotEmpty)
                    ? cashier!.trim()
                    : 'Customer #${orderNumber ?? id}'));

    return KdsOrder(
      id: id?.toString() ?? '',
      orderNumber:
          orderNumber ??
          name ??
          posReference ??
          ticketCode ??
          id?.toString() ??
          '',
      type: typeEnum,
      status: statusEnum,
      customerName: displayName,
      serverName: cashier,
      tableInfoAr: null,
      tableInfoEn: null,
      deliveryProvider: deliveryOrder == true ? 'Delivery' : null,
      subtitleAr: null,
      subtitleEn: null,
      createdAt: created,
      elapsedDuration: elapsed.isNegative ? Duration.zero : elapsed,
      items: (orderLines ?? []).map((line) {
        final note = line.kitchenNote ?? line.customerNote;
        return KdsOrderItem(
          id: line.id?.toString() ?? '',
          nameAr: line.fullProductName ?? '',
          nameEn: line.fullProductName ?? '',
          quantity: line.qty?.toInt() ?? 1,
          modifierAr: note,
          modifierEn: note,
          isCompleted:
              statusEnum == OrderStatus.ready ||
              statusEnum == OrderStatus.completed,
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
  }) => InvoiceDetail(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    orderRef: orderRef ?? this.orderRef,
    state: state ?? this.state,
    date: date ?? this.date,
    untaxedAmount: untaxedAmount ?? this.untaxedAmount,
    taxes: taxes ?? this.taxes,
    total: total ?? this.total,
    amountDue: amountDue ?? this.amountDue,
  );

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
    id: json["id"],
    reference: json["reference"],
    orderRef: json["order_ref"],
    state: json["state"]?.toString(),
    date: json["date"] == null
        ? null
        : DateTime.tryParse(json["date"].toString()),
    untaxedAmount: json["untaxed_amount"]?.toDouble(),
    taxes: json["taxes"]?.toDouble(),
    total: json["total"]?.toDouble(),
    amountDue: json["amount_due"]?.toDouble(),
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
  };
}

class OrderLine {
  int? id;
  int? orderId;
  int? productId;
  String? fullProductName;
  double? priceUnit;
  int? qty;
  double? priceSubtotal;
  double? priceSubtotalIncl;
  int? discount;
  String? taxes;
  String? customerNote;
  String? kitchenNote;

  OrderLine({
    this.id,
    this.orderId,
    this.productId,
    this.fullProductName,
    this.priceUnit,
    this.qty,
    this.priceSubtotal,
    this.priceSubtotalIncl,
    this.discount,
    this.taxes,
    this.customerNote,
    this.kitchenNote,
  });

  OrderLine copyWith({
    int? id,
    int? orderId,
    int? productId,
    String? fullProductName,
    double? priceUnit,
    int? qty,
    double? priceSubtotal,
    double? priceSubtotalIncl,
    int? discount,
    String? taxes,
    String? customerNote,
    String? kitchenNote,
  }) => OrderLine(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    fullProductName: fullProductName ?? this.fullProductName,
    priceUnit: priceUnit ?? this.priceUnit,
    qty: qty ?? this.qty,
    priceSubtotal: priceSubtotal ?? this.priceSubtotal,
    priceSubtotalIncl: priceSubtotalIncl ?? this.priceSubtotalIncl,
    discount: discount ?? this.discount,
    taxes: taxes ?? this.taxes,
    customerNote: customerNote ?? this.customerNote,
    kitchenNote: kitchenNote ?? this.kitchenNote,
  );

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    fullProductName: json["full_product_name"],
    priceUnit: json["price_unit"]?.toDouble(),
    qty: json["qty"] is num ? (json["qty"] as num).toInt() : 1,
    priceSubtotal: json["price_subtotal"]?.toDouble(),
    priceSubtotalIncl: json["price_subtotal_incl"]?.toDouble(),
    discount: json["discount"] is num ? (json["discount"] as num).toInt() : 0,
    taxes: json["taxes"]?.toString(),
    customerNote: json["customer_note"],
    kitchenNote: json["kitchen_note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "full_product_name": fullProductName,
    "price_unit": priceUnit,
    "qty": qty,
    "price_subtotal": priceSubtotal,
    "price_subtotal_incl": priceSubtotalIncl,
    "discount": discount,
    "taxes": taxes,
    "customer_note": customerNote,
    "kitchen_note": kitchenNote,
  };
}

class PaymentDatum {
  int? id;
  double? amount;
  String? type;
  int? cashJournalId;

  PaymentDatum({this.id, this.amount, this.type, this.cashJournalId});

  PaymentDatum copyWith({
    int? id,
    double? amount,
    String? type,
    int? cashJournalId,
  }) => PaymentDatum(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    cashJournalId: cashJournalId ?? this.cashJournalId,
  );

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
    id: json["id"],
    amount: json["amount"]?.toDouble(),
    type: json["type"]?.toString(),
    cashJournalId: json["cash_journal_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "type": type,
    "cash_journal_id": cashJournalId,
  };
}
