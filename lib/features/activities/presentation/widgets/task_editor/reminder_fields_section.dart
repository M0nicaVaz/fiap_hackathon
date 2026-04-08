import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/formatting/app_date_formats.dart';
import 'package:fiap_hackathon/features/activities/presentation/helpers/task_editor_input_decorations.dart';
import 'package:flutter/material.dart';

class ReminderFieldsSection extends StatelessWidget {
  const ReminderFieldsSection({
    super.key,
    required this.reminderDate,
    required this.reminderTime,
    required this.onPickDate,
    required this.onPickTime,
    required this.placeholderDate,
    required this.placeholderTime,
  });

  final DateTime? reminderDate;
  final TimeOfDay? reminderTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final String placeholderDate;
  final String placeholderTime;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTwoColumns = constraints.maxWidth >= 480;
        final dateField = _ReminderField(
          title: 'Quando?',
          onTap: onPickDate,
          isEmpty: reminderDate == null,
          decoration: buildTaskEditorStadiumFieldDecoration(
            ds,
            placeholderDate,
            prefix: Icon(
              Icons.calendar_today_outlined,
              color: ds.colors.primary,
              size: ds.icons.md,
            ),
          ),
          value: reminderDate != null
              ? AppDateFormats.date(reminderDate!)
              : '',
        );
        final timeField = _ReminderField(
          title: 'Em que horário?',
          onTap: onPickTime,
          isEmpty: reminderTime == null,
          decoration: buildTaskEditorStadiumFieldDecoration(
            ds,
            placeholderTime,
            prefix: Icon(
              Icons.schedule,
              color: ds.colors.primary,
              size: ds.icons.md,
            ),
          ),
          value: reminderTime != null
              ? AppDateFormats.time(
                  DateTime(
                    2000,
                    1,
                    1,
                    reminderTime!.hour,
                    reminderTime!.minute,
                  ),
                )
              : '',
        );
        if (isTwoColumns) {
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
    );
  }
}

class _ReminderField extends StatelessWidget {
  const _ReminderField({
    required this.title,
    required this.onTap,
    required this.isEmpty,
    required this.decoration,
    required this.value,
  });

  final String title;
  final VoidCallback onTap;
  final bool isEmpty;
  final InputDecoration decoration;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: ds.typography.bodyLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: ds.spacing.sm),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: InputDecorator(
            isEmpty: isEmpty,
            decoration: decoration,
            child: Text(
              value,
              style: ds.typography.bodyLarge.copyWith(
                color: ds.colors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
