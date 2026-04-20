const SHEET_NAME = 'CheckIns';
const SECRET = 'replace-with-your-secret';

function doPost(e) {
  try {
    const body = JSON.parse((e && e.postData && e.postData.contents) || '{}');
    const payloadSecret = body.secret || '';

    if (SECRET && payloadSecret !== SECRET) {
      return jsonResponse({ ok: false, error: 'unauthorized' }, 401);
    }

    const data = body.data || {};
    const row = [
      new Date(),
      body.eventType || '',
      body.sentAt || '',
      data.eventTime || '',
      data.email || '',
      data.fullName || '',
      data.studentId || '',
      data.phoneNumber || '',
      data.ethnicity || '',
      data.schoolName || '',
      data.gender || '',
      data.birthday || '',
      data.ecFirstName || '',
      data.ecLastName || '',
      data.ecRelation || '',
      data.ecPhone || '',
      data.roomId || '',
      data.roomName || '',
      data.qrRoomValue || '',
      data.qrCheckoutValue || '',
      data.scannedCode || '',
      data.checkInTime || '',
      data.checkOutTime || '',
      data.totalTime || '',
    ];

    const ss = SpreadsheetApp.getActiveSpreadsheet();
    const sheet = ss.getSheetByName(SHEET_NAME) || ss.insertSheet(SHEET_NAME);

    if (sheet.getLastRow() === 0) {
      sheet.appendRow([
        'receivedAt',
        'eventType',
        'sentAt',
        'eventTime',
        'email',
        'fullName',
        'studentId',
        'phoneNumber',
        'ethnicity',
        'schoolName',
        'gender',
        'birthday',
        'ecFirstName',
        'ecLastName',
        'ecRelation',
        'ecPhone',
        'roomId',
        'roomName',
        'qrRoomValue',
        'qrCheckoutValue',
        'scannedCode',
        'checkInTime',
        'checkOutTime',
        'totalTime',
      ]);
    }

    sheet.appendRow(row);
    return jsonResponse({ ok: true });
  } catch (err) {
    return jsonResponse({ ok: false, error: String(err) }, 500);
  }
}

function jsonResponse(payload) {
  return ContentService.createTextOutput(JSON.stringify(payload)).setMimeType(
    ContentService.MimeType.JSON
  );
}
