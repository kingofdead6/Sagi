import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Triggers a real browser download of the CSV the API returned.
Future<bool> downloadCsv(String csv, String filename) async {
  try {
    // The BOM keeps Excel from mangling the Arabic columns.
    final blob = web.Blob(
      ['﻿$csv'.toJS].toJS,
      web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(blob);

    web.document.body!.appendChild(
      web.HTMLAnchorElement()
        ..href = url
        ..download = filename
        ..style.display = 'none'
        ..click(),
    );

    web.URL.revokeObjectURL(url);
    return true;
  } catch (_) {
    return false;
  }
}
