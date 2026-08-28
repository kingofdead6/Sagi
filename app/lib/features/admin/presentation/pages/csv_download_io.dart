import 'package:flutter/services.dart';

/// Off the web there is no browser download, so the CSV goes to the clipboard —
/// enough to paste into a sheet from a desktop or tablet build.
Future<bool> downloadCsv(String csv, String filename) async {
  await Clipboard.setData(ClipboardData(text: csv));
  return true;
}
