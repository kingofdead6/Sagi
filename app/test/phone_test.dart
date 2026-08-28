import 'package:flutter_test/flutter_test.dart';
import 'package:saji/core/phone.dart';

void main() {
  group('Phone', () {
    test('accepts every Algerian mobile prefix', () {
      for (final number in ['0550123456', '0660123456', '0770123456']) {
        expect(Phone.isValid(number), isTrue, reason: number);
      }
    });

    test('rejects landlines, short numbers and other countries', () {
      for (final number in ['0380123456', '077012345', '+33612345678', 'abc', '', null]) {
        expect(Phone.isValid(number), isFalse, reason: '$number');
      }
    });

    test('normalises every accepted form to E.164', () {
      expect(Phone.normalize('0770123456'), '+213770123456');
      expect(Phone.normalize('+213770123456'), '+213770123456');
      expect(Phone.normalize('213770123456'), '+213770123456');
      expect(Phone.normalize('0770 12 34 56'), '+213770123456');
      expect(Phone.normalize('077-012-3456'), '+213770123456');
      expect(Phone.normalize('(0770) 12.34.56'), '+213770123456');
    });

    test('returns null rather than throwing on invalid input', () {
      expect(Phone.normalize('123'), isNull);
      expect(Phone.normalize(null), isNull);
    });

    test('converts back to the local form for display', () {
      expect(Phone.toLocal('+213770123456'), '0770123456');
      expect(Phone.toLocal(null), '');
    });

    test('groups digits for display', () {
      expect(Phone.pretty('+213770123456'), '0770 12 34 56');
    });

    test('builds a tel: URI', () {
      expect(Phone.dialUri('0770123456').toString(), 'tel:+213770123456');
    });
  });
}
