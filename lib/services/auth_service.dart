import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // Đăng ký
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data, // ← thêm parameter
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: data, // ← thêm dòng này
    );
  }

  // Đăng nhập
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Lắng nghe trạng thái auth
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
