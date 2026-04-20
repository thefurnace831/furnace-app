import 'dart:convert';

import 'package:http/http.dart' as http;

class GoogleSheetsSync {
  static const String _webhookUrl =
      String.fromEnvironment('SHEETS_WEBHOOK_URL', defaultValue: '');
  static const String _webhookSecret =
      String.fromEnvironment('SHEETS_WEBHOOK_SECRET', defaultValue: '');

  static bool get isEnabled => _webhookUrl.isNotEmpty;

  static Future<void> sendEvent({
    required String eventType,
    required Map<String, dynamic> data,
  }) async {
    if (!isEnabled) return;

    final payload = {
      'eventType': eventType,
      'sentAt': DateTime.now().toUtc().toIso8601String(),
      'secret': _webhookSecret,
      'data': data,
    };

    try {
      await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // Keep check-in flow uninterrupted if sheet sync fails.
    }
  }
}
