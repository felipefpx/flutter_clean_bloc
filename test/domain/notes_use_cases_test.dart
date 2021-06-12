import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_bloc/domain/use_cases/notes_use_cases.dart';

void main() {
  group('With notes info', () {
    test('when title is not empty, should be valid', () {
      expect('test'.isValidTitle, isTrue);
    });

    test('when title is empty, should be invalid', () {
      expect(''.isValidTitle, isFalse);
    });

    test('when content is not empty, should be valid', () {
      expect('test'.isValidContent, isTrue);
    });

    test('when content is empty, should be invalid', () {
      expect(''.isValidContent, isFalse);
    });
  });
}
