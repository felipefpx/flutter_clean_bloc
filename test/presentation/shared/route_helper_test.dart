import 'package:flutter_clean_bloc/presentation/shared/route_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('When creating app deep link', () {
    test('should create without schema by default', () {
      expect(
        appDeepLink('test/test'),
        'clean_bloc/test/test',
      );
    });

    test('should create without schema', () {
      expect(
        appDeepLink('test/test', includeSchema: false),
        'clean_bloc/test/test',
      );
    });

    test('should create with schema', () {
      expect(
        appDeepLink('test/test', includeSchema: true),
        'app://clean_bloc/test/test',
      );
    });
  });
}
