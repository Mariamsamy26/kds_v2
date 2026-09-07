import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../orders_cycle/models/kds_order_model.dart';
import '../models/history_order_model.dart';

class PdfExportService {
  static Future<String?> exportHistoryPdf({
    required List<HistoryOrder> orders,
    required HistoryMetrics metrics,
    DateTimeRange? dateRange,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    final now = DateTime.now();
    final generationTimeStr = _formatDateTime(now);

    // Dynamic metrics calculation from actual orders list
    final totalOrders = orders.length;
    final completedOrders = orders
        .where((o) => o.status == OrderStatus.completed)
        .length;
    final dineInOrders = orders.where((o) => o.type == OrderType.dineIn).length;
    final takeawayOrders = orders
        .where((o) => o.type == OrderType.takeaway)
        .length;
    final deliveryOrders = orders
        .where((o) => o.type == OrderType.delivery)
        .length;

    final totalItemsPrepared = orders.fold<int>(
      0,
      (sum, o) =>
          sum + o.items.fold<int>(0, (iSum, item) => iSum + item.quantity),
    );

    final completionRate = totalOrders > 0
        ? ((completedOrders / totalOrders) * 100).toStringAsFixed(1)
        : '0.0';

    final periodStr = dateRange != null
        ? '${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)}'
        : 'All Records / جميع السجلات';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        header: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            padding: const pw.EdgeInsets.only(bottom: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.blueGrey200, width: 1.2),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // English Title & Subtitle
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _text(
                      'KDS Kitchen History & Operations Report',
                      font: font,
                      fontBold: fontBold,
                      bold: true,
                      fontSize: 15,
                      color: PdfColor.fromHex('#0F172A'),
                    ),
                    pw.SizedBox(height: 2),
                    _text(
                      'Generated: $generationTimeStr  •  Period: $periodStr',
                      font: font,
                      fontBold: fontBold,
                      fontSize: 8.5,
                      color: PdfColor.fromHex('#64748B'),
                    ),
                  ],
                ),

                // Arabic Title & Info
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _text(
                      'تقرير سجل وعمليات المطبخ',
                      font: font,
                      fontBold: fontBold,
                      bold: true,
                      fontSize: 15,
                      color: PdfColor.fromHex('#0284C7'),
                      rtl: true,
                    ),
                    pw.SizedBox(height: 2),
                    _text(
                      'إجمالي الطلبات المستخرجة: $totalOrders طلب',
                      font: font,
                      fontBold: fontBold,
                      fontSize: 8.5,
                      color: PdfColor.fromHex('#64748B'),
                      rtl: true,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 10),
            padding: const pw.EdgeInsets.only(top: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey300, width: 0.8),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _text(
                  'KDS System  •  Confidential Operations Report',
                  font: font,
                  fontBold: fontBold,
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
                _text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  font: font,
                  fontBold: fontBold,
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) => [
          // KPI Summary Cards
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Row(
              children: [
                _kpiCard(
                  titleEn: 'Total Orders',
                  titleAr: 'إجمالي الطلبات',
                  value: '$totalOrders',
                  accentColor: PdfColor.fromHex('#2563EB'),
                  font: font,
                  fontBold: fontBold,
                ),
                pw.SizedBox(width: 8),
                _kpiCard(
                  titleEn: 'Completed',
                  titleAr: 'المكتملة بنجاح',
                  value: '$completedOrders ($completionRate%)',
                  accentColor: PdfColor.fromHex('#16A34A'),
                  font: font,
                  fontBold: fontBold,
                ),
                pw.SizedBox(width: 8),
                _kpiCard(
                  titleEn: 'Total Items',
                  titleAr: 'إجمالي الأصناف',
                  value: '$totalItemsPrepared pcs',
                  accentColor: PdfColor.fromHex('#D97706'),
                  font: font,
                  fontBold: fontBold,
                ),
                pw.SizedBox(width: 8),
                _kpiCard(
                  titleEn: 'Order Breakdown',
                  titleAr: 'توزيع الطلبات',
                  value:
                      'Dine:$dineInOrders | Take:$takeawayOrders | Deliv:$deliveryOrders',
                  accentColor: PdfColor.fromHex('#7C3AED'),
                  font: font,
                  fontBold: fontBold,
                ),
              ],
            ),
          ),

