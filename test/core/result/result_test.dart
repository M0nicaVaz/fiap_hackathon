import 'package:fiap_hackathon/core/errors/failure.dart';
import 'package:fiap_hackathon/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success should fold with success branch', () {
      const result = Success<int>(10);

      final mapped = result.fold(
        onSuccess: (value) => value * 2,
        onFailure: (_) => 0,
      );

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(mapped, 20);
    });

    test('FailureResult should fold with failure branch', () {
      const result = FailureResult<int>(ValidationFailure());

      final mapped = result.fold(
        onSuccess: (_) => 1,
        onFailure: (failure) => failure is ValidationFailure ? 2 : 0,
      );

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(mapped, 2);
    });
  });
}
