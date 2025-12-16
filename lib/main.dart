import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentra_app/auth/auth_service.dart';
import 'package:mentra_app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] as String,
    anonKey: dotenv.env['ANON_KEY'] as String,
  );
  runApp(MyApp());
}

final Dio dio = Dio(
  BaseOptions(
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: ThemeData(primaryColor: Colors.black, textTheme: TextTheme()),
        // home: TodoScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel("samples.flutter.dev/battery");
  final AuthService _auth = AuthService();
  String _batteryLevel = 'Unknown battery level.';
  String _greeting = "No";
  String _email = "Unknown email";
  String _token = "none";
  User? user;
  Future<void> _getGreeting() async {
    String greeting = "";
    try {
      final result = await platform.invokeMethod<String>('getGreeting');
      greeting = result!;
    } on PlatformException catch (e) {
      greeting = "Failed to get Greeting: '${e.message}'.";
    }
    setState(() {
      _greeting = greeting;
    });
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel = "";
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> exchangeToken() async {
    try {
      final res = await dio.post(
        'https://devapi.mentra.glass/api/auth/exchange-token',
        data: {'supabaseToken': _token},
      );
      print("code ${res.statusCode} - body ${res.data}");
      if (res.statusCode == 200) {
        print("res : ${res.data}");
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "nit")));
    }
  }

  void signOut() {
    _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    _email = _auth.getUserByEmail()!;
    _token = _auth.getToken()!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getBatteryLevel();
                  _getGreeting();
                },
                child: Text("Get BatteryLevel"),
              ),
              Text(_batteryLevel),
              Text(_greeting),
              Text("email $_email"),
              Text("Token : $_token"),
              ElevatedButton(
                onPressed: () {
                  exchangeToken();
                },
                child: Text("Exchange Token"),
              ),
              ElevatedButton(
                onPressed: () {
                  signOut();
                },
                child: Text("Log out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
