// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:mentra_app/auth/auth_service.dart';
import 'package:mentra_app/features/ble_device/presentation/screens/ble_screen.dart';

import 'auth/auth_gate.dart';

void main() async {
  await Supabase.initialize(
    url: "https://bvqnrwdibudqxcdhzyiz.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2cW5yd2RpYnVkcXhjZGh6eWl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMjA5OTEsImV4cCI6MjA4MDg5Njk5MX0.m2tj352PPLDgLuy4ZCVzAHr_26UdsXjpFksOVKwJZXE",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.black, textTheme: TextTheme()),
        home: AuthGate(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  String email;
  HomeScreen({Key? key, required this.email}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel("samples.flutter.dev/battery");
  final AuthService _auth = AuthService();
  String _batteryLevel = 'Unknown battery level.';
  String _greeting = "No";
  String _email = "Unknow email";
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
      print("token : $_token");
      final res = await http.post(
        Uri.parse("https://devapi.mentra.glass/api/auth/exchange-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'supabaseToken': _token}),
      );
      print("code ${res.statusCode} - body ${res.body}");
      if (res.statusCode == 200) {
        print("res : ${res.body}");
      }
    } catch (e) {
      throw (e);
    }
  }

  void signOut() {
    _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = _auth.getUserByEmail()!;
    _token = _auth.getToken()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
