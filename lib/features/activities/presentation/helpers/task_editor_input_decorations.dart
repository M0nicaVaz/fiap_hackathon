import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/material.dart';

InputDecoration buildTaskEditorStadiumFieldDecoration(
  AppDesignSystem ds,
  String hint, {
  Widget? prefix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: ds.typography.bodyLarge.copyWith(
      color: ds.colors.textSecondary,
    ),
    filled: true,
    fillColor: ds.colors.surface,
    prefixIcon: prefix,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(
        color: ds.colors.disabled.withValues(alpha: 0.35),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(
        color: ds.colors.disabled.withValues(alpha: 0.35),
      ),
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

InputDecoration buildTaskEditorNotesDecoration(AppDesignSystem ds) {
  return InputDecoration(
    hintText: 'Inclua detalhes ou lembretes aqui…',
    hintStyle: ds.typography.bodyLarge.copyWith(
      color: ds.colors.textSecondary,
    ),
    filled: true,
    fillColor: ds.colors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: ds.colors.disabled.withValues(alpha: 0.35),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: ds.colors.disabled.withValues(alpha: 0.35),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: ds.colors.primary, width: 2),
    ),
    contentPadding: EdgeInsets.all(ds.spacing.lg),
  );
}
