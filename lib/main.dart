import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Digunakan sekali untuk reset database jika terjadi error
  // await deleteDatabase(await getDatabasesPath() + '/passwords.db');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}