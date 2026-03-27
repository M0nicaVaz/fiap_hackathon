import 'package:fiap_hackathon/core/formatting/app_date_formats.dart';
import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_icon_button/ds_icon_button.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:fiap_hackathon/features/activities/presentation/widgets/task_category_icons.dart';
import 'package:fiap_hackathon/features/activities/domain/entities/task_step.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
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
    if (_reminderDate == null || _reminderTime == null) return null;
    return DateTime(
      _reminderDate!.year,
      _reminderDate!.month,
      _reminderDate!.day,
      _reminderTime!.hour,
      _reminderTime!.minute,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final stepLabels = _stepControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final reminder = _combinedReminder;

    final controller = context.read<TasksController>();

    if (_isEditing) {
      final original = widget.initialTask!;
      final steps = <TaskStep>[];
      for (var i = 0; i < stepLabels.length; i++) {
        final label = stepLabels[i];
        final existing =
            i < original.steps.length ? original.steps[i] : null;
        steps.add(
          TaskStep(
            id: existing?.id ?? '${original.id}_step_$i',
            label: label,
            order: i,
            completed: existing?.completed ?? false,
          ),
        );
      }
      final updated = original.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
        steps: steps,
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

  InputDecoration _stadiumField(AppDesignSystem ds, String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: ds.typography.bodyLarge.copyWith(color: ds.colors.textSecondary),
      filled: true,
      fillColor: ds.colors.surface,
      prefixIcon: prefix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: ds.colors.primary, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ds.spacing.lg,
        vertical: ds.spacing.md,
      ),
    );
  }

  InputDecoration _notesDecoration(AppDesignSystem ds) {
    return InputDecoration(
      hintText: 'Inclua detalhes ou lembretes aqui…',
      hintStyle: ds.typography.bodyLarge.copyWith(color: ds.colors.textSecondary),
      filled: true,
      fillColor: ds.colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: ds.colors.primary, width: 2),
      ),
      contentPadding: EdgeInsets.all(ds.spacing.lg),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final title = _isEditing ? 'Editar atividade' : 'Nova atividade';

    return Scaffold(
      backgroundColor: ds.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ds.spacing.md,
                vertical: ds.spacing.sm,
              ),
              child: Row(
                children: [
                  Material(
                    color: ds.colors.feedbackInfoLight,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(Icons.arrow_back, color: ds.colors.primary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: ds.typography.headingMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: ds.colors.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person_outline, color: ds.colors.primary),
                  ),
                ],
              ),
            ),
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
                              _EditorHeroHeader(ds: ds, isEditing: _isEditing),
                              SizedBox(height: ds.spacing.xl),
                              Text(
                                'O que precisa ser feito?',
                                style: ds.typography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: ds.spacing.sm),
                              TextFormField(
                                controller: _titleController,
                                style: ds.typography.bodyLarge.copyWith(
                                  color: ds.colors.textPrimary,
                                ),
                                decoration: _stadiumField(
                                  ds,
                                  'Ex.: caminhada matinal ou tomar medicação',
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Informe um título curto e claro.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: ds.spacing.xl),
                              Text(
                                'Categoria',
                                style: ds.typography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: ds.spacing.md),
                              _CategorySelector(
                                value: _category,
                                onChanged: (v) => setState(() => _category = v),
                              ),
                              SizedBox(height: ds.spacing.xl),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final twoCol = constraints.maxWidth >= 480;
                                  final dateField = Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Quando?',
                                        style: ds.typography.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: ds.spacing.sm),
                                      InkWell(
                                        onTap: _pickDate,
                                        borderRadius: BorderRadius.circular(999),
                                        child: InputDecorator(
                                          isEmpty: _reminderDate == null,
                                          decoration: _stadiumField(
                                            ds,
                                            _placeholderDate,
                                            prefix: Icon(
                                              Icons.calendar_today_outlined,
                                              color: ds.colors.primary,
                                              size: ds.icons.md,
                                            ),
                                          ),
                                          child: Text(
                                            _reminderDate != null
                                                ? AppDateFormats.date(_reminderDate!)
                                                : '',
                                            style: ds.typography.bodyLarge.copyWith(
                                              color: ds.colors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                  final timeField = Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Em que horário?',
                                        style: ds.typography.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: ds.spacing.sm),
                                      InkWell(
                                        onTap: _pickTime,
                                        borderRadius: BorderRadius.circular(999),
                                        child: InputDecorator(
                                          isEmpty: _reminderTime == null,
                                          decoration: _stadiumField(
                                            ds,
                                            _placeholderTime,
                                            prefix: Icon(
                                              Icons.schedule,
                                              color: ds.colors.primary,
                                              size: ds.icons.md,
                                            ),
                                          ),
                                          child: Text(
                                            _reminderTime != null
                                                ? AppDateFormats.time(
                                                    DateTime(
                                                      2000,
                                                      1,
                                                      1,
                                                      _reminderTime!.hour,
                                                      _reminderTime!.minute,
                                                    ),
                                                  )
                                                : '',
                                            style: ds.typography.bodyLarge.copyWith(
                                              color: ds.colors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                  if (twoCol) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: dateField),
                                        SizedBox(width: ds.spacing.md),
                                        Expanded(child: timeField),
                                      ],
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      dateField,
                                      SizedBox(height: ds.spacing.lg),
                                      timeField,
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: ds.spacing.xl),
                              Text(
                                'Observações (opcional)',
                                style: ds.typography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: ds.spacing.sm),
                              TextFormField(
                                controller: _descriptionController,
                                minLines: 3,
                                maxLines: 6,
                                style: ds.typography.bodyLarge.copyWith(
                                  color: ds.colors.textPrimary,
                                ),
                                decoration: _notesDecoration(ds),
                              ),
                              SizedBox(height: ds.spacing.lg),
                              InkWell(
                                onTap: () => setState(() => _stepsExpanded = !_stepsExpanded),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: ds.spacing.sm),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Etapas do guia (opcional)',
                                              style: ds.typography.bodyLarge.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              'Cada etapa aparece no assistente, uma de cada vez.',
                                              style: ds.typography.bodyMedium.copyWith(
                                                color: ds.colors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        _stepsExpanded ? Icons.expand_less : Icons.expand_more,
                                        color: ds.colors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_stepsExpanded) ...[
                                SizedBox(height: ds.spacing.md),
                                ...List.generate(_stepControllers.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: ds.spacing.sm),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _stepControllers[index],
                                            style: ds.typography.bodyLarge.copyWith(
                                              color: ds.colors.textPrimary,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Etapa ${index + 1}',
                                              filled: true,
                                              fillColor: ds.colors.surface,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: ds.spacing.sm),
                                        DSIconButton(
                                          tooltip: 'Remover',
                                          icon: Icons.remove_circle_outline,
                                          iconColor: ds.colors.feedbackDanger,
                                          onPressed: () {
                                            setState(() {
                                              _stepControllers.removeAt(index).dispose();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                DSButton(
                                  label: 'Adicionar etapa',
                                  icon: Icons.add,
                                  variant: DSButtonVariant.secondary,
                                  fullWidth: true,
                                  onPressed: () {
                                    setState(() {
                                      _stepControllers.add(TextEditingController());
                                      _stepsExpanded = true;
                                    });
                                  },
                                ),
                              ],
                              SizedBox(height: ds.spacing.xxl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Material(
              elevation: 8,
              color: ds.colors.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.all(ds.spacing.lg),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final row = c.maxWidth >= 400;
                      const footerActionHeight = 52.0;
                      final footerPadding = EdgeInsets.symmetric(
                        horizontal: ds.spacing.md,
                      );
                      final footerShape = RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      );
                      final cancel = OutlinedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(row ? 0 : double.infinity, footerActionHeight),
                          maximumSize: Size(double.infinity, footerActionHeight),
                          padding: footerPadding,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                          shape: footerShape,
                          side: BorderSide(color: ds.colors.disabled.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          'Cancelar',
                          style: ds.typography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                      final save = FilledButton.icon(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          minimumSize: Size(row ? 0 : double.infinity, footerActionHeight),
                          maximumSize: Size(double.infinity, footerActionHeight),
                          padding: footerPadding,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                          backgroundColor: ds.colors.primary,
                          foregroundColor: ds.colors.primaryInverse,
                          shape: footerShape,
                        ),
                        icon: Icon(Icons.check_circle_outline, size: ds.icons.md),
                        label: Text(
                          'Salvar',
                          style: ds.typography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: ds.colors.primaryInverse,
                          ),
                        ),
                      );
                      if (row) {
                        return Row(
                          children: [
                            Expanded(child: cancel),
                            SizedBox(width: ds.spacing.md),
                            Expanded(child: save),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          save,
                          SizedBox(height: ds.spacing.sm),
                          cancel,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorHeroHeader extends StatelessWidget {
  const _EditorHeroHeader({required this.ds, required this.isEditing});

  final AppDesignSystem ds;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ds.spacing.xl),
      decoration: BoxDecoration(
        color: ds.colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ds.colors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ds.spacing.md),
            decoration: BoxDecoration(
              color: ds.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_task, color: ds.colors.primaryInverse, size: ds.icons.lg),
          ),
          SizedBox(width: ds.spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Editar atividade' : 'Criar nova atividade',
                  style: ds.typography.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: ds.spacing.xs),
                Text(
                  'Inclua uma nova atividade na sua rotina no SeniorEase.',
                  style: ds.typography.bodyLarge.copyWith(
                    color: ds.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const double _kCategoryCardMinWidth = 104;

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.value,
    required this.onChanged,
  });

  final TaskCategory value;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final cats = TaskCategory.values;
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 520;
        if (wide) {
          final spacing = ds.spacing.sm;
          final maxW = c.maxWidth;
          final fontScale = ds.scale.fontScale;
          final minCard =
              (_kCategoryCardMinWidth * fontScale).clamp(72.0, 640.0);
          final rawCols = ((maxW + spacing) / (minCard + spacing)).floor();
          final cols = rawCols.clamp(1, cats.length);
          final cardWidth = (maxW - (cols - 1) * spacing) / cols;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.start,
            children: cats
                .map(
                  (cat) => SizedBox(
                    width: cardWidth,
                    child: _CategoryTile(
                      category: cat,
                      selected: value == cat,
                      onTap: () => onChanged(cat),
                    ),
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: cats.map((cat) {
            return Padding(
              padding: EdgeInsets.only(bottom: ds.spacing.sm),
              child: _CategoryTile(
                category: cat,
                selected: value == cat,
                onTap: () => onChanged(cat),
                stadium: true,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
    this.stadium = false,
  });

  final TaskCategory category;
  final bool selected;
  final VoidCallback onTap;
  final bool stadium;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final borderColor = selected ? ds.colors.primary : ds.colors.disabled.withValues(alpha: 0.4);
    final fg = selected ? ds.colors.primary : ds.colors.textPrimary;
    final iconColor = selected ? ds.colors.primary : ds.colors.textSecondary;
    return Material(
      color: ds.colors.surface,
      borderRadius: BorderRadius.circular(stadium ? 999 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(stadium ? 999 : 16),
        child: Container(
          width: stadium ? null : double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ds.spacing.md,
            vertical: stadium ? ds.spacing.md : ds.spacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(stadium ? 999 : 16),
            border: Border.all(color: borderColor, width: selected ? 2.5 : 1.5),
          ),
          child: stadium
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(taskCategoryIcon(category), color: iconColor, size: ds.icons.lg),
                    SizedBox(width: ds.spacing.md),
                    Text(
                      category.labelPt,
                      style: ds.typography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(taskCategoryIcon(category), color: iconColor, size: ds.icons.lg * 1.1),
                    SizedBox(height: ds.spacing.sm),
                    Text(
                      category.labelPt,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      textWidthBasis: TextWidthBasis.parent,
                      style: ds.typography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
