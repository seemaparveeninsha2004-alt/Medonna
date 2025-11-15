import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Run the app
  runApp(const MedonnaApp());
}

class MedonnaApp extends StatelessWidget {
  const MedonnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medonna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // If user is logged in, go to HomePage, else LoginPage
    if (session != null) {
      return const HomePage();
    }
    return const LoginPage();
  }
}
