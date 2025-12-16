import 'package:flutter/material.dart';
import 'package:mentra_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  void setLoading(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  Future<void> signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      setLoading(true);
      final res = await _authService.singIn(email, password);
      await Future.delayed(Duration(microseconds: 200));
      if (mounted) {
        String jwt = res.session!.accessToken;
        print("token $jwt");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => HomeScreen()),
        );
      }
      setLoading(false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      "Sing In your account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      child: Text('Login'),
                      onPressed: () {
                        signIn();
                      },
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text("Don't have account?"),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          ),
                          child: Text("Sing Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    setIsLoading(true);
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("password not match")));
      setIsLoading(false);
      return;
    }
    try {
      final res = await _authService.signUp(email, password);
      await Future.delayed(Duration(microseconds: 200));
      if (res.session != null) {
        setIsLoading(false);
        Navigator.pop(context);
      }
    } on AuthApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign up failed: ${e.message}',
          ), // Access the message property
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sing Up")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                    ),

                    ElevatedButton(
                      child: Text('Sign Up'),
                      onPressed: () {
                        signUp();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
