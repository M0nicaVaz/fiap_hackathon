import 'task_category.dart';
import 'task_status.dart';
import 'task_step.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.steps,
    required this.status,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
    this.category = TaskCategory.health,
  });

  final String id;
  final String title;
  final String? description;
  final List<TaskStep> steps;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime? reminderAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool get hasSteps => steps.isNotEmpty;
  int get completedStepsCount => steps.where((s) => s.completed).length;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskStep>? steps,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? reminderAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      status: status ?? this.status,
      category: category ?? this.category,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
