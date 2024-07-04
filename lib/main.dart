import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projetoflutterapi/firebase_options.dart';
import 'package:projetoflutterapi/models/user_model.dart';
import 'package:projetoflutterapi/screen/home_screen.dart';
import 'package:projetoflutterapi/screen/login_screen.dart';
import 'package:projetoflutterapi/services/firebase/auth/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitializeApp(),
    );
  }
}

class InitializeApp extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();

  InitializeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: _auth.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return LoginPage();
      },
    );
  }
}
