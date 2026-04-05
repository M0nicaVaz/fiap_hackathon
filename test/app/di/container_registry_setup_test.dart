import 'package:fiap_hackathon/app/di/container_registry.dart';
import 'package:fiap_hackathon/features/accessibility_preferences/presentation/providers/accessibility_preferences_controller.dart';
import 'package:fiap_hackathon/features/activities/presentation/providers/tasks_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'accessibility_font_scale': 1.4,
      'accessibility_spacing_scale': 1.2,
      'accessibility_is_basic_mode': true,
    });
    await ContainerRegistry.reset();
  });

  test('setup should resolve feature controllers', () async {
    final preferences = await SharedPreferences.getInstance();

    await ContainerRegistry.setup(preferences: preferences);

    final accessibilityController =
        ContainerRegistry.get<AccessibilityPreferencesController>();
    final tasksController = ContainerRegistry.get<TasksController>();

    expect(accessibilityController.fontScale, 1.4);
    expect(accessibilityController.spacingScale, 1.2);
    expect(accessibilityController.isBasicMode, isTrue);
    expect(tasksController.tasks, isEmpty);
  });
}
