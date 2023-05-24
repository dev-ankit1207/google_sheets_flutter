import 'package:gsheets/gsheets.dart';
import 'package:invoice_maker/models/save_data.dart';

class GSheetsServices {
  static const _credential = r'''
{
  "type": "service_account",
  "project_id": "flutter-data-350717",
  "private_key_id": "f853047c548456ad7f580dd5c04ee8d821a6e0d9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDBYfOLg/KgtfOL\nWCqTxqFNxsOnji1n5oTbDjNAUy8X9rEd8/NqAJliAmkZZvgH282ANOZ3279ImhAL\n/oPRmGP0Xkg3uSYboCIpEZICErhosSA8J5RpAALBaDQBv/6D0+H43TwcPIBYpFmk\nY+xZe7f3fd9CivkN9lZeUyFjuItmMkipaysnHzStfhb1to6E8gPaikjnimLO7ZxH\nlARMwzunA+r3CDOobT6TiYl0foYhqiyfU+1ovE4w/TR/1EPGOrZ9dJM8Y2u/ynWk\nJ6FO3HyHMB+GytuvoGyDjFny+qylgYq1mKMgKwzfssBqOsliihUgG3T9/M4UpYBL\ne1FIJST3AgMBAAECggEADb/cz271QaSjiU/JJIf7O2AbfylRDyceYRjUX17Kurse\ngruv8znRrgdFLmTaKReMDUaK8GYJEVdq4VTE+JJg4PoRy8HNSio2OOdNPfp+GWt7\n7ZWpgVcFMHfWjXKiMlX5UMwiFFE06u3cix9Tqapt58SPqtfeDLZsE6Qje/Hzb15E\nwu8N4qS027JVW/YBToiLTDYLeiuMRHOBUUAbneLcptfpJoNIEGTtHSdTV1f+5MpJ\nQ9zbmFOLSkXcuhxG1k6QsTHvQWpq9Hdm6tWOiicM5Pm+FHPrtfcN4Ytxx2+3mx1P\nwhyZtTrSEUUGH2P7t/JPGEBlg967QpK3GpKs0Be4iQKBgQD1nKYij+1tEoWfwxeu\nOLkvuMOdqxVhEvLmoUtVP7L3amGLJNGj3bF8Qs5PzMH38Qv9gkmS3wL00ombVyaf\n6TvQVpZadN3NTBuUHmls7Yyw/oBQCXnCnjnkbMa+X2bDfEIGzCw+bAZqWfIJdzWo\nJ28EB4YembIzU/IU+eh7MyUeOwKBgQDJj8rUmQemb7RNBk0OdDnmbARmxQkQKkYZ\nbuZZaz2B1xyYydtd8WSiNTzIOSSdv+PvmFrL8QCzNIY5CNTZ+7ivs5toqtyIAZvn\n3TejGWsY8T0FOl0e5diq9gKSpWyXDdZ6VD4pmRoktLiZQljQqB9i7NfA/xj39+qd\nVZ1YW0G8dQKBgQDopg+AYZDmZksIgAXoU3amy38P1ESWBRrsdxAimgnt7mijIqcp\nbw91wtomILADKeLPqSAD7RahzOPnru+5PXYY7EvTNyv6EQN2lDAMrB8+cHQeXDtn\nq/TueFLxdPCkbwkj4zZtkmmpR7XKXY8HzwKLcI0MY0227Oc8E1Sxjkq0jQKBgQDB\n6a6PPfJYMxtZBvjXMQYLIlxRqrn/bUwnZ8QAvuVbpuICNCDxjizsyR8C2cbaZSQa\n+45OqjusLJn9APwWAtA5aSfYWJj11+Zv+SlvpiKcymmUQAQal7INN8Rd5PxFjrCK\n28U6K+s06RC3kVb01unrOESRjlotJbv3Rcismo7xiQKBgFI/++XehJCMhYJg8nQf\nkQqiDqhMLXwUC2U3dZC87YWgJ1foek6yKAdADwJK+ycbkcbqLjUwVuuL6+L6R7+V\neZGUvGR1LJd+CYgRfRoNZoSE/yvVJ7gvJ8Os0JH7ycFH4JaT5EaqsAnJSGaX/wN5\ngJM002vE9cSyKlOPi8Oy5n6J\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-data@flutter-data-350717.iam.gserviceaccount.com",
  "client_id": "114815455159096172668",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-data%40flutter-data-350717.iam.gserviceaccount.com"
}
''';

  static late Worksheet _worksheet;

  static final GSheets _gSheets = GSheets(_credential);

  static Future<void> initializeForWorksheet(String spreadsheetId, String worksheetTitle) async {
    Spreadsheet excel = await _gSheets.spreadsheet(spreadsheetId);
    _worksheet = excel.worksheetByTitle(worksheetTitle)!;
  }

  static Future<List<SaveData>> getEntries() async {
    /// skips the first value which is the header
    final values = (await _worksheet.values.allRows()).skip(1).toList();
    return values.map((value) => SaveData.fromSheets(value)).toList().reversed.toList();
  }

  static Future<bool> deleteEntry(int index) {
    /// We add one to the index so that we can:
    /// 1. Start at index 1
    /// 2. Skip the first row
    return _worksheet.deleteRow(index + 2);
  }

  static Future<bool> addEntry({required SaveData saveData}) async {
    return await _worksheet.values.appendRow([
      saveData.firstName,
      saveData.lastName,
      saveData.userName,
      saveData.age,
      saveData.gender,
    ]);
  }
}
