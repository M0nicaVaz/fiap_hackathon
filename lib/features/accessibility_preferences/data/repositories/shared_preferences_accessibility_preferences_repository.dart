import '../../domain/entities/accessibility_settings.dart';
import '../../domain/repositories/accessibility_preferences_repository.dart';
import '../datasources/shared_preferences_accessibility_preferences_data_source.dart';

class SharedPreferencesAccessibilityPreferencesRepository
    implements AccessibilityPreferencesRepository {
  SharedPreferencesAccessibilityPreferencesRepository(this._dataSource);

  final SharedPreferencesAccessibilityPreferencesDataSource _dataSource;

  @override
  AccessibilitySettings loadSettings() {
    return _dataSource.loadSettings();
  }

  @override
  Future<void> saveSettings(AccessibilitySettings settings) {
    return _dataSource.saveSettings(settings);
  }
}
