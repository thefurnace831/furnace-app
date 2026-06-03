import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QrButtons extends StatelessWidget {
  final String qrRoomValue;
  final String roomName;
  const QrButtons(
      {super.key, required this.qrRoomValue, required this.roomName});

  // Export PDF
  Future<void> _exportPDf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Room: $roomName'),
                pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  data: qrRoomValue,
                  barcode: pw.Barcode.qrCode(),
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          );
        }));
    // Save to pdf file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${roomName.replaceAll(' ', '_')}_QR.pdf");
    await file.writeAsBytes(await pdf.save());

    // Share the file via the native iOS/Android share sheet
    // Check if widget still active on screen
    if (context.mounted) {
      final params = ShareParams(
        text: 'Export $roomName QR Code',
        files: [XFile(file.path)],
      );
      await SharePlus.instance.share(params);
    }
  }

  // Copy Image
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'qrRoomValue'));
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final buttonColor = FurnaceColors.ember;
    final buttonStyle = ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: buttonStyle,
          onPressed: () => _exportPDf(context),
          child: Text('Export QR Code'),
        ),
        TextButton(
            style: buttonStyle,
            onPressed: () => _copyToClipboard(context),
            child: Text('Copy QR Image'))
      ],
    );
  }
}
