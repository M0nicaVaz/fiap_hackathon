import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/task_editor_form_mapper.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/reminder_fields_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_category_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_editor_footer_actions.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_editor_hero_card.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_notes_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_steps_section.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_editor/task_title_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskEditorPage extends StatefulWidget {
  const TaskEditorPage({super.key, this.initialTask});
  final Task? initialTask;
  @override
  State<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  static const _placeholderDate = 'dd/mm/aaaa';
  static const _placeholderTime = '--:--';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final List<TextEditingController> _stepControllers = [];
  TaskCategory _category = TaskCategory.health;
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;
  bool _stepsExpanded = false;
  bool _isSaving = false;
  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTask;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descriptionController = TextEditingController(text: t?.description ?? '');
    if (t != null) {
      _category = t.category;
      if (t.reminderAt != null) {
        final r = t.reminderAt!;
        _reminderDate = DateTime(r.year, r.month, r.day);
        _reminderTime = TimeOfDay(hour: r.hour, minute: r.minute);
      }
      if (t.steps.isNotEmpty) {
        _stepsExpanded = true;
        for (final s in t.steps) {
          _stepControllers.add(TextEditingController(text: s.label));
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final base = _reminderDate ?? now;
    final d = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: base,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Selecionar data',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (!mounted || d == null) return;
    setState(() => _reminderDate = d);
  }

  Future<void> _pickTime() async {
    final base = _reminderTime ?? TimeOfDay.now();
    final t = await showTimePicker(
      context: context,
      initialTime: base,
      helpText: 'Selecionar horário',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (!mounted || t == null) return;
    setState(() => _reminderTime = t);
  }

  DateTime? get _combinedReminder {
    if (_reminderDate == null) return null;
    final time = _reminderTime ?? const TimeOfDay(hour: 0, minute: 0);
    return DateTime(
      _reminderDate!.year,
      _reminderDate!.month,
      _reminderDate!.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final stepLabels = normalizedTaskStepLabels(_stepControllers);
    final reminder = _combinedReminder;
    final controller = context.read<TasksController>();
    setState(() => _isSaving = true);

    try {
      if (_isEditing) {
        final original =
            controller.taskById(widget.initialTask!.id) ?? widget.initialTask!;
        final updated = original.copyWith(
          title: title,
          description: description.isEmpty ? null : description,
          steps: buildUpdatedTaskSteps(original, stepLabels),
          category: _category,
          reminderAt: reminder,
        );
        await controller.updateTask(updated);
        if (!mounted) return;
        _snack('Atividade atualizada.');
        Navigator.of(context).pop();
        return;
      }

      await controller.createTask(
        title: title,
        description: description.isEmpty ? null : description,
        stepLabels: stepLabels,
        reminderAt: reminder,
        category: _category,
      );
      if (!mounted) return;
      _snack('Atividade criada.');
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _snack(String message) {
    final ds = context.ds;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: ds.typography.bodyMedium),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Scaffold(
      backgroundColor: ds.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final maxW = c.maxWidth > 720 ? 640.0 : c.maxWidth;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: ds.spacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxW),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: ds.spacing.xl),
                              TaskEditorHeroCard(isEditing: _isEditing),
                              SizedBox(height: ds.spacing.xl),
                              TaskTitleSection(controller: _titleController),
                              SizedBox(height: ds.spacing.xl),
                              TaskCategorySection(
                                value: _category,
                                onChanged: (v) => setState(() => _category = v),
                              ),
                              SizedBox(height: ds.spacing.xl),
                              ReminderFieldsSection(
                                reminderDate: _reminderDate,
                                reminderTime: _reminderTime,
                                onPickDate: _pickDate,
                                onPickTime: _pickTime,
                                placeholderDate: _placeholderDate,
                                placeholderTime: _placeholderTime,
                              ),
                              SizedBox(height: ds.spacing.xl),
                              TaskNotesSection(
                                controller: _descriptionController,
                              ),
                              SizedBox(height: ds.spacing.lg),
                              TaskStepsSection(
                                expanded: _stepsExpanded,
                                controllers: _stepControllers,
                                onToggle: () => setState(
                                  () => _stepsExpanded = !_stepsExpanded,
                                ),
                                onAddStep: () {
                                  setState(() {
                                    _stepControllers.add(
                                      TextEditingController(),
                                    );
                                    _stepsExpanded = true;
                                  });
                                },
                                onRemoveStep: (index) {
                                  setState(() {
                                    _stepControllers.removeAt(index).dispose();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            TaskEditorFooterActions(
              onCancel: _isSaving
                  ? null
                  : () => Navigator.of(context).maybePop(),
              onSave: _isSaving ? null : _save,
              isSaving: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
