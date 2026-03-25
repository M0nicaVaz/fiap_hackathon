import 'package:fiap_hackathon/features/activities/domain/entities/task_category.dart';
import 'package:flutter/material.dart';

IconData taskCategoryIcon(TaskCategory c) => switch (c) {
      TaskCategory.health => Icons.favorite_border,
      TaskCategory.social => Icons.people_outline,
      TaskCategory.exercise => Icons.directions_run_outlined,
      TaskCategory.chores => Icons.home_outlined,
    };
