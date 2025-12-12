import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  // sign in email password
  Future<AuthResponse> singIn(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // sing up email password
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabaseClient.auth.signUp(email: email, password: password);
  }

  // sign out
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  // get current user email
  String? getUserByEmail() {
    final session = supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getToken() {
    final session = supabaseClient.auth.currentSession;
    return session?.accessToken;
  }
}
