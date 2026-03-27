abstract final class CompletionFeedbackMessages {
  CompletionFeedbackMessages._();

  static const List<String> messages = [
    'Atividade concluída!',
    'Registro salvo! Esta atividade consta como concluída.',
    'Concluído! A atividade foi enviada ao histórico.',
    'Esta atividade foi finalizada e registrada!',
    'A conclusão foi salva! Você pode consultar no histórico.',
  ];

  static String forHistoryIndex(int index) =>
      messages[index % messages.length];
}
