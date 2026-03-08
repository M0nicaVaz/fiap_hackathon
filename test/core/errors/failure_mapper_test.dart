import 'package:fiap_hackathon/core/errors/failure.dart';
import 'package:fiap_hackathon/core/errors/failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureMapper', () {
    test('should map unknown exception to UnknownFailure', () {
      final failure = FailureMapper.fromException(Exception('boom'));

      expect(failure, isA<UnknownFailure>());
    });

    test('should return default user message for validation failure', () {
      const failure = ValidationFailure();

      final message = FailureMapper.toUserMessage(failure);

      expect(message, contains('Dados invalidos'));
    });

    test('should preserve custom message when provided', () {
      const failure = AuthFailure(message: 'Erro customizado');

      final message = FailureMapper.toUserMessage(failure);

      expect(message, 'Erro customizado');
    });
  });
}
