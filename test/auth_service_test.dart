import 'package:flutter_test/flutter_test.dart';
import 'package:projet_animebook/services/auth_service.dart';

void main() {
  test('AuthService exposes a shared singleton instance', () {
    final first = AuthService();
    final second = AuthService();

    expect(identical(first, second), isTrue);
  });
}
