import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercestore/src/presentation/bloc/auth_cubit.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('checkAutoLogin emits unauthenticated when no prefs', () async {
    final prefs = await SharedPreferences.getInstance();
    final cubit = AuthCubit(prefs);
    await cubit.checkAutoLogin();
    expect(cubit.state, isA<AuthUnauthenticated>());
  });

  test('login with valid credentials authenticates and stores prefs', () async {
    final prefs = await SharedPreferences.getInstance();
    final cubit = AuthCubit(prefs);
    await cubit.login('test@example.com', '123456');
    expect(cubit.state, isA<AuthAuthenticated>());
    expect(prefs.getBool('is_logged_in'), true);
    expect(prefs.getString('user_email'), 'test@example.com');
  });

  test('logout clears prefs and emits unauthenticated', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', 'x@x.com');
    final cubit = AuthCubit(prefs);
    await cubit.logout();
    expect(cubit.state, isA<AuthUnauthenticated>());
    expect(prefs.getBool('is_logged_in'), isNull);
  });
}

