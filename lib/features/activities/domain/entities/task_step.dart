class TaskStep {
  const TaskStep({
    required this.id,
    required this.label,
    required this.order,
    this.completed = false,
  });

  final String id;
  final String label;
  final int order;
  final bool completed;

  TaskStep copyWith({
    String? id,
    String? label,
    int? order,
    bool? completed,
  }) {
    return TaskStep(
      id: id ?? this.id,
      label: label ?? this.label,
      order: order ?? this.order,
      completed: completed ?? this.completed,
    );
  }
}
