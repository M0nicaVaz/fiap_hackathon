import 'package:fiap_hackathon/core/design_system/model/app_design_system.dart';
import 'package:flutter/widgets.dart';

class DesignSystemProvider extends InheritedWidget {
  final AppDesignSystem ds;

  const DesignSystemProvider({
    super.key,
    required this.ds,
    required super.child,
  });

  static AppDesignSystem of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DesignSystemProvider>();
    return provider!.ds;
  }

  @override
  bool updateShouldNotify(DesignSystemProvider oldWidget) {
    return ds != oldWidget.ds;
  }
}

extension DesignSystemExtension on BuildContext {
  AppDesignSystem get ds => DesignSystemProvider.of(this);
}
