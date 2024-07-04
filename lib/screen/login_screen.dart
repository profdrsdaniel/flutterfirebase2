import 'package:flutter/material.dart';
import 'package:projetoflutterapi/screen/home_screen.dart';
import 'package:projetoflutterapi/screen/register_screen.dart';
import 'package:projetoflutterapi/services/firebase/auth/firebase_auth_service.dart';
import 'package:projetoflutterapi/utils/results.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool enableVisibility = false;

  changeVisibility() {
    setState(() {
      enableVisibility = !enableVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Results>(
          stream: _auth.resultsLogin,
          builder: (context, snapshot) {
            ErrorResult result = ErrorResult(code: "");

            if (snapshot.data is ErrorResult) {
              result = snapshot.data as ErrorResult;
            }

            if (snapshot.data is LoadingResult) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is SuccessResult) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              });
            }

            return Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: enableVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        changeVisibility();
                      },
                      icon: enableVisibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String email = _emailController.text;
                    final String password = _passwordController.text;
                    _auth.signIn(email, password);
                  },
                  child: const Text("Logar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Registre-se"),
                ),
                if (result.code.isNotEmpty)
                  switch(result.code) {
                    "invalid-email" => Text("Autenticacao Invalida"),
                    "wrong-password" => Text("Autenticacao Invalida"),
                    _ => Text("Error")
                  }

              ],
            );
          },
        ),
      ),
    );
  }
}
