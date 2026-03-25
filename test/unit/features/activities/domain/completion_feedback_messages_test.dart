import 'package:fiap_hackathon/features/activities/domain/services/completion_feedback_messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CompletionFeedbackMessages', () {
    test('forHistoryIndex é cíclico sobre a lista de mensagens', () {
      final len = CompletionFeedbackMessages.messages.length;
      expect(
        CompletionFeedbackMessages.forHistoryIndex(0),
        CompletionFeedbackMessages.messages[0],
      );
      expect(
        CompletionFeedbackMessages.forHistoryIndex(len),
        CompletionFeedbackMessages.messages[0],
      );
      expect(
        CompletionFeedbackMessages.forHistoryIndex(len + 1),
        CompletionFeedbackMessages.messages[1],
      );
    });
  });
}
