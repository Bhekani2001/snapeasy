import 'package:flutter_test/flutter_test.dart';
import 'package:snapeasy/models/card_model.dart';

bool isCardExpiringWithinYears(String expiry, int years) {
  try {
    final parts = expiry.split('/');
    if (parts.length != 2) return false;
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    final now = DateTime.now();
    final exp = DateTime(2000 + year, month);
    final future = DateTime(now.year + years, now.month);
    return exp.isBefore(future);
  } catch (_) {
    return false;
  }
}

void main() {
  group('Card Expiration', () {
    test('Card expires within 4 years', () {
      expect(isCardExpiringWithinYears('08/29', 4), true); // 2029
      expect(isCardExpiringWithinYears('08/30', 4), false); // 2030
      expect(isCardExpiringWithinYears('01/25', 4), true); // 2025
      expect(isCardExpiringWithinYears('12/35', 4), false); // 2035
    });

    test('Handles invalid expiry formats', () {
      expect(isCardExpiringWithinYears('invalid', 4), false);
      expect(isCardExpiringWithinYears('13/22', 4), false); // invalid month
      expect(isCardExpiringWithinYears('12/xx', 4), false); // invalid year
      expect(isCardExpiringWithinYears('', 4), false);
    });
  });
}
