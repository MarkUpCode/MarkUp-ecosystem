import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_movil_dinerop/features/dolarito/models/dolarito_mood.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all Dolarito moods have a bundled image asset', () async {
    for (final mood in DolaritoMood.values) {
      final data = await rootBundle.load(
        'assets/images/dolarito/${mood.assetName}',
      );
      expect(data.lengthInBytes, greaterThan(0), reason: mood.name);
    }
  });
}
