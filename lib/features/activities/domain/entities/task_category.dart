enum TaskCategory {
  health,
  social,
  exercise,
  chores,
}

extension TaskCategoryLabel on TaskCategory {
  String get labelPt => switch (this) {
        TaskCategory.health => 'Saúde',
        TaskCategory.social => 'Social',
        TaskCategory.exercise => 'Exercício',
        TaskCategory.chores => 'Outros',
      };
}