          // Orders Table
          if (orders.isEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.all(30),
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8FAFC'),
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0')),
              ),
              child: _text(
                'لا توجد طلبات مطابقة للفلاتر المحددة / No orders found for the selected filters',
                font: font,
                fontBold: fontBold,
                fontSize: 11,
                color: PdfColors.grey700,
                bold: true,
              ),
            )
          else
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex('#CBD5E1'),
                width: 0.6,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.8), // Order #
                1: const pw.FlexColumnWidth(1.2), // Date & Time
                2: const pw.FlexColumnWidth(1.2), // Type / Table
                3: const pw.FlexColumnWidth(1.3), // Customer
                4: const pw.FlexColumnWidth(0.8), // Duration
                5: const pw.FlexColumnWidth(0.9), // Status
                6: const pw.FlexColumnWidth(3.8), // Items & Notes
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#1E293B'),
                  ),
                  children: [
                    _headerCell('Order #\nالطلب', font, fontBold),
                    _headerCell('Date & Time\nالتاريخ والوقت', font, fontBold),
                    _headerCell(
                      'Type / Table\nالنوع / الطاولة',
                      font,
                      fontBold,
                    ),
                    _headerCell('Customer\nالعميل', font, fontBold),
                    _headerCell('Duration\nالمدة', font, fontBold),
                    _headerCell('Status\nالحالة', font, fontBold),
                    _headerCell(
                      'Items & Modifiers\nالأصناف والملاحظات',
                      font,
                      fontBold,
                    ),
                  ],
                ),

                // Table Rows
                ...orders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  final isEven = index % 2 == 0;
                  final rowBg = isEven
                      ? PdfColors.white
                      : PdfColor.fromHex('#F8FAFC');

                  final orderNumberDisplay = order.id.isNotEmpty
                      ? '#${order.id}'
                      : '#${order.orderNumber}';

                  final dateStr =
                      '${_formatDate(order.createdAt)}\n${order.pickupTime}';

                  final typeStr = _formatOrderType(
                    order.type,
                    order.tableInfoAr,
                    order.tableInfoEn,
                  );

                  final statusStr = _formatOrderStatus(order.status);

                  final itemsText = _formatItemsList(order.items);

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: rowBg),
                    children: [
                      _cell(
                        orderNumberDisplay,
                        font,
                        fontBold,
                        bold: true,
                        fontSize: 8.5,
                      ),
                      _cell(dateStr, font, fontBold, fontSize: 8),
                      _cell(typeStr, font, fontBold, fontSize: 8),
                      _cell(order.customerName, font, fontBold, fontSize: 8),
                      _cell(order.durationMinutes, font, fontBold, fontSize: 8),
                      _cell(statusStr, font, fontBold, fontSize: 8),
                      _cell(itemsText, font, fontBold, fontSize: 8),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );

    final bytes = await pdf.save();

    final dateStamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    final filename = 'KDS_History_Report_$dateStamp.pdf';

    try {
      if (kIsWeb) {
        await Printing.sharePdf(bytes: bytes, filename: filename);
        return filename;
      }

      Directory? outputDir;
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        outputDir = await getDownloadsDirectory();
      }
      outputDir ??= await getApplicationDocumentsDirectory();

      final file = File('${outputDir.path}/$filename');
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
      return filename;
    }
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  static String _formatDateTime(DateTime dt) {
    return '${_formatDate(dt)} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _formatOrderType(
    OrderType type,
    String? tableInfoAr,
    String? tableInfoEn,
  ) {
    String typeName;
    switch (type) {
      case OrderType.dineIn:
        typeName = 'Dine In / صالة';
        break;
      case OrderType.takeaway:
        typeName = 'Takeaway / تيك اواي';
        break;
      case OrderType.delivery:
        typeName = 'Delivery / توصيل';
        break;
      case OrderType.all:
        typeName = 'All / الكل';
        break;
    }

    final table = (tableInfoAr ?? tableInfoEn ?? '').trim();
    if (table.isNotEmpty) {
      return '$typeName\n($table)';
    }
    return typeName;
  }

  static String _formatOrderStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'Completed\nمكتمل';
      case OrderStatus.ready:
        return 'Ready\nجاهز';
      case OrderStatus.inPreparation:
        return 'Preparing\nقيد التجهيز';
      case OrderStatus.lateOrder:
        return 'Late\nمتأخر';
      case OrderStatus.newOrder:
        return 'New\nجديد';
    }
  }

  static String _formatItemsList(List<KdsOrderItem> items) {
    if (items.isEmpty) return '-';

    return items
        .map((item) {
          final name = item.nameAr.isNotEmpty ? item.nameAr : item.nameEn;
          final modifier = (item.modifierAr ?? item.modifierEn ?? '').trim();
          final modStr = modifier.isNotEmpty ? ' ($modifier)' : '';
          return '${item.quantity}x $name$modStr';
        })
        .join('  •  ');
  }

  static bool _hasArabic(String text) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(text);
  }

  static pw.Widget _text(
    String text, {
    required pw.Font font,
    required pw.Font fontBold,
    bool bold = false,
    bool? rtl,
    double fontSize = 9,
    PdfColor color = PdfColors.black,
  }) {
    final isRtl = rtl ?? _hasArabic(text);

    return pw.Directionality(
      textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      child: pw.Text(
        text,
        textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          font: bold ? fontBold : font,
          fontSize: fontSize,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  static pw.Widget _headerCell(String text, pw.Font font, pw.Font fontBold) {
    final isRtl = _hasArabic(text);

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      alignment: isRtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
      child: _text(
        text,
        font: font,
        fontBold: fontBold,
        bold: true,
        fontSize: 8.5,
        color: PdfColors.white,
        rtl: isRtl,
      ),
    );
  }

  static pw.Widget _cell(
    String text,
    pw.Font font,
    pw.Font fontBold, {
    bool bold = false,
    double fontSize = 8,
  }) {
    final isRtl = _hasArabic(text);

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      alignment: isRtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
      child: _text(
        text,
        font: font,
        fontBold: fontBold,
        bold: bold,
        fontSize: fontSize,
        color: PdfColor.fromHex('#1E293B'),
        rtl: isRtl,
      ),
    );
  }

  static pw.Widget _kpiCard({
    required String titleEn,
    required String titleAr,
    required String value,
    required PdfColor accentColor,
    required pw.Font font,
    required pw.Font fontBold,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0'), width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 3,
              width: 24,
              margin: const pw.EdgeInsets.only(bottom: 5),
              decoration: pw.BoxDecoration(
                color: accentColor,
                borderRadius: pw.BorderRadius.circular(2),
              ),
            ),
            _text(
              '$titleEn  •  $titleAr',
              font: font,
              fontBold: fontBold,
              fontSize: 7.5,
              color: PdfColor.fromHex('#64748B'),
            ),
            pw.SizedBox(height: 3),
            _text(
              value,
              font: font,
              fontBold: fontBold,
              fontSize: 10.5,
              bold: true,
              color: PdfColor.fromHex('#0F172A'),
            ),
          ],
        ),
      ),
    );
  }
}
