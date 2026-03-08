import 'package:fiap_hackathon/app/di/container_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await ContainerRegistry.reset();
  });

  test('should resolve manually registered dependency', () {
    ContainerRegistry.instance.registerSingleton<String>('ok');

    final value = ContainerRegistry.get<String>();

    expect(value, 'ok');
  });

  test('reset should clear registered dependencies', () async {
    ContainerRegistry.instance.registerSingleton<int>(7);

    await ContainerRegistry.reset();

    expect(() => ContainerRegistry.get<int>(), throwsA(isA<StateError>()));
  });
}
