import 'package:e_voting_app/adminpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'registration_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 160,
            ),
            Row(
              children: [
                Image.asset(
                  "lib/images/images (19).png",
                  width: 60,
                  height: 60,
                ),
                Column(
                  children: [
                    Text(
                      "Fatima College, Madurai",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Department of Computer Applications",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Image.asset(
                  "lib/images/logo2.jpg",
                  width: 60,
                  height: 60,
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            const Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please log in to access your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Register Number',
              hintText: 'Enter your Register Number',
              labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value.toString() == 'ADMIN') return null;
              if (value == null ||
                  value.length < 8 ||
                  !value.contains("2022") ||
                  !value.contains("BCA")) {
                return 'Please enter a valid register number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (emailController.text == 'ADMIN')
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdminPage(),
                  ));
                else
                  signIn(
                      context, emailController.text, passwordController.text);
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                text: "Don't have an account? ",
                children: [
                  TextSpan(
                    text: 'Register here',
                    style: const TextStyle(
                      color: Color(0xFF1E40AF),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
