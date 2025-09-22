import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  late final Stream<User?> _authChangesSubscription;

  AuthNotifier(this._authService) : super(AuthState()) {
    _authChangesSubscription = _authService.authStateChanges;
    _authChangesSubscription.listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.login(email, password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.signUp(email, password, name);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = state.copyWith(user: null);
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(AuthService()),
);
