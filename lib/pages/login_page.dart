import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> login() async {
    final res = await Supabase.instance.client.auth.signInWithPassword(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    if (res.session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  Future<void> signup() async {
    final res = await Supabase.instance.client.auth.signUp(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
      );


    if (res.user != null) {
      await Supabase.instance.client.from('profiles').insert({
        'id': res.user!.id,
        'mode': 'normal',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(hintText: 'Email')),
            TextField(controller: passCtrl, decoration: InputDecoration(hintText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Log In')),
            TextButton(onPressed: signup, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
