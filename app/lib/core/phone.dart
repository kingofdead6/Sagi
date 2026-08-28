/// Phone is the identity in Saji: Algerian mobiles only,
/// local `0[5-7]XXXXXXXX` normalised to E.164 `+213…`.
abstract final class Phone {
  static final _local = RegExp(r'^0[5-7]\d{8}$');
  static final _e164 = RegExp(r'^\+213[5-7]\d{8}$');
  static final _bare = RegExp(r'^213[5-7]\d{8}$');
  static final _separators = RegExp(r'[\s\-().]');

  static String _clean(String input) => input.replaceAll(_separators, '');

  static bool isValid(String? input) {
    if (input == null || input.isEmpty) return false;
    final cleaned = _clean(input);
    return _local.hasMatch(cleaned) || _e164.hasMatch(cleaned) || _bare.hasMatch(cleaned);
  }

  /// Normalises any accepted form to E.164, or returns null when invalid.
  static String? normalize(String? input) {
    if (input == null) return null;
    final cleaned = _clean(input);
    if (_e164.hasMatch(cleaned)) return cleaned;
    if (_bare.hasMatch(cleaned)) return '+$cleaned';
    if (_local.hasMatch(cleaned)) return '+213${cleaned.substring(1)}';
    return null;
  }

  /// E.164 back to the local `0…` form Algerians actually read.
  static String toLocal(String? e164) {
    if (e164 == null || e164.isEmpty) return '';
    if (_e164.hasMatch(e164)) return '0${e164.substring(4)}';
    return e164;
  }

  /// "0770 12 34 56" — grouped for display only.
  static String pretty(String? phone) {
    final local = toLocal(phone);
    if (local.length != 10) return local;
    return '${local.substring(0, 4)} ${local.substring(4, 6)} '
        '${local.substring(6, 8)} ${local.substring(8)}';
  }

  /// A `tel:` URI for one-tap calling.
  static Uri dialUri(String phone) => Uri(scheme: 'tel', path: normalize(phone) ?? phone);
}
