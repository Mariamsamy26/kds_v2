import 'dart:io';
import 'package:flutter/foundation.dart';
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
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (pw.Context context) => [
          // Header Title
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'KDS History Report',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                ),
                pw.Text(
                  'تقرير سجل الطلبات',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // Summary Metrics Cards
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Total Completed', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 2),
                    pw.Text('${metrics.totalCompleted}', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Cancelled', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 2),
                    pw.Text('${metrics.cancelledCount}', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Avg Prep Time', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 2),
                    pw.Text('${metrics.avgPrepTimeMinutes} min', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Late Rate', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    pw.SizedBox(height: 2),
                    pw.Text('${metrics.lateRatePercentage}%', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),

          // Orders List Table
          pw.TableHelper.fromTextArray(
            headers: ['Order #', 'Customer', 'Type', 'Time', 'Duration', 'Items'],
            data: orders.map((order) {
              final itemsSummary = order.items.map((i) => '${i.quantity}x ${i.nameEn}').join(', ');
              final typeStr = order.type == OrderType.dineIn
                  ? 'Dine In'
                  : order.type == OrderType.takeaway
                      ? 'Takeaway'
                      : 'Delivery';
              return [
                '#${order.orderNumber}',
                order.customerName,
                typeStr,
                order.pickupTime,
                order.durationMinutes,
                itemsSummary,
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue700),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final filename = 'KDS_History_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    try {
      if (kIsWeb) {
        await Printing.sharePdf(bytes: bytes, filename: filename);
        return filename;
      } else {
        Directory? outputDir;
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          outputDir = await getDownloadsDirectory();
        }
        outputDir ??= await getApplicationDocumentsDirectory();

        final file = File('${outputDir.path}/$filename');
        await file.writeAsBytes(bytes);
        await Printing.sharePdf(bytes: bytes, filename: filename);
        return file.path;
      }
    } catch (e) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
      return filename;
    }
  }
}
