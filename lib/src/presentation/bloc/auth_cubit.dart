import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SharedPreferences prefs;
  static const _kLoggedInKey = 'is_logged_in';
  static const _kEmailKey = 'user_email';

  AuthCubit(this.prefs) : super(AuthInitial());

  Future<void> checkAutoLogin() async {
    final loggedIn = prefs.getBool(_kLoggedInKey) ?? false;
    final email = prefs.getString(_kEmailKey);
    if (loggedIn && email != null) {
      emit(AuthAuthenticated(email));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 700)); // mock delay
    // very simple mock validation
    if (email.contains('@') && password.length >= 6) {
      await prefs.setBool(_kLoggedInKey, true);
      await prefs.setString(_kEmailKey, email);
      emit(AuthAuthenticated(email));
    } else {
      emit(const AuthError('بيانات الدخول غير صحيحة'));
    }
  }

  Future<void> logout() async {
    await prefs.remove(_kLoggedInKey);
    await prefs.remove(_kEmailKey);
    emit(AuthUnauthenticated());
  }
}
